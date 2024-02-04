module gray_count_tb ();

    timeunit 1ns;
    timeprecision 1ps;

    localparam time CLK_PERIOD         = 50ns;
    localparam time ACQ_DELAY          = 30ns;
    localparam time TEST_DELAY         = 35ns;
    localparam unsigned RST_CLK_CYCLES = 10;
    localparam unsigned DATA_WIDTH     = 8;
    localparam unsigned TOT_CHECKS     = 256;

    logic                  clk,
                           rst_n;

    logic [DATA_WIDTH-1:0] act_gray_count,    // actual response
                           acq_gray_count,    // acquired response
                           acq_gray_count_q1; // previously acquired response

    logic                  acq_valid;         // flag indicating acquisition data are valid

    clk_rst_gen #(
        .ClkPeriod   (CLK_PERIOD),
        .RstClkCycles(RST_CLK_CYCLES)
    ) i_clk_rst_gen (
        .clk_o (clk),
        .rst_no(rst_n)
    );

    // TODO: Instantiate the DUT.
    gray_counter dut (
        .clk_i       (clk),
        .rst_ni      (rst_n),
        .gray_count_o(act_gray_count)
    );

    // Acquire the response.
    initial begin: acquisition_monitor_block
        acq_gray_count = '0;
        acq_valid      = 1'b0;
        wait (rst_n);
        forever begin
            @(posedge clk);
            acq_valid = 1'b0;
            #(ACQ_DELAY);
            acq_gray_count = act_gray_count;
            acq_valid = 1'b1;
        end
    end

    // Check response
    initial begin: checker_block
        integer n_checks;
        integer n_errs;
        logic   is_error;
        n_checks          = 0;
        n_errs            = 0;
        is_error          = 0;
        acq_gray_count_q1 = '0;
        wait (rst_n);
        while (n_checks < TOT_CHECKS) begin
            @(posedge clk);
            #(TEST_DELAY);
            if (acq_valid) begin
                n_checks += 1;
                // TODO: Add self-checking testbench code.
                next_gray_check(is_error);
                if(is_error) begin
                    n_errs += 1;
                    $display("Mismatch occured at ", $time);
                end
                acq_gray_count_q1 = acq_gray_count;
            end
        end
        if (n_errs > 0) begin
            $display("Test failed with ", n_errs, " mismatches out of ", n_checks, " checks!");
        end else begin
            $display("Test passed with ", n_errs, " mismatches out of ", n_checks, " checks.");
        end
        $stop();
    end

    task next_gray_check (output logic is_error);
        // TODO: Write your task here.
        // logic [DATA_WIDTH-1:0] diffs;
        // integer diff_num;
        // diffs = acq_gray_count ^ acq_gray_count_q1;
        // diff_num = 0;
        // for(int i = 0; i < DATA_WIDTH; i++) begin
        //     if(diffs[i]) begin
        //         diff_num += 1;
        //     end
        // end
        // if(diff_num == 1) begin
        //     is_error = 0;
        // end
        // else begin
        //     is_error = 1;
        // end

        is_error = !$onehot(acq_gray_count ^ acq_gray_count_q1);
    endtask

endmodule
