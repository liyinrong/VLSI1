// Copyright (c) 2022 Integrated Systems Laboratory, ETH Zurich
// Used for the VLSI 1 course
//
// Author: Marco Bertuletti <mbertuletti@iis.ee.ethz.ch>

module tb_simple_fsm #(
  parameter string StimFileName = "../simvectors/fsm_stimuli.asc",
  // parameter string ExpectedFileName = "../simvectors/fsm_initial_expresp.asc"
  parameter string ExpectedFileName = "../simvectors/fsm_change2_expresp.asc"
) ();

    timeunit 1ns;
    timeprecision 10ps;

    localparam time CLK_PERIOD          = 50ns;
    localparam unsigned RST_CLK_CYCLES  = 10;
    localparam time APPL_DELAY          = CLK_PERIOD / 4;
    localparam time ACQ_DELAY           = CLK_PERIOD * 3 / 4;

    logic           clk,
                    rst_n;

    logic [15:0]    stim,
                    act_resp,
                    exp_resp;
    string reference = "%%";

    simple_fsm dut (
        .clk_i    (clk),
        .rst_ni   (rst_n),
        .in_i     (stim[15:0]),
        .out_o    (act_resp[15:0])
    );

    clk_rst_gen #(
        .ClkPeriod     (CLK_PERIOD),
        .RstClkCycles (RST_CLK_CYCLES)
    ) i_clk_rst_gen (
        .clk_o  (clk),
        .rst_no ()
    );

    // Apply stimuli from file.
    initial begin: stim_appl
        integer stim_fd;
        string line;
        stim_fd = $fopen(StimFileName, "r");
        if (stim_fd == 0) begin
            $fatal("Could not open stimuli file!");
        end

        stim = '0;
        $fgets(line, stim_fd);
        while (line.substr(0,0) == reference.substr(0,0) && !$feof(stim_fd)) begin
            $fgets(line,stim_fd);
        end
        // wait (rst_n);
        while (!$feof(stim_fd)) begin
            @(posedge clk);
            #(APPL_DELAY);
            rst_n = line.substr(0,0).atobin();
            stim = line.substr(2,17).atobin();
            $fgets(line,stim_fd);
        end
        $fclose(stim_fd);
    end

    // Check actual against expected responses from file.
    initial begin: exp_resp_acq_check
        integer exp_resp_fd, n_errs, n_checks;
        string rline;
        exp_resp_fd = $fopen(ExpectedFileName, "r");
        if (exp_resp_fd == 0) begin
            $fatal("Could not open expected responses file!");
        end
        n_errs = 0;
        n_checks = 0;
        exp_resp = '0;

        $fgets(rline, exp_resp_fd);
        while(rline.substr(0,0) == reference.substr(0,0) && !$feof(exp_resp_fd)) begin
            $fgets(rline, exp_resp_fd);
        end
        // wait (rst_n);
        while (!$feof(exp_resp_fd)) begin
            @(posedge clk);
            #(ACQ_DELAY);
            exp_resp = rline.substr(0,15).atobin();
            if (act_resp != rline.substr(0,15).atobin()) begin
                $error("Expected %b, got %b!", exp_resp, act_resp);
                n_errs += 1;
            end
            n_checks += 1;
            $fgets(rline, exp_resp_fd);
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
