module rgb_proc_tb ();

    timeunit 1ns;
    timeprecision 1ps;

    localparam time ClkPeriod  = 10ns;
    localparam time ApplDelay  = ClkPeriod / 4;       // Stimulus application delay
    localparam time AcqDelay   = ClkPeriod * 3 / 4;   // Response acquisition delay

    logic       clk,
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
                oup_ready,
                hop_pulse,
                toggle_pulse;

    logic       hop_d, hop_q,
                toggle_d, toggle_q;

    logic [1:0] pos_d,      pos_q;

    logic [3:0] enable_d,   enable_q;

    logic [7:0] inp_r,
                inp_g,
                inp_b,
                oup_r,
                oup_g,
                oup_b;

    // Unit Under Test (UUT)
    rgb_proc #(
        .DebounceCycles (1)
    ) uut (
        .clk_i      (clk),
        .rst_ni     (rst_n),

        .btn_i      ({toggle_d, hop_d}),
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
        .ClkPeriod     (ClkPeriod),
        .RstClkCycles (10)
    ) i_clk_rst_gen (
        .clk_o  (clk),
        .rst_no (rst_n)
    );

    // Randomizing Video Input Master
    rand_stream_mst #(
        .data_t             (logic[26:0]),
        .MinWaitCycles    (1),
        .MaxWaitCycles    (10),
        .ApplDelay         (ApplDelay),
        .AcqDelay          (AcqDelay)
    ) i_inp_mst (
        .clk_i      (clk),
        .rst_ni     (rst_n),

        .data_o     ({inp_r, inp_g, inp_b, inp_hsync, inp_vsync, inp_vde}),
        .valid_o    (inp_valid),
        .ready_i    (inp_ready)
    );

    // Randomizing Video Output Slave
    rand_stream_slv #(
        .data_t             (logic[26:0]),
        .MinWaitCycles    (1),
        .MaxWaitCycles    (4),
        .ApplDelay         (ApplDelay),
        .AcqDelay          (AcqDelay),
        .Enqueue            (1'b0)
    ) i_oup_slv (
        .clk_i      (clk),
        .rst_ni     (rst_n),

        .data_i     ({oup_r, oup_g, oup_b, oup_hsync, oup_vsync, oup_vde}),
        .valid_i    (oup_valid),
        .ready_o    (oup_ready)
    );

    // Randomized Input Generation: hop and toggle
    rand_synch_driver #(
        .T                  (logic),
        .MinWaitCycles    (3),
        .MaxWaitCycles    (100),
        .ApplDelay         (ApplDelay)
    ) i_hop_driver (
        .clk_i  (clk),
        .rst_ni (rst_n),
        .oup_o  (hop_d)
    );
    rand_synch_driver #(
        .T                  (logic),
        .MinWaitCycles    (3),
        .MaxWaitCycles    (100),
        .ApplDelay         (ApplDelay)
    ) i_toggle_driver (
        .clk_i  (clk),
        .rst_ni (rst_n),
        .oup_o  (toggle_d)
    );

    // Assert that the FSM correctly sets the enable signals based on hop and toggle input.
    assign hop_pulse    = uut.hop && !hop_q;
    assign toggle_pulse = uut.toggle && !toggle_q;

    always_comb begin
        enable_d = enable_q;
        pos_d    = pos_q;
        if (toggle_pulse) begin
            enable_d[pos_q] = !enable_q[pos_q];
        end
        if (hop_pulse) begin
            if (pos_q < 2'd3) begin
                pos_d += 1;
            end else begin
                pos_d = '0;
            end
        end
    end

    initial begin : checker_block
        wait (rst_n);
        while (1) begin
            @(posedge clk);
            #(AcqDelay);
            if (enable_q !== uut.filt_enable) begin
                $display("enable state mismatch occured at %d ns: actual %b golden %b",
                        $time, uut.filt_enable, enable_q);
            end else begin

            end
        end
    end

    initial begin
        #(3000*ClkPeriod);
        $display("simulation done");
        $stop;
    end

    rgb_proc_tester #(
        .AcqDelay(AcqDelay)
    ) i_vid_tester (
        .clk_i        ( clk                     ),
        .filt_enable_i( enable_q                ),
        .r_inp_i      ( inp_r                   ),
        .g_inp_i      ( inp_g                   ),
        .b_inp_i      ( inp_b                   ),
        .hsync_inp_i  ( inp_hsync               ),
        .vsync_inp_i  ( inp_vsync               ),
        .vde_inp_i    ( inp_vde                 ),
        .r_oup_i      ( oup_r                   ),
        .g_oup_i      ( oup_g                   ),
        .b_oup_i      ( oup_b                   ),
        .hsync_oup_i  ( oup_hsync               ),
        .vsync_oup_i  ( oup_vsync               ),
        .vde_oup_i    ( oup_vde                 ),
        .p0valid_i    ( inp_valid               ),
        .p0ready_i    ( inp_ready               ),
        .p1valid_i    ( uut.i_vid_pipe.valid_p1 ),
        .p1ready_i    ( uut.i_vid_pipe.ready_p1 ),
        .p2valid_i    ( uut.i_vid_pipe.valid_p2 ),
        .p2ready_i    ( uut.i_vid_pipe.ready_p2 ),
        .p3valid_i    ( uut.i_vid_pipe.valid_p3 ),
        .p3ready_i    ( uut.i_vid_pipe.ready_p3 ),
        .p4valid_i    ( oup_valid               ),
        .p4ready_i    ( oup_ready               )
    );

    // Registers
    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            enable_q    <= '0;
            hop_q      <= 1'b0;
            pos_q       <= '0;
            toggle_q   <= 1'b0;
        end else begin
            enable_q    <= enable_d;
            hop_q       <= uut.hop;
            pos_q       <= pos_d;
            toggle_q    <= uut.toggle;
        end
    end
    //assign hop_d = uut.hop;
    //assign toggle_d = uut.toggle;

endmodule
