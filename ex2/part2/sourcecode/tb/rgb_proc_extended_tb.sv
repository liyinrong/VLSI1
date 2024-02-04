module rgb_proc_extended_tb ();

    localparam time CLK_PERIOD          = 50ns;
    localparam unsigned RST_CLK_CYCLES  = 10;

    typedef struct packed {
        logic [2:0] switch;
        logic       hsync;
        logic       vsync;
        logic       vde;
        logic       valid;
        logic       ready;
        logic [7:0] r;
        logic [7:0] g;
        logic [7:0] b;
    } data_t;

    logic   clk,
            rst_n;

    data_t  stim,
            act_resp,
            exp_resp;

    assign act_resp.switch = '0;

    rgb_proc dut (
        .clk_i      (clk),
        .rst_ni     (rst_n),

        .switch_i   (stim.switch),

        .r_i        (stim.r),
        .g_i        (stim.g),
        .b_i        (stim.b),
        .hsync_i    (stim.hsync),
        .vsync_i    (stim.vsync),
        .vde_i      (stim.vde),
        .valid_i    (stim.valid),
        .ready_o    (act_resp.ready),

        .r_o        (act_resp.r),
        .g_o        (act_resp.g),
        .b_o        (act_resp.b),
        .hsync_o    (act_resp.hsync),
        .vsync_o    (act_resp.vsync),
        .vde_o      (act_resp.vde),
        .valid_o    (act_resp.valid),
        .ready_i    (stim.ready)
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
        integer stim_fd = $fopen("stimuli_rgb_proc.txt", "r");
        if (stim_fd == 0) begin
            $fatal("Could not open stimuli file!");
        end
        stim = '0;
        wait (rst_n);
        while (!$feof(stim_fd)) begin
            @(posedge clk)
            #(CLK_PERIOD/4);
            $fscanf(stim_fd, "%h\n", stim);
        end
        $fclose(stim_fd);
    end

    // Check actual against expected responses from file.
    initial begin: exp_resp_acq_check
        integer exp_resp_fd, n_errs, n_checks;
        exp_resp_fd = $fopen("exp_resp_rgb_proc_extended.txt", "r");
        if (exp_resp_fd == 0) begin
            $fatal("Could not open expected responses file!");
        end
        n_errs = 0;
        n_checks = 0;
        exp_resp = '0;
        wait (rst_n);
        while (!$feof(exp_resp_fd)) begin
            @(posedge clk);
            #(CLK_PERIOD/4);
            $fscanf(exp_resp_fd, "%h\n", exp_resp);
            #(CLK_PERIOD/2);
            assert (exp_resp == act_resp) else begin
                $error("Expected %h, got %h (with switches %03b)!",
                    exp_resp, act_resp, stim.switch);
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
