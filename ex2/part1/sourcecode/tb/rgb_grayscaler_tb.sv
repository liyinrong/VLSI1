module rgb_grayscaler_tb ();

    localparam time CLK_PERIOD          = 50ns;
    localparam unsigned RST_CLK_CYCLES  = 10;
    localparam time APPL_DELAY          = CLK_PERIOD / 4;
    localparam time ACQ_DELAY           = CLK_PERIOD * 3 / 4;

    logic           clk,
                    rst_n;

    logic [23:0]    stim,
                    act_resp,
                    exp_resp;

    rgb_grayscaler_refined dut (
        .r_i    (stim[23:16]),
        .g_i    (stim[15:8]),
        .b_i    (stim[7:0]),
        .r_o    (act_resp[23:16]),
        .g_o    (act_resp[15:8]),
        .b_o    (act_resp[7:0])
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
        integer stim_fd = $fopen("stimuli_grayscaler.txt", "r");
        if (stim_fd == 0) begin
            $fatal("Could not open stimuli file!");
        end
        stim = '0;
        wait (rst_n);
        while (!$feof(stim_fd)) begin
            @(posedge clk);
            #(APPL_DELAY);
            $fscanf(stim_fd, "%h\n", stim);
        end
        $fclose(stim_fd);
    end

    // Check actual against expected responses from file.
    initial begin: exp_resp_acq_check
        integer exp_resp_fd, n_errs, n_checks;
        exp_resp_fd = $fopen("exp_resp_grayscaler.txt", "r");
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
            $fscanf(exp_resp_fd, "%h\n", exp_resp);
            #(ACQ_DELAY-APPL_DELAY);
            assert (exp_resp == act_resp) else begin
                $error("Expected %h, got %h!", exp_resp, act_resp);
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
        $finish();
    end

endmodule
