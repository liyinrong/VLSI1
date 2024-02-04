// Copyright (c) 2022 Integrated Systems Laboratory, ETH Zurich
// Used for the VLSI 1 course
//
// Author: Marco Bertuletti <mbertuletti@iis.ee.ethz.ch>


module tb_shiftreg #(
  parameter string StimFileName = "../simvectors/stimuli_shiftreg.txt",
  parameter string ExpectedFileName = "../simvectors/exp_resp_shiftreg.txt"
) ();

    timeunit 1ns;
    timeprecision 10ps;

    localparam time CLK_PERIOD          = 50ns;
    localparam unsigned RST_CLK_CYCLES  = 10;
    localparam time APPL_DELAY          = CLK_PERIOD / 4;
    localparam time ACQ_DELAY           = CLK_PERIOD * 3 / 4;

    logic           clk,
                    rst_n;

    logic [4:0]     stim;
    logic [12:0]    act_resp,
                    exp_resp;

    shiftreg dut(
        .clk_i  (clk),
        .rst_ni (rst_n),
        .in_i   (stim),
        .out_o  (act_resp)
    );

    clk_rst_gen #(
        .ClkPeriod     (CLK_PERIOD),
        .RstClkCycles (RST_CLK_CYCLES)
    ) i_clk_rst_gen (
        .clk_o  (clk),
        .rst_no (rst_n)
    );

    // Apply stimuli from file.
    initial begin: stim_appl
        integer stim_fd = $fopen(StimFileName, "r");
        if (stim_fd == 0) begin
            $fatal("Could not open stimuli file!");
        end
        stim = '0;
        wait (rst_n);
        while (!$feof(stim_fd)) begin
            @(posedge clk);
            #(APPL_DELAY);
            $fscanf(stim_fd, "%b\n", stim);
        end
        $fclose(stim_fd);
    end

    // Check actual against expected responses from file.
    initial begin: exp_resp_acq_check
        integer exp_resp_fd, n_errs, n_checks;
        exp_resp_fd = $fopen(ExpectedFileName, "r");
        if (exp_resp_fd == 0) begin
            $fatal("Could not open expected responses file!");
        end
        n_errs = 0;
        n_checks = 0;
        exp_resp = '0;
        wait (rst_n);
        while (!$feof(exp_resp_fd)) begin
            @(posedge clk);
            #(APPL_DELAY);
            $fscanf(exp_resp_fd, "%b\n", exp_resp);
            #(ACQ_DELAY-APPL_DELAY);
            assert (exp_resp == act_resp) else begin
                $error("Expected %b, got %b!", exp_resp, act_resp);
                n_errs += 1;
            end
            n_checks += 1;
        end
        $fclose(exp_resp_fd);
        if (n_errs > 0) begin
            $display("Test failed with ", n_errs, " mismatches out of ", n_checks, " checks!");
        end else begin
            $display("Test passed with ", n_errs, " mismatches out of ", n_checks, " checks.");
        end
        #(CLK_PERIOD);
        $stop();
    end

endmodule
