module rgb_sat_fb_tb ();

    timeunit 1ns;
    timeprecision 10ps;

    localparam time CLK_PERIOD         = 50ns;
    localparam time APPL_DELAY         = 10ns;
    localparam time ACQ_DELAY          = 30ns;
    localparam unsigned RST_CLK_CYCLES = 10;
    localparam unsigned TIMEOUT_LIM    = 1000;

    typedef struct packed {
        logic [7:0] r,g,b;
    } rgb_t;

    rgb_t   act_resp, // actual response
            acq_resp, // acquired response
            exp_resp, // expected response
            stim;     // input stimulus

    integer n_stims,
            n_checks,
            n_errs,
            n_timeout;

    rgb_t   queue_mon2chk[$];

    logic   clk, rst_n,
            filt_enable,
            stim_applied,
            inp_valid,  inp_ready, // handshaking with DUT's input interface
            oup_valid,  oup_ready; // handshaking with DUT's output interface

    clk_rst_gen #(
        .ClkPeriod   (CLK_PERIOD),
        .RstClkCycles(RST_CLK_CYCLES)
    ) i_clk_rst_gen (
        .clk_o (clk),
        .rst_no(rst_n)
    );

    // TODO instantiate the DUT here
    rgb_top_wrap dut (
        .clk_i  (clk),
        .rst_ni (rst_n),
        .en_i   (filt_enable),
        .r_i    (stim.r),
        .g_i    (stim.g),
        .b_i    (stim.b),
        .valid_i(inp_valid),
        .ready_o(inp_ready),
        .r_o    (act_resp.r),
        .g_o    (act_resp.g),
        .b_o    (act_resp.b),
        .ready_i(oup_ready),
        .valid_o(oup_valid)
    );

    initial begin: application_block
        integer stim_fd;
        integer ret_code;
        stim_fd = $fopen("../simvectors/faded_lake.txt", "r");
        if (stim_fd == 0) begin
            $fatal("Could not open stimuli file!");
        end
        filt_enable = 0;
        n_stims = 0;
        stim_applied = 0;
        inp_valid = 0;
        stim = '0;
        wait (rst_n);
        while (!$feof(stim_fd)) begin
            @(posedge clk);
            #(APPL_DELAY);
            filt_enable = 1; // filter is always on
            ret_code = randomize(inp_valid);
            if (inp_valid) begin
                ret_code = $fscanf(stim_fd, "%d,%d,%d\n", stim.r, stim.g, stim.b);
                n_stims = n_stims + 1;
                #(ACQ_DELAY-APPL_DELAY);
                wait (inp_ready);
            end
        end
        $fclose(stim_fd);
        @(posedge clk);
        #(APPL_DELAY);
        stim_applied = 1;
        inp_valid = 0;
        filt_enable = 0;
    end

    initial begin: acquisition_block
        integer ret_code;
        oup_ready = 1'b0;
        wait (rst_n);
        while (1) begin
            //TODO fill the acquisition code here
            @(posedge clk);
            #(APPL_DELAY);
            ret_code = randomize(oup_ready);
            #(ACQ_DELAY-APPL_DELAY);
            if(oup_valid && oup_ready) begin
                queue_mon2chk.push_back(act_resp);
            end
        end
    end

    initial begin: checker_block
        integer exp_resp_fd;
        integer acq_resp_fd;
        integer ret_code;
        exp_resp_fd = $fopen("../simvectors/sat_lake.txt", "r");
        if (exp_resp_fd == 0) begin
            $fatal("Could not open expected file!");
        end
        acq_resp_fd = $fopen("../simvectors/output.txt", "w");
        if (acq_resp_fd == 0) begin
            $fatal("Could not open acquired file!");
        end
        n_checks = 0;
        n_errs   = 0;
        n_timeout = 0;
        wait (rst_n);
        while (!stim_applied || n_checks < n_stims) begin
            // TODO fill checker code here
            wait(queue_mon2chk.size());
            acq_resp = queue_mon2chk.pop_front();
            ret_code = $fscanf(exp_resp_fd, "%d,%d,%d\n", exp_resp.r, exp_resp.g, exp_resp.b);
            n_checks += 1;
            if(acq_resp != exp_resp) begin
                n_errs += 1;
                $warning("Mismatch occured at %t ns, expected (%d, %d, %d), actual (%d, %d, %d).",
                    $time, exp_resp.r, exp_resp.g, exp_resp.b, acq_resp.r, acq_resp.g, acq_resp.b);
            end
            $fwrite(acq_resp_fd, "%d,%d,%d\n", acq_resp.r, acq_resp.g, acq_resp.b);

        end
        if (n_errs > 0) begin
            $display("Test ***FAILED*** with ", n_errs, " mismatches out of ", n_checks, " checks after ", n_stims, " stimuli!");
        end else begin
            $display("Test ***PASSED*** with ", n_errs, " mismatches out of ", n_checks, " checks after ", n_stims, " stimuli.");
        end
        $fclose(exp_resp_fd);
        $fclose(acq_resp_fd);
        $stop();
    end

    initial begin: timeout_block
        while (n_timeout < TIMEOUT_LIM) begin
            @(posedge clk);
            #(ACQ_DELAY);
            if(oup_ready && oup_valid) begin
                n_timeout = 0;
            end else begin
                n_timeout = n_timeout + 1;
            end
        end
        $display("Test ***TIMED OUT*** with ", n_errs, " mismatches out of ", n_checks, " checks after ", n_stims, " stimuli!");
        $stop;
    end

endmodule
