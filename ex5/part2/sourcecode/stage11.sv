// Copyright (c) 2022 Integrated Systems Laboratory, ETH Zurich
// Used for the VLSI 1 course
//
// Author: Marco Bertuletti <mbertuletti@iis.ee.ethz.ch>

module stage11 (
  input  logic        clk_i,
  input  logic        rst_ni,
  input  logic [10:0] in_i,
  output logic [12:0] out_o
);

  logic[10:0] reg_q;
  logic[10:0] reg_d;

  assign reg_d = in_i;

  always_ff @(posedge clk_i or negedge rst_ni) begin : proc_reg_ff
    if(!rst_ni) begin
      reg_q <= 'b0;
    end else begin
      reg_q <= reg_d;
    end
  end

  assign out_o[10:0] = reg_q[10:0];
  assign out_o[11]   = reg_q[0] && in_i[0];
  assign out_o[12]   = reg_q[0] && in_i[0];

endmodule