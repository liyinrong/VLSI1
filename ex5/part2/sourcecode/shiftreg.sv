// Copyright (c) 2022 Integrated Systems Laboratory, ETH Zurich
// Used for the VLSI 1 course
// 
// Author: Marco Bertuletti <mbertuletti@iis.ee.ethz.ch>

module shiftreg (
    input  logic clk_i,
    input  logic rst_ni,
    input  logic[5-1:0]  in_i,
    output logic[13-1:0] out_o
);

  logic [5-1:0] s1;
  logic [7-1:0] s2;
  logic [9-1:0] s3;
  logic [11-1:0] s4;

  logic [13-1:0] slast;

  // generate first level signal
  assign s1 = in_i ^ (s2[7-1] &
                      s3[9-1] &
                      s4[11-1] &
                      slast[13-2] &
                      slast[13-1]);

  stage # (
    .Width(5)
    ) i_stage5 (
    .clk_i  (clk_i),
    .rst_ni (rst_ni),
    .in_i   (s1),
    .out_o  (s2));

  stage # (
    .Width(7)
    ) i_stage7 (
    .clk_i  (clk_i),
    .rst_ni (rst_ni),
    .in_i   (s2),
    .out_o  (s3));

  stage # (
    .Width(9)
    ) i_stage9 (
    .clk_i  (clk_i),
    .rst_ni (rst_ni),
    .in_i   (s3),
    .out_o  (s4));

  stage # (
    .Width(11)
    ) i_stage11 (
    .clk_i  (clk_i),
    .rst_ni (rst_ni),
    .in_i   (s4),
    .out_o  (slast));

  assign out_o = slast;

endmodule
