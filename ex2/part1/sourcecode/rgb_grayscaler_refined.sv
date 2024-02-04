module rgb_grayscaler_refined (
  input  logic [7:0]  r_i,
  input  logic [7:0]  g_i,
  input  logic [7:0]  b_i,

  output logic [7:0]  r_o,
  output logic [7:0]  g_o,
  output logic [7:0]  b_o
);

  // TODO: Define internal signals and constants.
  localparam logic [7:0] RWEIGHT = 8'd77;
  localparam logic [7:0] GWEIGHT = 8'd150;
  localparam logic [7:0] BWEIGHT = 8'd28;

  logic [15:0] int_r, int_g, int_b, int_sum;
  logic [7:0] sum;

  // TODO: Multiplications
  assign int_r = r_i * RWEIGHT;
  assign int_g = g_i * GWEIGHT;
  assign int_b = b_i * BWEIGHT;

  // TODO: Addition
  assign int_sum = int_r + int_g + int_b;

  // TODO: Right-shift for normalization
  assign sum = int_sum >> 8;

  // TODO: Assign outputs.
  assign r_o = sum;
  assign g_o = sum;
  assign b_o = sum;

endmodule
