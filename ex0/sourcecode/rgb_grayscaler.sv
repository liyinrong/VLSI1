module rgb_grayscaler (
    input  logic          en_i,

    input  logic [7:0]    r_i,
    input  logic [7:0]    g_i,
    input  logic [7:0]    b_i,

    output logic [7:0]    gray_o
);

    const logic [7:0] RWEIGHT = 8'd74;  // 0.2902
    const logic [7:0] GWEIGHT = 8'd145; // 0.5686
    const logic [7:0] BWEIGHT = 8'd36;  // 0.1412

    logic [15:0]    r_weighted,
                    g_weighted,
                    b_weighted,
                    sum_weighted;

    logic [7:0]     sum;

    assign r_weighted = 16'd1 * r_i * RWEIGHT;
    assign g_weighted = 16'd1 * g_i * GWEIGHT;
    assign b_weighted = 16'd1 * b_i * BWEIGHT;

    assign sum_weighted = r_weighted + g_weighted + b_weighted;

    assign sum = sum_weighted >> 8;

    assign gray_o = en_i ? sum : 8'd128;

endmodule
