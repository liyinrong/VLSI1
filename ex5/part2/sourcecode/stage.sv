// Copyright (c) 2022 Integrated Systems Laboratory, ETH Zurich
// Used for the VLSI 1 course
//
// Author: Marco Bertuletti <mbertuletti@iis.ee.ethz.ch>

module stage #(
  parameter int unsigned Width = 5
) (
  input  logic                 clk_i,
  input  logic                 rst_ni,
  input  logic [Width-1:0]     in_i,
  output logic [(Width+2)-1:0] out_o
);

  //TODO
  logic[Width-1:0] reg_q;
  logic[Width-1:0] reg_d;

  assign reg_d = in_i;

  always_ff @(posedge clk_i or negedge rst_ni) begin : proc_reg_ff
    if(!rst_ni) begin
      reg_q <= 'b0;
    end else begin
      reg_q <= reg_d;
    end
  end

  assign out_o[Width-1:0] = reg_q[Width-1:0];
  assign out_o[Width]     = reg_q[0] && in_i[0];
  assign out_o[Width+1]   = reg_q[0] && in_i[0];

endmodule
