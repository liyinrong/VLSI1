module rgb_inverter (
    input  logic        en_i,

    input  logic [7:0]  r_i,
    input  logic [7:0]  g_i,
    input  logic [7:0]  b_i,

    output logic [7:0]  r_o,
    output logic [7:0]  g_o,
    output logic [7:0]  b_o
);

    logic [7:0] r_inv,
                g_inv,
                b_inv;

    assign r_inv = 255 - r_i;
    assign g_inv = 255 - g_i;
    assign b_inv = 255 - b_i;

    always_comb begin
        if (en_i) begin
            r_o = r_inv;
            g_o = g_inv;
            b_o = b_inv;
        end else begin
            r_o = r_i;
            g_o = g_i;
            b_o = b_i;
        end
    end

endmodule
