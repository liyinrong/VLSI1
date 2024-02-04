/**
  * Top-Level Module for RGB Processing
  */
module rgb_proc (
    input  logic        clk_i,
    input  logic        rst_ni,

    input  logic [2:0]  switch_i,
    input  logic [2:0]  btn_i,
    output logic [3:0]  led_o,

    input  logic [7:0]  r_i,
    input  logic [7:0]  g_i,
    input  logic [7:0]  b_i,
    input  logic        hsync_i,
    input  logic        vsync_i,
    input  logic        vde_i,
    input  logic        valid_i,
    output logic        ready_o,

    output logic [7:0]  r_o,
    output logic [7:0]  g_o,
    output logic [7:0]  b_o,
    output logic        hsync_o,
    output logic        vsync_o,
    output logic        vde_o,
    output logic        valid_o,
    input  logic        ready_i
);

    typedef struct packed {
        logic vsync, hsync, vde;
    } meta_t;

    meta_t  meta_inp,
            meta_oup;

    typedef logic [7:0] color_t;
    typedef struct packed {
        color_t r, g, b;
    } rgb_t;

    enum {
        FILT_READY, FILT_START, FILT_WAIT, FILT_SYNC
    } filter_state_q, filter_state_d;
    enum {
        IMG_WAIT_HI, IMG_WAIT_LO, IMG_SYNC
    } image_state_q, image_state_d;

    rgb_t   filt_inp,       filt_oup;

    logic   filt_inp_valid, filt_inp_ready,
            filt_oup_valid, filt_oup_ready,
            inp_filt_valid, inp_filt_ready,
            meta_push,      meta_pop,
            meta_full,      meta_empty,
            filt_fifo_push, filt_fifo_pop,
            filt_fifo_full, filt_fifo_empty,
            filt_ap_done,   filt_ap_start,
            filt_ap_ready,  filt_ap_idle;

    logic [2:0] btn;

    for (genvar i = 0; i < 3; i++) begin: gen_debouncer
        debouncer #(
            .NumCycles   (50_000)
        ) i_debouncer (
            .clk_i  (clk_i),
            .rst_ni (rst_ni),
            .inp_i  (btn_i[i]),
            .oup_o  (btn[i])
        );
    end

    filter_hls i_filter (
        .ap_clk          (clk_i),
        .ap_rst_n        (rst_ni),
        .data_in_TDATA   (filt_inp),
        .data_in_TVALID  (~filt_fifo_empty),
        .data_in_TREADY  (filt_fifo_pop),
        .data_out_TDATA  (filt_oup),
        .data_out_TVALID (filt_oup_valid),
        .data_out_TREADY (filt_oup_ready),
        .ap_done         (filt_ap_done),
        .ap_start        (filt_ap_start),
        .ap_ready        (filt_ap_ready),
        .ap_idle         (filt_ap_idle)
    );

    stream_fork #(
        .N_OUP  (2)
    ) i_inp_fork (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),
        .valid_i    (valid_i),
        .ready_o    (ready_o),
        .valid_o    ({meta_push, inp_filt_valid}),
        .ready_i    ({~meta_full, inp_filt_ready})
    );

    stream_filter i_inp_filt (
        .valid_i    (inp_filt_valid),
        .ready_o    (inp_filt_ready),
        .drop_i     ((~vde_i && valid_i) || filt_ap_idle),   // Prevent off-screen pixels from going through HLS filter.
        .valid_o    (filt_fifo_push),
        .ready_i    (~filt_fifo_full)
    );

    fifo_v3 #(
        .FALL_THROUGH   (1'b0),
        .DEPTH          (1000),   // incl blanks for 1920 horizontal pixels, 5 rows in filter
        .dtype          (rgb_t)
    ) i_filter_fifo (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),
        .flush_i    (1'b0),
        .testmode_i (1'b0),
        .usage_o    (),

        .data_i     ({r_i, g_i, b_i}),
        .push_i     (filt_fifo_push),
        .full_o     (filt_fifo_full),

        .data_o     (filt_inp),
        .pop_i      (filt_fifo_pop && ~filt_fifo_empty),
        .empty_o    (filt_fifo_empty)
    );

    assign meta_inp = {vsync_i, hsync_i, vde_i};
    fifo_v3 #(
        .FALL_THROUGH   (1'b0),
        .DEPTH          (10*2200),   // incl blanks for 1920 horizontal pixels, 5 rows in filter
        .dtype          (meta_t)
    ) i_meta_fifo (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),
        .flush_i    (1'b0),
        .testmode_i (1'b0),
        .usage_o    (),

        .data_i     (meta_inp),
        .push_i     (meta_push),
        .full_o     (meta_full),

        .data_o     (meta_oup),
        .pop_i      (meta_pop),
        .empty_o    (meta_empty)
    );
    assign {vsync_o, hsync_o, vde_o} = meta_oup;
    assign meta_pop = valid_o && ready_i;

    // Control output flow
    always_comb begin
        // Defaults: output invalid, black pixel, filter output handshake disabled, meta pop
        // disabled
        valid_o = 1'b0;
        r_o = '0;
        g_o = '0;
        b_o = '0;
        filt_oup_ready = 1'b0;

        if (~meta_empty) begin
            if (meta_oup.vde) begin
                // On-screen pixel -> get RGB of pixel from filter
                if (filt_ap_idle) begin
                    // Filter inactive during the current frame -> black pixel with meta
                    valid_o = 1'b1;
                end else begin
                    // Filter active -> get RGB of pixel from filter
                    valid_o = filt_oup_valid;
                    filt_oup_ready = ready_i;
                    r_o = filt_oup.r;
                    g_o = filt_oup.g;
                    b_o = filt_oup.b;
                end
            end else begin
                // Off-screen pixel -> black pixel with meta
                valid_o = 1'b1;
            end
        end
    end

    // Synchronisation FSM for filter operation.
    always_comb begin
        filter_state_d = filter_state_q;
        filt_ap_start = 0;

        case (filter_state_q)
            // Wait for the filter to become idle or ready and start operation.
            FILT_READY:
                if (filt_ap_idle || filt_ap_ready)
                    filter_state_d = FILT_START;

            // Set the start signal for one cycle.
            FILT_START: begin
                filter_state_d = FILT_WAIT;
                filt_ap_start = 1;
            end

            // Wait for the filter to finish operation or become ready to start
            // a new operation.
            FILT_WAIT:
                if (filt_ap_ready || filt_ap_done)
                    filter_state_d = FILT_SYNC;

            // Synchronize with the image frame.
            FILT_SYNC:
                if (image_state_q == IMG_SYNC)
                    filter_state_d = FILT_READY;

            default:
                filter_state_d = FILT_SYNC;
        endcase
    end

    // Synchronisation FSM for image frames.
    always_comb begin
        image_state_d = image_state_q;

        case (image_state_q)
            // Wait for the VSYNC to start.
            IMG_WAIT_HI:
                if (meta_push && meta_inp.vsync)
                    image_state_d = IMG_WAIT_LO;

            // Wait for the VSYNC to end.
            IMG_WAIT_LO:
                if (meta_push && !meta_inp.vsync)
                    image_state_d = IMG_SYNC;

            // Synchronize with the filter.
            IMG_SYNC:
                if (filter_state_q == FILT_SYNC)
                    image_state_d = IMG_WAIT_HI;
            default:
                image_state_d = IMG_WAIT_HI;
        endcase
    end

    always_ff @(posedge clk_i, negedge rst_ni) begin
        if (~rst_ni) begin
            filter_state_q <= FILT_SYNC;
            image_state_q  <= IMG_WAIT_HI;
        end else begin
            filter_state_q <= filter_state_d;
            image_state_q  <= image_state_d;
        end
    end

endmodule
