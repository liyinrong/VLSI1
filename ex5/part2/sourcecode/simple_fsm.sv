// Copyright (c) 2022 Integrated Systems Laboratory, ETH Zurich
// Used for the VLSI 1 course
// 
// Author: Marco Bertuletti <mbertuletti@iis.ee.ethz.ch>


module simple_fsm (
  input  logic clk_i,
  input  logic rst_ni,
  input  logic[15:0] in_i,
  output logic[15:0] out_o
);

  logic       cnst_sel;
  logic       add;
  logic       clr_count;
  logic       clr_accu;
  logic[4:0]  count;
  logic[15:0] add_cnst;

  datapath i_datapath (
    .clk_i        (clk_i),
    .rst_ni       (rst_ni),
    .in_i         (in_i),
    .cnst_sel_i   (cnst_sel),
    .add_i        (add),
    .clr_count_i  (clr_count),
    .clr_accu_i   (clr_accu),
    .count_o      (count),
    .add_cnst_o   (add_cnst),
    .out_o        (out_o));

  fsm i_fsm (
    .clk_i        (clk_i),
    .rst_ni       (rst_ni),
    .add_o        (add),
    .cnst_sel_o   (cnst_sel),
    .clr_count_o  (clr_count),
    .clr_accu_o   (clr_accu),
    .count_i      (count),
    .add_cnst_i   (add_cnst));

endmodule
