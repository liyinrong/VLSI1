module rgb_contrast_adj (
    input  logic        en_i,

    input  logic [7:0]  r_i,
    input  logic [7:0]  g_i,
    input  logic [7:0]  b_i,

    output logic [7:0]  r_o,
    output logic [7:0]  g_o,
    output logic [7:0]  b_o
);

    // Constants; change only if you can guarantee results and intermediate results fit into value
    // range of signals (see analysis below).
    localparam integer RANGE0   = 0;                                        // 0
    localparam integer RANGE1   = 255 / 3;                                  // 85
    localparam integer RANGE2   = 255 * 2 / 3;                              // 170
    localparam integer RANGE3   = 255;                                      // 255

    localparam integer SCALE    = 1;
    localparam integer LEVEL0   = 0;                                        // 0
    localparam integer LEVEL1   = (255 / 3) >> SCALE;                       // 42
    localparam integer LEVEL2   = 255 - ((255 / 3) >> SCALE);               // 213
    localparam integer LEVEL3   = 255;                                      // 255

    localparam integer MID_GRAD = (LEVEL2 - LEVEL1) / (RANGE2 - RANGE1);    // 2

    logic [7:0] r_adj,
                g_adj,
                b_adj;

    always_comb begin
        if (r_i < RANGE1) begin                             // r_i   in [  0,  84]
            r_adj = r_i >> SCALE;                           // r_adj in [  0,  42]
        end else if (r_i < RANGE2) begin                    // r_i   in [ 85, 169]
            r_adj = LEVEL1 + (r_i - RANGE1) * MID_GRAD;     // r_adj in [ 42, 210]
        end else begin                                      // r_i   in [170, 255]
            r_adj = LEVEL2 + ((r_i - RANGE2) >> SCALE);     // r_adj in [213, 255]
        end
    end
    always_comb begin
        if (g_i < RANGE1) begin
            g_adj = g_i >> SCALE;
        end else if (g_i < RANGE2) begin
            g_adj = LEVEL1 + (g_i - RANGE1) * MID_GRAD;
        end else begin
            g_adj = LEVEL2 + ((g_i - RANGE2) >> SCALE);
        end
    end
    always_comb begin
        if (b_i < RANGE1) begin
            b_adj = b_i >> SCALE;
        end else if (b_i < RANGE2) begin
            b_adj = LEVEL1 + (b_i - RANGE1) * MID_GRAD;
        end else begin
            b_adj = LEVEL2 + ((b_i - RANGE2) >> SCALE);
        end
    end

    always_comb begin
        if (en_i) begin
            r_o = r_adj;
            g_o = g_adj;
            b_o = b_adj;
        end else begin
            r_o = r_i;
            g_o = g_i;
            b_o = b_i;
        end
    end

endmodule
