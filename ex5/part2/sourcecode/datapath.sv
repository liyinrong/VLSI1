// Copyright (c) 2022 Integrated Systems Laboratory, ETH Zurich
// Used for the VLSI 1 course
//
// Author: Marco Bertuletti <mbertuletti@iis.ee.ethz.ch>

module datapath (
  input  logic               clk_i,
  input  logic               rst_ni,

  input  logic signed [15:0] in_i,
  input  logic               cnst_sel_i,
  input  logic               add_i,
  input  logic               clr_count_i,
  input  logic               clr_accu_i,
  output logic [4:0]         count_o,
  output logic [15:0]        add_cnst_o,
  output logic [15:0]        out_o
);

  logic signed [15:0] cnst;
  logic signed [15:0] add_cnst;
  logic signed [15:0] add_sub;
  logic signed [15:0] accu_q, accu_d;
  logic signed [4:0]  count_q, count_d;

  assign cnst = (cnst_sel_i == 1'b0)? {15'b0, 1'b1} : {16{1'b1}};
  assign add_cnst = in_i + cnst;
  assign add_sub = (add_i == 1'b1)? (add_cnst + accu_q) : (add_cnst - accu_q);
  assign accu_d = clr_accu_i ? 16'b0 : add_sub;

  always_comb begin
    count_d = count_q;
    if (clr_count_i == 1'b1)
      count_d = 5'd0;
    else if (count_q == 5'd15)
      count_d = 5'd0;
    else
      count_d = count_q + 1;
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin //asynchronous reset (active low)
      accu_q  <= 16'b0;
      count_q <= 5'd0;
    end else begin
      accu_q  <= accu_d;
      count_q <= count_d;
    end
  end

  assign out_o   = accu_q;
  assign count_o = count_q;
  assign add_cnst_o = add_cnst;

endmodule
