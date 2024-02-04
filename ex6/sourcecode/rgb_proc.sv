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
    logic [7:0] gs_r,   gs_g,   gs_b,
                br_i_r, br_i_g, br_i_b,
                br_o_r, br_o_g, br_o_b;

    // Instantiation of grayscaler
    rgb_grayscaler_refined i_rgb_grayscaler (
        .r_i    (r_i),
        .g_i    (g_i),
        .b_i    (b_i),

        .r_o    (gs_r),
        .g_o    (gs_g),
        .b_o    (gs_b)
    );

    // Intermediate multiplexer
    always_comb begin
        unique case (switch_i[1:0])
            2'b01: begin    // Quantizer
                br_i_r = {r_i[7:6], 6'd0};
                br_i_g = {g_i[7:6], 6'd0};
                br_i_b = {b_i[7:6], 6'd0};
            end
            2'b10: begin    // Inverter
                br_i_r = 8'd255 - r_i;
                br_i_g = 8'd255 - g_i;
                br_i_b = 8'd255 - b_i;
            end
            2'b11: begin    // Grayscaler
                br_i_r = gs_r;
                br_i_g = gs_g;
                br_i_b = gs_b;
            end
            default: begin  // Feedthrough
                br_i_r = r_i;
                br_i_g = g_i;
                br_i_b = b_i;
            end
        endcase
    end

    // Instantiation of brightener
    rgb_brightener i_rgb_brightener (
        .r_i    (br_i_r),
        .g_i    (br_i_g),
        .b_i    (br_i_b),

        .r_o    (br_o_r),
        .g_o    (br_o_g),
        .b_o    (br_o_b)
    );

    // Output multiplexer
    always_comb begin
        if (switch_i[2] == 1'b1) begin
            r_o = br_o_r;
            g_o = br_o_g;
            b_o = br_o_b;
        end else begin
            r_o = br_i_r;
            g_o = br_i_g;
            b_o = br_i_b;
        end
    end

    // NOTE: Inline alternative solution to "Output multiplexer"
    // assign r_o = switch_i[2] ? br_o_r : br_i_r;
    // assign g_o = switch_i[2] ? br_o_g : br_i_g;
    // assign b_o = switch_i[2] ? br_o_b : br_i_b;

    assign hsync_o = hsync_i;
    assign vsync_o = vsync_i;
    assign vde_o   = vde_i;

    assign valid_o = valid_i;
    assign ready_o = ready_i;

endmodule
