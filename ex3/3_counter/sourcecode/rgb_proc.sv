/**
  * Top-Level Module for RGB Processing
  */
module rgb_proc #(
    parameter integer DebounceCycles   = 50_000,  // Unused but present for interface compatibility.
    parameter integer XResolution      = 1939,
    parameter integer YResolution      = 1120
) (
    input  logic        clk_i,
    input  logic        rst_ni,

    input  logic [1:0]  btn_i,  // Unused but present for interface compatibility.
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

    localparam integer XNumSections   = 4;
    localparam integer YNumSections   = 4;

    logic       x_edge, // TODO connect this signal to x_counter instance output
                y_edge; // TODO connect this signal to y_counter instance output

    logic [3:0] filt_enable;

    assign led_o = filt_enable;

    // TODO: instantiate x_counter and y_counter
    x_counter # (
        .XResolution    (XResolution),
        .XNumSections   (4)
    )
    i_x_counter (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),
        .valid_i    (valid_i),
        .ready_i    (ready_o),
        .hsync_i    (hsync_i),
        .vde_i      (vde_i),
        .x_edge_o   (x_edge)
    );

    y_counter # (
        .YResolution    (YResolution),
        .YNumSections   (4)

    )
    i_y_counter (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),
        .valid_i    (valid_i),
        .ready_i    (ready_o),
        .hsync_i    (hsync_i),
        .vsync_i    (vsync_i),
        .y_edge_o   (y_edge)
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

    filt_fsm i_filt_ctrl (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),

        .vsync_i    (vsync_i),
        .hsync_i    (hsync_i),
        .x_edge_i   (x_edge),
        .y_edge_i   (y_edge),

        .enable_o   (filt_enable)
    );

endmodule
