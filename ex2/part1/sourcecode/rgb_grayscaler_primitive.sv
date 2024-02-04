module rgb_grayscaler_primitive (
  input  logic [7:0]  r_i,
  input  logic [7:0]  g_i,
  input  logic [7:0]  b_i,

  output logic [7:0]  r_o,
  output logic [7:0]  g_o,
  output logic [7:0]  b_o
);

  assign r_o = r_i;
  assign g_o = r_i;
  assign b_o = r_i;

endmodule
