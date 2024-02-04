/**
  * Top-Level Module for RGB Processing
  */
module rgb_proc #(
    parameter integer DebounceCycles = 50_000
) (
    input  logic        clk_i,
    input  logic        rst_ni,

    input  logic [1:0]  btn_i,
    output logic [3:0]  led_o,

    input  logic [7:0]  r_i,
    input  logic [7:0]  g_i,
    input  logic [7:0]  b_i,
    input  logic        hsync_i,
    input  logic        vsync_i,
    input  logic        vde_i,
    input  logic        valid_i,
    output logic        ready_o,

    output logic [7:0]  r_o,
    output logic [7:0]  g_o,
    output logic [7:0]  b_o,
    output logic        hsync_o,
    output logic        vsync_o,
    output logic        vde_o,
    output logic        valid_o,
    input  logic        ready_i
);

    logic       hop,
                toggle;

    logic [3:0] filt_enable;

    assign led_o = filt_enable;

    // Debouncer for hop button
    debouncer #(
        .NumCycles (DebounceCycles)
    ) i_debouncer_hop (
        .clk_i  (clk_i),
        .rst_ni (rst_ni),
        .inp_i  (btn_i[0]),
        .oup_o  (hop)
    );

    // Debouncer for toggle button
    debouncer #(
        .NumCycles (DebounceCycles)
    ) i_debouncer_toggle (
        .clk_i  (clk_i),
        .rst_ni (rst_ni),
        .inp_i  (btn_i[1]),
        .oup_o  (toggle)
    );

    // Video filter pipeline
    vid_pipeline i_vid_pipe (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),

        .enable_i   (filt_enable),

        .r_i        (r_i),
        .g_i        (g_i),
        .b_i        (b_i),
        .hsync_i    (hsync_i),
        .vsync_i    (vsync_i),
        .vde_i      (vde_i),
        .valid_i    (valid_i),
        .ready_o    (ready_o),

        .r_o        (r_o),
        .g_o        (g_o),
        .b_o        (b_o),
        .hsync_o    (hsync_o),
        .vsync_o    (vsync_o),
        .vde_o      (vde_o),
        .valid_o    (valid_o),
        .ready_i    (ready_i)
    );

    filt_fsm i_filt_control (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),

        .hop_i      (hop),
        .toggle_i   (toggle),

        .enable_o   (filt_enable)
    );

endmodule
