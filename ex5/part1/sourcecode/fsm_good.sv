// Copyright (c) 2022 Integrated Systems Laboratory, ETH Zurich
// Used for the VLSI 1 course
//
// Author: Michael Rogenmoser <michaero@iis.ee.ethz.ch>

module fsm_good (
  input  logic       clk_i,
  input  logic       rst_ni,
  input  logic [7:0] a_i,
  input  logic       b_i,
  input  logic       c_i,
  output logic       d_o,
  output logic [7:0] e_o
);

  logic [7:0] r_d, r_q;
  logic [3:0] s_d, s_q;
  logic       t_d, t_q;

  assign e_o = t_q ? a_i ^ r_q : ~a_i;
  assign d_o = s_q[3] ? t_q : '0;

  assign r_d = b_i ? a_i : r_q;

  always_comb begin
    t_d = '0;
    s_d = s_q + 1;

    if (c_i == 1'b1) begin
      s_d = ~s_q;
    end else if (a_i[0] == 1'b0) begin
      t_d = 1'b1;
    end else begin
      t_d = a_i[7] ^ t_q;
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni) begin
      r_q <= '0;
      s_q <= '0;
      t_q <= '0;
    end else begin
      r_q <= r_d;
      s_q <= s_d;
      t_q <= t_d;
    end
  end

endmodule
