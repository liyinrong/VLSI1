module rgb_sat_crv_tb ();

    timeunit 1ns;
    timeprecision 10ps;

    localparam time CLK_PERIOD         = 50ns;
    localparam time APPL_DELAY         = 10ns;
    localparam time ACQ_DELAY          = 30ns;
    localparam unsigned RST_CLK_CYCLES = 10;
    localparam unsigned TOT_STIMS      = 10000;
    localparam unsigned TIMEOUT_LIM    = 1000;

    integer n_stims,
            n_checks,
            n_errs,
            n_timeout;

    typedef struct packed {
        logic [7:0] r,g,b;
    } rgb_t;

    rgb_t   act_resp,
            acq_resp_queue[$],
            exp_resp_queue[$],
            stim;

    logic   clk,
            filt_enable,
            inp_ready,  inp_valid,
            rst_n,
            oup_ready,  oup_valid;

    clk_rst_gen #(
        .ClkPeriod   (CLK_PERIOD),
        .RstClkCycles(RST_CLK_CYCLES)
    ) i_clk_rst_gen (
        .clk_o (clk),
        .rst_no(rst_n)
    );

    // DUT
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

    // Instantiate the randomizing stream master.
    rand_stream_mst #(
        .data_t       (rgb_t),
        .MinWaitCycles(0),
        .MaxWaitCycles(5),
        .ApplDelay    (APPL_DELAY),
        .AcqDelay     (ACQ_DELAY)
    ) i_stim_gen (
        .clk_i  (clk),
        .rst_ni (rst_n),
        .data_o (stim),
        .valid_o(inp_valid),
        .ready_i(inp_ready)
    );


    initial begin: application_block
        filt_enable = 0;
        n_stims = 0;
        wait (rst_n);
        while (n_stims < TOT_STIMS) begin
            @(posedge clk);
            #(APPL_DELAY);
            filt_enable = 1;
            #(ACQ_DELAY-APPL_DELAY);
            if (inp_valid & inp_ready) begin
                n_stims = n_stims + 1;
            end
        end
        @(posedge clk);
        #(APPL_DELAY);
        filt_enable = 0;
    end

    // Acquire response
    initial begin: acquire_block
        integer ret_code;
        oup_ready = 1'b0;
        wait (rst_n);
        while (1) begin
            @(posedge clk);
            #(APPL_DELAY);
            ret_code = randomize(oup_ready);
            #(ACQ_DELAY-APPL_DELAY);
            if (oup_valid && oup_ready) begin
                acq_resp_queue.push_back(act_resp);
            end
        end
    end

    // Golden Model
    initial begin: golden_block
        logic [7:0] gray_pix;
        rgb_t gold_val;
        while (1) begin
            @(posedge clk);
            #(ACQ_DELAY);
            if (/* TODO: Handshaking */inp_valid & inp_ready) begin
                rgb_gray_task(stim, gray_pix);
                //TODO complete the code for the golden model
                rgb_sat_task(stim, gray_pix, gold_val);
                exp_resp_queue.push_back(gold_val);
            end
        end
    end

    // Check response
    initial begin: checker_block
        rgb_t acq_resp,
              exp_resp;

        n_checks = 0;
        n_errs   = 0;
        n_timeout = 0;
        wait (rst_n);
        while (n_checks < TOT_STIMS) begin
            //TODO write the checker code here
            wait(acq_resp_queue.size() && exp_resp_queue.size());
            n_checks += 1;
            acq_resp = acq_resp_queue.pop_front();
            exp_resp = exp_resp_queue.pop_front();
            if(acq_resp != exp_resp) begin
                n_errs += 1;
                $display("Mismatch occurred at %d: acquired %2x,%2x,%2x, expected %2x,%2x,%2x",
                    $time, acq_resp.r, acq_resp.g, acq_resp.b, exp_resp.r, exp_resp.g, exp_resp.b);
            end
        end
        if (n_errs > 0) begin
            $display("Test ***FAILED*** with ", n_errs, " mismatches out of ", n_checks, " checks after ", n_stims, " stimuli!");
        end else begin
            $display("Test ***PASSED*** with ", n_errs, " mismatches out of ", n_checks, " checks after ", n_stims, " stimuli.");
        end
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
    end

    task rgb_gray_task (
        input  rgb_t       rgb_i,
        output logic [7:0] gray_o
    );
        const integer RWEIGHT = 74;
        const integer GWEIGHT = 145;
        const integer BWEIGHT = 36;

        integer gray_px;
        gray_px = RWEIGHT * rgb_i.r + GWEIGHT * rgb_i.g + BWEIGHT * rgb_i.b;
        gray_px = gray_px / 256;
        gray_o = gray_px;
    endtask

    let max(a, b) = (a > b) ? a : b;
    let min(a, b) = (a < b) ? a : b;

    task rgb_sat_task (
        input  rgb_t       rgb_i,
        input  logic [7:0] gray_i,
        output rgb_t       rgb_o
    );
        integer r, g, b;
        const integer SATURATE_SCALE = 3;
        r = rgb_i.r * SATURATE_SCALE - gray_i * (SATURATE_SCALE-1);
        g = rgb_i.g * SATURATE_SCALE - gray_i * (SATURATE_SCALE-1);
        b = rgb_i.b * SATURATE_SCALE - gray_i * (SATURATE_SCALE-1);
        r = min(r, 255);
        r = max(r, 0);
        g = min(g, 255);
        g = max(g, 0);
        b = min(b, 255);
        b = max(b, 0);
        rgb_o.r = r;
        rgb_o.g = g;
        rgb_o.b = b;
    endtask

endmodule
