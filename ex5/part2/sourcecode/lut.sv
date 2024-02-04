module lut (
	input logic [3:0] a_i,
	input logic [3:0] b_i,
	output logic [3:0] a_o,
	output logic [3:0] b_o
);

	always_comb begin
	    case(a_i)
	      4'b0000: a_o = 4'd3;
	      4'b0001: a_o = 4'd12;
	      4'b0010: a_o = 4'd6;
	      4'b0011: a_o = 4'd13;
	      4'b0100: a_o = 4'd5;
	      4'b0101: a_o = 4'd7;
	      4'b0110: a_o = 4'd1;
	      4'b0111: a_o = 4'd9;
	      4'b1000: a_o = 4'd15;
	      4'b1001: a_o = 4'd2;
	      4'b1010: a_o = 4'd0;
	      4'b1011: a_o = 4'd4;
	      4'b1100: a_o = 4'd11;
	      4'b1101: a_o = 4'd10;
	      4'b1110: a_o = 4'd14;
	      default: a_o = 4'd8;
	    endcase
	    b_o = a_o ^ b_i;
	end

endmodule