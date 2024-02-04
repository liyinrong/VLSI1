module rgb_brightener (
    input  logic [7:0]  r_i,
    input  logic [7:0]  g_i,
    input  logic [7:0]  b_i,

    output logic [7:0]  r_o,
    output logic [7:0]  g_o,
    output logic [7:0]  b_o
);

    always_comb begin
        if (r_i < 8'd201) begin
            r_o = r_i + 8'd55;
        end else begin
            r_o = 8'd255;
        end
        if (g_i < 8'd201) begin
            g_o = g_i + 8'd55;
        end else begin
            g_o = 8'd255;
        end
        if (b_i < 8'd201) begin
            b_o = b_i + 8'd55;
        end else begin
            b_o = 8'd255;
        end
    end

endmodule
