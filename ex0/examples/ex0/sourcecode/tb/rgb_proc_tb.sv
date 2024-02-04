module rgb_proc_tb ();

    localparam time CLK_PERIOD  = 10ns;
    localparam time APPL_DELAY  = CLK_PERIOD / 4;       // Stimulus application delay
    localparam time ACQ_DELAY   = CLK_PERIOD * 3 / 4;   // Response acquisition delay

    localparam integer  X_RESOLUTION = 20;
    localparam integer  Y_RESOLUTION = 8;

    logic           clk,
                    rst_n,
                    inp_hsync,
                    inp_vsync,
                    inp_vde,
                    inp_valid,
                    inp_ready,
                    oup_hsync,
                    oup_vsync,
                    oup_vde,
                    oup_valid,
                    oup_ready;

    logic           hsync_d,    hsync_q,
                    x_edge_d,   x_edge_q,
                    y_edge_d,   y_edge_q;

    logic [31:0]    x_count_d,  x_count_q,
                    y_count_d,  y_count_q;

    logic [7:0]     inp_r,
                    inp_g,
                    inp_b,
                    oup_r,
                    oup_g,
                    oup_b;

    // Unit Under Test (UUT)
    rgb_proc #(
        .X_RESOLUTION       (X_RESOLUTION),
        .Y_RESOLUTION       (Y_RESOLUTION),
        .DEBOUNCE_CYCLES    (1)
    ) uut (
        .clk_i      (clk),
        .rst_ni     (rst_n),

        .btn_i      ('0),
        .led_o      (),

        .r_i        (inp_r),
        .g_i        (inp_g),
        .b_i        (inp_b),
        .hsync_i    (inp_hsync),
        .vsync_i    (inp_vsync),
        .vde_i      (inp_vde),
        .valid_i    (inp_valid),
        .ready_o    (inp_ready),

        .r_o        (oup_r),
        .g_o        (oup_g),
        .b_o        (oup_b),
        .hsync_o    (oup_hsync),
        .vsync_o    (oup_vsync),
        .vde_o      (oup_vde),
        .valid_o    (oup_valid),
        .ready_i    (oup_ready)
    );

    // Clock and Reset Generator
    clk_rst_gen #(
        .CLK_PERIOD     (CLK_PERIOD),
        .RST_CLK_CYCLES (10)
    ) i_clk_rst_gen (
        .clk_o  (clk),
        .rst_no (rst_n)
    );

    // Randomizing Video Input Master
    rand_stream_mst #(
        .data_t             (logic[23:0]),
        .MIN_WAIT_CYCLES    (1),
        .MAX_WAIT_CYCLES    (10),
        .APPL_DELAY         (APPL_DELAY),
        .ACQ_DELAY          (ACQ_DELAY)
    ) i_inp_mst (
        .clk_i      (clk),
        .rst_ni     (rst_n),

        .data_o     ({inp_r, inp_g, inp_b}),
        .valid_o    (inp_valid),
        .ready_i    (inp_ready)
    );

    // Randomizing Video Output Slave
    rand_stream_slv #(
        .data_t             (logic[26:0]),
        .MIN_WAIT_CYCLES    (1),
        .MAX_WAIT_CYCLES    (4),
        .APPL_DELAY         (APPL_DELAY),
        .ACQ_DELAY          (ACQ_DELAY),
        .ENQUEUE            (1'b0)
    ) i_oup_slv (
        .clk_i      (clk),
        .rst_ni     (rst_n),

        .data_i     ({oup_r, oup_g, oup_b, oup_hsync, oup_vsync, oup_vde}),
        .valid_i    (oup_valid),
        .ready_o    (oup_ready)
    );

    hdmi_sync_gen #(
      .X_RESOLUTION (X_RESOLUTION),
      .Y_RESOLUTION (Y_RESOLUTION),
      .APPL_DELAY   (APPL_DELAY)
    ) i_hdmi_sync_gen (
        .clk_i    (clk),
        .rst_ni   (rst_n),
        .vsync_o  (inp_vsync),
        .hsync_o  (inp_hsync),
        .vde_o    (inp_vde)
    );

    rgb_proc_tester #(
        .ACQ_DELAY  (ACQ_DELAY)
    ) i_vid_tester (
        .clk_i             (clk),
        .filt_enable_i     (uut.filt_enable),

        .r_inp_i           (inp_r),
        .g_inp_i           (inp_g),
        .b_inp_i           (inp_b),
        .hsync_inp_i       (inp_hsync),
        .vsync_inp_i       (inp_vsync),
        .vde_inp_i         (inp_vde),

        .r_oup_i           (oup_r),
        .g_oup_i           (oup_g),
        .b_oup_i           (oup_b),
        .hsync_oup_i       (oup_hsync),
        .vsync_oup_i       (oup_vsync),
        .vde_oup_i         (oup_vde),

        .p0valid_i         (inp_valid),
        .p0ready_i         (inp_ready),
        .p1valid_i         (uut.i_vid_pipe.valid_p1),
        .p1ready_i         (uut.i_vid_pipe.ready_p1),
        .p2valid_i         (uut.i_vid_pipe.valid_p2),
        .p2ready_i         (uut.i_vid_pipe.ready_p2),
        .p3valid_i         (uut.i_vid_pipe.valid_p3),
        .p3ready_i         (uut.i_vid_pipe.ready_p3),
        .p4valid_i         (oup_valid),
        .p4ready_i         (oup_ready)
    );

    // Assert that the counters correctly compute the edges of the image.
    assign hsync_d = (uut.valid_i && uut.ready_o) ? uut.hsync_i : hsync_q;
    always_comb begin
        x_count_d   = x_count_q;
        x_edge_d    = 1'b0;
        y_count_d   = y_count_q;
        y_edge_d    = 1'b0;
        if (uut.valid_i && uut.ready_o) begin
            if (uut.hsync_i) begin
                x_count_d = '0;
            end else if (uut.vde_i) begin
                x_count_d += 1;
                if (x_count_q == (uut.X_RESOLUTION / uut.X_NUM_SECTIONS)) begin
                    x_count_d   = '0;
                    x_edge_d    = 1'b1;
                end
            end
            if (uut.vsync_i) begin
                y_count_d = '0;
            end else if (uut.hsync_i && !hsync_q) begin
                y_count_d += 1;
                if (y_count_q == (uut.Y_RESOLUTION / uut.Y_NUM_SECTIONS)) begin
                    y_count_d   = '0;
                    y_edge_d    = 1'b1;
                end
            end
        end
    end

    initial begin: x_checker_block
        wait (rst_n);
        while (1) begin
            @(posedge clk);
            #(ACQ_DELAY);
            if (x_edge_q !== uut.x_edge) begin
                $display("x_edge mistmatch occured at %d ns: actual %b expected %b",
                        $time, uut.x_edge, x_edge_q);
            end
        end
    end

    initial begin: y_checker_block
        wait (rst_n);
        while (1) begin
            @(posedge clk);
            #(ACQ_DELAY);
            if (y_edge_q !== uut.y_edge) begin
                $display("y_edge mistmatch occured at %d ns: actual %b expected %b",
                        $time, uut.y_edge, y_edge_q);
            end
        end
    end

    initial begin
        #(3000*CLK_PERIOD);
        $display("simulation done");
        $stop;
    end

    // Registers
    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            hsync_q     <= 1'b0;
            x_count_q   <= '0;
            x_edge_q    <= 1'b0;
            y_count_q   <= '0;
            y_edge_q    <= 1'b0;
        end else begin
            hsync_q     <= hsync_d;
            x_count_q   <= x_count_d;
            x_edge_q    <= x_edge_d;
            y_count_q   <= y_count_d;
            y_edge_q    <= y_edge_d;
        end
    end

endmodule