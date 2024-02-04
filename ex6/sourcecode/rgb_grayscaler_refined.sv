module rgb_grayscaler_refined (
    input  logic [7:0]  r_i,
    input  logic [7:0]  g_i,
    input  logic [7:0]  b_i,

    output logic [7:0]  r_o,
    output logic [7:0]  g_o,
    output logic [7:0]  b_o
);

    // Define internal signals and constants.
    localparam logic [7:0] RWeight = 8'd77;
    localparam logic [7:0] GWeight = 8'd150;
    localparam logic [7:0] BWeight = 8'd28;

    logic [15:0]    int_r,
                    int_g,
                    int_b,
                    int_sum;

    logic [7:0]     sum;

    // Multiplications
    assign int_r = RWeight * r_i;
    assign int_g = GWeight * g_i;
    assign int_b = BWeight * b_i;

    // Addition
    assign int_sum = int_r + int_g + int_b;

    // Right-shift for normalization
    assign sum = int_sum >> 8;

    // Assign outputs.
    assign r_o = sum;
    assign g_o = sum;
    assign b_o = sum;

endmodule
