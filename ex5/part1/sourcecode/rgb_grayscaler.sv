// Copyright (c) 2022 Integrated Systems Laboratory, ETH Zurich
// Used for the VLSI 1 course
// 
// Author: Marco Bertuletti <mbertuletti@iis.ee.ethz.ch>

module rgb_grayscaler (
  // Control Signals
  input  logic          en_i,
  // Data Signals
  input  logic [7:0]    r_i,
  input  logic [7:0]    g_i,
  input  logic [7:0]    b_i,
  output logic [7:0]    gray_o
);

  const logic [7:0] RWeight = 8'd74;  // 0.2902
  const logic [7:0] GWeight = 8'd145; // 0.5686
  const logic [7:0] BWeight = 8'd36;  // 0.1412

  // Implement your code here
  logic [15:0]  r_weighted, g_weighted, b_weighted, sum_weighted;
  logic [7:0]   sum;

  assign r_weighted = RWeight * r_i;
  assign g_weighted = GWeight * g_i;
  assign b_weighted = BWeight * b_i;
  assign sum_weighted = r_weighted + g_weighted + b_weighted;
  assign sum = sum_weighted >> 8;
  assign gray_o = en_i ? sum : 8'd128;

endmodule
