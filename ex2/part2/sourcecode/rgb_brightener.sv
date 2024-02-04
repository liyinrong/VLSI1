module rgb_brightener (
    input logic [7:0] r_i,
    input logic [7:0] g_i,
    input logic [7:0] b_i,
    
    output logic [7:0] r_o,
    output logic [7:0] g_o,
    output logic [7:0] b_o
);

    assign r_o = (r_i < 8'd201) ? (r_i + 8'd55) : 8'd255;
    assign g_o = (g_i < 8'd201) ? (g_i + 8'd55) : 8'd255;
    assign b_o = (b_i < 8'd201) ? (b_i + 8'd55) : 8'd255;

endmodule
