module rgb_saturator (
    input  logic        en_i,

    input  logic [7:0]  r_i,
    input  logic [7:0]  g_i,
    input  logic [7:0]  b_i,
    input  logic [7:0]  gy_i,

    output logic [7:0]  r_o,
    output logic [7:0]  g_o,
    output logic [7:0]  b_o
);

    localparam integer  SATURATE_SCALE = 3;

    typedef logic signed [15:0] imed_t;

    imed_t      r_delta,    g_delta,    b_delta,
                r_sat,      g_sat,      b_sat;

    logic [7:0] r_sat_clip, g_sat_clip, b_sat_clip;

    // Compute difference (delta) from grayscale value.
    assign r_delta = imed_t'({1'b0, r_i}) - imed_t'({1'b0, gy_i});
    assign g_delta = imed_t'({1'b0, g_i}) - imed_t'({1'b0, gy_i});
    assign b_delta = imed_t'({1'b0, b_i}) - imed_t'({1'b0, gy_i});

    // Multiply the difference by the scaling factor and add it to the grayscale value.
    assign r_sat = r_delta * SATURATE_SCALE + imed_t'({1'b0, gy_i});
    assign g_sat = g_delta * SATURATE_SCALE + imed_t'({1'b0, gy_i});
    assign b_sat = b_delta * SATURATE_SCALE + imed_t'({1'b0, gy_i});

    always_comb begin
        // Clip positive values larger than the unsigned maximum to the unsigned maximum.
        if (r_sat[15] == 1'b0 && r_sat[14:0] > 15'd255) begin
            r_sat_clip = 8'd255;
        // Clip negative values to zero.
        end else if (r_sat[15] == 1'b1) begin
            r_sat_clip = 8'd0;
        // Leave values between zero and the unsigned maximum intact.
        end else begin
            r_sat_clip = r_sat[7:0];
        end
    end
    always_comb begin
        if (g_sat[15] == 1'b0 && g_sat[14:0] > 15'd255) begin
            g_sat_clip = 8'd255;
        end else if (g_sat[15] == 1'b1) begin
            g_sat_clip = 8'd0;
        end else begin
            g_sat_clip = g_sat[7:0];
        end
    end
    always_comb begin
        if (b_sat[15] == 1'b0 && b_sat[14:0] > 15'd255) begin
            b_sat_clip = 8'd255;
        end else if (b_sat[15] == 1'b1) begin
            b_sat_clip = 8'd0;
        end else begin
            b_sat_clip = b_sat[7:0];
        end
    end

    always_comb begin
        if (en_i) begin
            r_o = r_sat_clip;
            g_o = g_sat_clip;
            b_o = b_sat_clip;
        end else begin
            r_o = r_i;
            g_o = g_i;
            b_o = b_i;
        end
    end

endmodule
