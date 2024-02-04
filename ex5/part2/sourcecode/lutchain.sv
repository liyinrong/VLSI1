// Copyright (c) 2022 Integrated Systems Laboratory, ETH Zurich
// Used for the VLSI 1 course
// 
// Author: Marco Bertuletti <mbertuletti@iis.ee.ethz.ch>

module lutchain (
  input  logic[3:0]  a_i,
  input  logic[3:0]  b_i,
  output logic[7:0]  out_o
);

  // logic[3:0] l1_d, l2_d, l3_d, l4_d, l5_d, l6_d, l7_d;
  // logic[3:0] r1_d, r2_d, r3_d, r4_d, r5_d, r6_d, r7_d;

  // assign l1_d = a_i;
  // assign r1_d = b_i;

  logic [7:1][3:0] l_d, r_d;

  assign l_d[1] = a_i;
  assign r_d[1] = b_i;

  generate
    for(genvar i=1; i<7; i++) begin
      lut i_lut (
        .a_i(l_d[i]),
        .b_i(r_d[i]),
        .a_o(l_d[i+1]),
        .b_o(r_d[i+1])
      );
    end
  endgenerate

  // always_comb begin
  //   case(l1_d)
  //     4'b0000: l2_d = 4'b1001;
  //     4'b0001: l2_d = 4'b0000;
  //     4'b0010: l2_d = 4'b0100;
  //     4'b0011: l2_d = 4'b1011;
  //     4'b0100: l2_d = 4'b1101;
  //     4'b0101: l2_d = 4'b1100;
  //     4'b0110: l2_d = 4'b0011;
  //     4'b0111: l2_d = 4'b1111;
  //     4'b1000: l2_d = 4'b0001;
  //     4'b1001: l2_d = 4'b1010;
  //     4'b1010: l2_d = 4'b0010;
  //     4'b1011: l2_d = 4'b0110;
  //     4'b1100: l2_d = 4'b0111;
  //     4'b1101: l2_d = 4'b0101;
  //     4'b1110: l2_d = 4'b1000;
  //     default: l2_d = 4'b1110;
  //   endcase
  //   r2_d = l2_d ^ r1_d;
  // end

  // always_comb begin
  //   case(l2_d)
  //     4'b0000: l3_d = 4'b1001;
  //     4'b0001: l3_d = 4'b0000;
  //     4'b0010: l3_d = 4'b0100;
  //     4'b0011: l3_d = 4'b1011;
  //     4'b0100: l3_d = 4'b1101;
  //     4'b0101: l3_d = 4'b1100;
  //     4'b0110: l3_d = 4'b0011;
  //     4'b0111: l3_d = 4'b1111;
  //     4'b1000: l3_d = 4'b0001;
  //     4'b1001: l3_d = 4'b1010;
  //     4'b1010: l3_d = 4'b0010;
  //     4'b1011: l3_d = 4'b0110;
  //     4'b1100: l3_d = 4'b0111;
  //     4'b1101: l3_d = 4'b0101;
  //     4'b1110: l3_d = 4'b1000;
  //     default: l3_d = 4'b1110;
  //   endcase
  //   r3_d = l3_d ^ r2_d;
  // end

  // always_comb begin
  //   case(l3_d)
  //     4'b0000: l4_d = 4'b1001;
  //     4'b0001: l4_d = 4'b0000;
  //     4'b0010: l4_d = 4'b0100;
  //     4'b0011: l4_d = 4'b1011;
  //     4'b0100: l4_d = 4'b1101;
  //     4'b0101: l4_d = 4'b1100;
  //     4'b0110: l4_d = 4'b0011;
  //     4'b0111: l4_d = 4'b1111;
  //     4'b1000: l4_d = 4'b0001;
  //     4'b1001: l4_d = 4'b1010;
  //     4'b1010: l4_d = 4'b0010;
  //     4'b1011: l4_d = 4'b0110;
  //     4'b1100: l4_d = 4'b0111;
  //     4'b1101: l4_d = 4'b0101;
  //     4'b1110: l4_d = 4'b1000;
  //     default: l4_d = 4'b1110;
  //   endcase
  //   r4_d = l4_d ^ r3_d;
  // end

  // always_comb begin
  //   case(l4_d)
  //     4'b0000: l5_d = 4'b1001;
  //     4'b0001: l5_d = 4'b0000;
  //     4'b0010: l5_d = 4'b0100;
  //     4'b0011: l5_d = 4'b1011;
  //     4'b0100: l5_d = 4'b1101;
  //     4'b0101: l5_d = 4'b1100;
  //     4'b0110: l5_d = 4'b0011;
  //     4'b0111: l5_d = 4'b1111;
  //     4'b1000: l5_d = 4'b0001;
  //     4'b1001: l5_d = 4'b1010;
  //     4'b1010: l5_d = 4'b0010;
  //     4'b1011: l5_d = 4'b0110;
  //     4'b1100: l5_d = 4'b0111;
  //     4'b1101: l5_d = 4'b0101;
  //     4'b1110: l5_d = 4'b1000;
  //     default: l5_d = 4'b1110;
  //   endcase
  //   r5_d = l5_d ^ r4_d;
  // end

  // always_comb begin
  //   case(l5_d)
  //     4'b0000: l6_d = 4'b1001;
  //     4'b0001: l6_d = 4'b0000;
  //     4'b0010: l6_d = 4'b0100;
  //     4'b0011: l6_d = 4'b1011;
  //     4'b0100: l6_d = 4'b1101;
  //     4'b0101: l6_d = 4'b1100;
  //     4'b0110: l6_d = 4'b0011;
  //     4'b0111: l6_d = 4'b1111;
  //     4'b1000: l6_d = 4'b0001;
  //     4'b1001: l6_d = 4'b1010;
  //     4'b1010: l6_d = 4'b0010;
  //     4'b1011: l6_d = 4'b0110;
  //     4'b1100: l6_d = 4'b0111;
  //     4'b1101: l6_d = 4'b0101;
  //     4'b1110: l6_d = 4'b1000;
  //     default: l6_d = 4'b1110;
  //   endcase
  //   r6_d = l6_d ^ r5_d;
  // end

  // always_comb begin
  //   case(l6_d)
  //     4'b0000: l7_d = 4'b1001;
  //     4'b0001: l7_d = 4'b0000;
  //     4'b0010: l7_d = 4'b0100;
  //     4'b0011: l7_d = 4'b1011;
  //     4'b0100: l7_d = 4'b1101;
  //     4'b0101: l7_d = 4'b1100;
  //     4'b0110: l7_d = 4'b0011;
  //     4'b0111: l7_d = 4'b1111;
  //     4'b1000: l7_d = 4'b0001;
  //     4'b1001: l7_d = 4'b1010;
  //     4'b1010: l7_d = 4'b0010;
  //     4'b1011: l7_d = 4'b0110;
  //     4'b1100: l7_d = 4'b0111;
  //     4'b1101: l7_d = 4'b0101;
  //     4'b1110: l7_d = 4'b1000;
  //     default: l7_d = 4'b1110;
  //   endcase
  //   r7_d = l7_d ^ r6_d;
  // end

  // assign out_o = {r7_d, l7_d};
  assign out_o = {r_d[7], l_d[7]};

endmodule
