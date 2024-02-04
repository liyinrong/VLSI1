// Copyright (c) 2022 Integrated Systems Laboratory, ETH Zurich
// Used for the VLSI 1 course
//
// Author: Michael Rogenmoser <michaero@iis.ee.ethz.ch>

module fsm_all (
  input  logic        clk_i,
  input  logic        rst_ni,
  input  logic [7:0]  in_i,
  output logic [15:0] out_o,
  input  logic [1:0]  cont_i,
  output logic [1:0]  flag_o
);

  fsm_good i_good (
    .clk_i ( clk_i       ),
    .rst_ni( rst_ni      ),
    .a_i   ( in_i        ),
    .b_i   ( cont_i[0]   ),
    .c_i   ( cont_i[1]   ),
    .d_o   ( flag_o[1]   ),
    .e_o   ( out_o[15:8] )
  );

  fsm_bad i_bad (
    .clk_i ( clk_i      ),
    .rst_ni( rst_ni     ),
    .a_i   ( in_i       ),
    .b_i   ( cont_i[0]  ),
    .c_i   ( cont_i[1]  ),
    .d_o   ( flag_o[0]  ),
    .e_o   ( out_o[7:0] )
  );

endmodule
