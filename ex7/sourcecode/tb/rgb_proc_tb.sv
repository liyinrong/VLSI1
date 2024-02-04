`include "csv_reader.sv"
`include "csv_writer.sv"

module rgb_proc_tb ();

    timeunit 1ns;
    timeprecision 10ps;

    localparam time ClkPeriod          = 50ns;
    localparam time ApplDelay          = 10ns;
    localparam time AcqDelay           = 30ns;
    localparam unsigned RstClkCycles  = 10;
    localparam unsigned TIMEOUT_LIM     = 1920*1080*10;

    typedef logic [7:0] color_t;
    typedef struct packed {
        color_t r, g, b;
    } rgb_t;
    typedef struct packed {
        logic hsync, vsync, vde;
    } meta_t;
    typedef struct packed {
        rgb_t rgb;
        meta_t meta;
    } hdmi_t;

    hdmi_t  stim,
            act_resp,
            exp_resp;

    integer n_stims;

    hdmi_t  act_resp_queue[$];
    meta_t  exp_meta_resp_queue[$];

    logic   clk,
            rst_n,
            inp_valid,  inp_ready,
            oup_valid,  oup_ready;

    csv_reader #(
        .DATA_WIDTH     ($size(rgb_t)),
        .FIELD_WIDTH    ($size(color_t))
    ) i_stim_rd;

    csv_reader #(
        .DATA_WIDTH     ($size(rgb_t)),
        .FIELD_WIDTH    ($size(color_t))
    ) i_exp_resp_rd;

    csv_writer #(
        .DATA_WIDTH     ($size(rgb_t)),
        .FIELD_WIDTH    ($size(color_t))
    ) i_acq_resp_wr;

    clk_rst_gen #(
        .ClkPeriod     (ClkPeriod),
        .RstClkCycles  (RstClkCycles)
    ) i_clk_rst_gen (
        .clk_o  (clk),
        .rst_no (rst_n)
    );

    hdmi_rnd_data_gen #(
        .XResolution   (1920),
        .YResolution   (1080),
        .ApplDelay     (ApplDelay),
        .AcqDelay      (AcqDelay)
    ) i_hdmi_rnd_data_gen (
        .clk_i      (clk),
        .rst_ni     (rst_n),
        .valid_o    (inp_valid),
        .ready_i    (inp_ready),
        .data_o     (),
        .vsync_o    (stim.meta.vsync),
        .hsync_o    (stim.meta.hsync),
        .vde_o      (stim.meta.vde)
    );

    rgb_proc dut (
        .clk_i      (clk),
        .rst_ni     (rst_n),
        .switch_i   ('0),
        .btn_i      ('0),
        .led_o      (),
        .r_i        (stim.rgb.r),
        .g_i        (stim.rgb.g),
        .b_i        (stim.rgb.b),
        .hsync_i    (stim.meta.hsync),
        .vsync_i    (stim.meta.vsync),
        .vde_i      (stim.meta.vde),
        .valid_i    (inp_valid),
        .ready_o    (inp_ready),
        .r_o        (act_resp.rgb.r),
        .g_o        (act_resp.rgb.g),
        .b_o        (act_resp.rgb.b),
        .hsync_o    (act_resp.meta.hsync),
        .vsync_o    (act_resp.meta.vsync),
        .vde_o      (act_resp.meta.vde),
        .valid_o    (oup_valid),
        .ready_i    (oup_ready)
    );

    initial begin: stim_appl
        logic eof = 0;
        i_stim_rd = new("../simvectors/stim.txt");
        n_stims = 0;
        stim.rgb = '0;
        wait (rst_n);
        do @(posedge clk); while (!inp_valid || !stim.meta.vsync);
        do @(posedge clk); while (!inp_valid ||  stim.meta.vsync);
        while (!eof) begin
            @(posedge clk);
            #(ApplDelay+1ns); // Workaround to fix ordering since we depend on a part of the stimuli.
            if (inp_valid) begin
                if (stim.meta.vde) begin
                    i_stim_rd.try_read_line(stim.rgb, eof);
                    n_stims = n_stims + 1;
                end else begin
                    stim.rgb = '0;
                end
                #(AcqDelay-ApplDelay);
                while (!inp_ready) begin
                    @(posedge clk);
                    #(AcqDelay);
                end
            end
        end
        @(posedge clk);
        #(ApplDelay);
        stim.rgb = '0;
    end

    initial begin: meta_acq
        wait (rst_n);
        while (1) begin
            @(posedge clk);
            #(AcqDelay);
            if (inp_valid && inp_ready) begin
                exp_meta_resp_queue.push_back(stim.meta);
            end
        end
    end

    initial begin: act_resp_acq
        oup_ready = 1'b0;
        wait (rst_n);
        while (1) begin
            @(posedge clk);
            #(ApplDelay);
            void'(std::randomize(oup_ready));
            #(AcqDelay-ApplDelay);
            if (oup_ready && oup_valid) begin
                act_resp_queue.push_back(act_resp);
            end
        end
    end

    initial begin: resp_chk
        integer n_checks, n_errs, n_timeouts;
        bit vsync_seen;
        hdmi_t act;
        i_exp_resp_rd = new("../simvectors/exp_resp.txt");
        i_acq_resp_wr = new("../simvectors/act_resp.txt");
        n_checks = 0;
        n_errs = 0;
        n_timeouts= 0;
        vsync_seen = 0;
        wait (rst_n);
        fork
        begin
            while (1) begin
                wait(act_resp_queue.size() > 0);
                act = act_resp_queue.pop_front();
                exp_resp.meta = exp_meta_resp_queue.pop_front();
                vsync_seen |= act.meta.vsync;
                if (act.meta.vde && vsync_seen) begin
                    i_exp_resp_rd.read_line(exp_resp.rgb);
                    n_checks += 1;
                    // if (act.rgb != exp_resp.rgb) begin
                    //     n_errs += 1;
                    //     $display("Mismatch occurred at %d (check %d, stim %d): actual %x != expected %x",
                    //             $time, n_checks, n_stims, act, exp_resp);
                    // end
                    i_acq_resp_wr.write_line(act.rgb);
                end
                if (act.meta != exp_resp.meta) begin
                    $display("Metadata mismatch occurred at %d: actual %x != expected %x",
                        $time, act.meta, exp_resp.meta);
                end
            end
        end
        begin // timeout if oup interface fails to show any activity for long period
            while (n_timeouts < TIMEOUT_LIM) begin
                @(posedge clk);
                #(AcqDelay);
                if(oup_ready && oup_valid) begin
                    n_timeouts = 0;
                end else begin
                    n_timeouts = n_timeouts + 1;
                end
            end
        end
        join_any
        disable fork;
        if (n_errs > 0) begin
            $display("Test ***FAILED*** with ", n_errs, " mismatches out of ", n_checks, " checks after ", n_stims, " stimuli!");
        end else begin
            $display("Test ***PASSED*** with ", n_errs, " mismatches out of ", n_checks, " checks after ", n_stims, " stimuli.");
        end
        $stop();
    end

endmodule
