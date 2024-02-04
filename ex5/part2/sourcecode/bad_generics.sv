// Copyright (c) 2022 Integrated Systems Laboratory, ETH Zurich
// Used for the VLSI 1 course
//
// Author: Michael Rogenmoser <michaero@iis.ee.ethz.ch>

module bad_generics #(
  parameter int Value = 8
) (
  input  logic clk_i,
  input  logic rst_ni,

  input  logic [23:0] in_i,
  output logic [23:0] out_o
);

  int my_int;
  logic [23:0] inb;
  logic [23:0] reg_d, reg_q;

  logic invert;

  assign my_int = reg_q;

  always_comb begin
    invert = 1'b0;
    if (my_int % Value == 0) begin
      invert = 1'b1;
    end
  end

  assign reg_d = out_o;

  assign out_o = invert == 1'b0 ? in_i : ~in_i;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni) begin
      reg_q <= '0;
    end else begin
      reg_q <= reg_d;
    end
  end

endmodule
