// Copyright (c) 2022 Integrated Systems Laboratory, ETH Zurich
// Used for the VLSI 1 course
//
// Author: Marco Bertuletti <mbertuletti@iis.ee.ethz.ch>

module tb_rgb_grayscaler ();

    localparam time ClkPeriod = 50ns;
    logic           en;
    logic [7:0]     inp_r;
    logic [7:0]     inp_g;
    logic [7:0]     inp_b;
    logic [7:0]     oup_gray;
    int unsigned num_errors;

    // Design Under Test (DUT)
    rgb_grayscaler dut (
        .en_i       (en),
        .r_i        (inp_r),
        .g_i        (inp_g),
        .b_i        (inp_b),
        .gray_o     (oup_gray)
    );

    // Initialize inputs
    initial begin

        num_errors = 0;

        en  = 0;
        // Set orange as input color
        inp_r = 8'd255;
        inp_g = 8'd128;
        inp_b = 8'd0;
        #(20 * ClkPeriod);
        if (oup_gray !== 8'd128) begin
            $error("Output is not correctly multiplexed!");
            num_errors += 1;
        end

        // Set enable
        #(20 * ClkPeriod);
        en <= 1;

        // Set aquamarine blue
        #(20 * ClkPeriod);
        inp_r = 8'd0;
        inp_g = 8'd204;
        inp_b = 8'd204;
        #(20 * ClkPeriod);
        if (oup_gray !== 8'd144) begin
            $error("Grayscale is not correctly computed!");
            num_errors += 1;
        end

        // Unset enable
        #(20 * ClkPeriod);
        en = 0;

        // Set Schiapparelli pink
        #(20 * ClkPeriod);
        inp_r = 8'd237;
        inp_g = 8'd73;
        inp_b = 8'd153;
        #(20 * ClkPeriod);
        if (oup_gray !== 8'd128) begin
            $error("Output is not correctly multiplexed!");
            num_errors += 1;
        end

        $display("Finished simulation with %d Errors.", num_errors);
        if (num_errors == '0) begin
            $display("TEST SUCCEEDED");
        end else begin
            $display("TEST FAILED");
        end
        $stop();
    end


endmodule
