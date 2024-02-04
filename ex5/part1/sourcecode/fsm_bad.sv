// Copyright (c) 2022 Integrated Systems Laboratory, ETH Zurich
// Used for the VLSI 1 course
//
// Author: Michael Rogenmoser <michaero@iis.ee.ethz.ch>

module fsm_bad (
  input  logic       clk_i,
  input  logic       rst_ni,
  input  logic [7:0] a_i,
  input  logic       b_i,
  input  logic       c_i,
  output logic       d_o,
  output logic [7:0] e_o
);

  logic [7:0] kk, kk2;
  logic jj;
  logic [3:0] m;

  assign d_o = jj;
  assign e_o = kk;


  always_ff @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni) begin
      m <= '0;
    end else begin
      if (b_i == 1'b1) begin
        m <= m + 1;
        kk2 <= kk ^ a_i;
      end else begin
        if (c_i == 1'b1) begin
          if (a_i[2] == 1'b0) begin
            kk2 <= kk ^ a_i;
            kk <= kk2;
            jj <= '0;
            m <= m + 1;
          end
        end else begin
          jj <= 1'b1;
          m <= a_i[6:3];
          kk <= '0;
        end
      end
    end
  end

endmodule
