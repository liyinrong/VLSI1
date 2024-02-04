/**
  * Top-Level Module for RGB Processing
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

    // Declaration of internal signals
    logic [7:0] gs_r,   gs_g,   gs_b;
    logic [7:0] mux_r,  mux_g,  mux_b;
    logic [7:0] br_r,   br_g,   br_b;

    // Instantiation of grayscaler
    rgb_grayscaler_refined i_rgb_grayscaler (
        .r_i    (r_i),
        .g_i    (g_i),
        .b_i    (b_i),

        .r_o    (gs_r),
        .g_o    (gs_g),
        .b_o    (gs_b)
    );

    // Output multiplexer
    always_comb begin
        case (switch_i[1:0])
            2'b00: begin
                mux_r = r_i;
                mux_g = g_i;
                mux_b = b_i;
            end
            2'b01: begin
                mux_r = {r_i[7:6], 6'b0};
                mux_g = {g_i[7:6], 6'b0};
                mux_b = {b_i[7:6], 6'b0};
            end
            2'b10: begin
                mux_r = ~r_i;
                mux_g = ~g_i;
                mux_b = ~b_i;
            end
            2'b11: begin
                mux_r = gs_r;
                mux_g = gs_g;
                mux_b = gs_b;
            end
        endcase
    end

    // Instantiation of brightener
    rgb_brightener i_rgb_brightener (
        .r_i    (mux_r),
        .g_i    (mux_g),
        .b_i    (mux_b),

        .r_o    (br_r),
        .g_o    (br_g),
        .b_o    (br_b)
    );

    assign r_o = switch_i[2] ? br_r : mux_r;
    assign g_o = switch_i[2] ? br_g : mux_g;
    assign b_o = switch_i[2] ? br_b : mux_b;

    assign hsync_o = hsync_i;
    assign vsync_o = vsync_i;
    assign vde_o   = vde_i;

    assign valid_o = valid_i;
    assign ready_o = ready_i;

endmodule
