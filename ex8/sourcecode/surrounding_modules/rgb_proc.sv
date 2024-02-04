/*
 * Top-Level Module for kernel convolution
 */
module rgb_proc (
    input  logic        clk_i,
    input  logic        rst_ni,

    input  logic [2:0]  switch_i,

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

    // Block that takes stream of pixels and generates 3x3 slices

    logic [2:0][2:0][7:0] slice_r;
    logic [2:0][2:0][7:0] slice_g;
    logic [2:0][2:0][7:0] slice_b;
    logic                 slice_hsync;
    logic                 slice_vsync;
    logic                 slice_vde;
    logic                 slice_valid;
    logic                 slice_ready;

    rgb_slice_matrix i_rgb_slice_matrix (
        .clk_i   (clk_i),
        .rst_ni  (rst_ni),

        .r_i     (r_i),
        .g_i     (g_i),
        .b_i     (b_i),
        .hsync_i (hsync_i),
        .vsync_i (vsync_i),
        .vde_i   (vde_i),
        .valid_i (valid_i),
        .ready_o (ready_o),

        .r_o     (slice_r),
        .g_o     (slice_g),
        .b_o     (slice_b),
        .hsync_o (slice_hsync),
        .vsync_o (slice_vsync),
        .vde_o   (slice_vde),
        .valid_o (slice_valid),
        .ready_i (slice_ready)
    );

    // Filter top-level
    rgb_filter i_rgb_filter (
        .clk_i    (clk_i),
        .rst_ni   (rst_ni),
        .switch_i (switch_i),

        .r_i      (slice_r),
        .g_i      (slice_g),
        .b_i      (slice_b),
        .hsync_i  (slice_hsync),
        .vsync_i  (slice_vsync),
        .vde_i    (slice_vde),
        .valid_i  (slice_valid),
        .ready_o  (slice_ready),

        .r_o      (r_o),
        .g_o      (g_o),
        .b_o      (b_o),
        .hsync_o  (hsync_o),
        .vsync_o  (vsync_o),
        .vde_o    (vde_o),
        .valid_o  (valid_o),
        .ready_i  (ready_i)
    );

endmodule
