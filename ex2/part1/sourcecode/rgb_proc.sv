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
  logic [7:0] gs_prim_r,
              gs_prim_g,
              gs_prim_b;

  logic [7:0] gs_ref_r,
              gs_ref_g,
              gs_ref_b;

  // Instantiation of grayscaler
  rgb_grayscaler_primitive i_rgb_grayscaler_primitive (
    .r_i    ( r_i       ),
    .g_i    ( g_i       ),
    .b_i    ( b_i       ),

    .r_o    ( gs_prim_r ),
    .g_o    ( gs_prim_g ),
    .b_o    ( gs_prim_b )
  );

  rgb_grayscaler_refined i_rgb_grayscaler_refined (
    .r_i    ( r_i       ),
    .g_i    ( g_i       ),
    .b_i    ( b_i       ),

    .r_o    ( gs_ref_r  ),
    .g_o    ( gs_ref_g  ),
    .b_o    ( gs_ref_b  )
  );

  // Output multiplexer
  always_comb begin
    if (switch_i[0] == 1'b1) begin
      r_o = gs_prim_r;
      g_o = gs_prim_g;
      b_o = gs_prim_b;
    end else begin
      r_o = gs_ref_r;
      g_o = gs_ref_g;
      b_o = gs_ref_b;
    end
  end

  assign hsync_o = hsync_i;
  assign vsync_o = vsync_i;
  assign vde_o   = vde_i;

  assign valid_o = valid_i;
  assign ready_o = ready_i;

endmodule
