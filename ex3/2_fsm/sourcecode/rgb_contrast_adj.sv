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
    localparam integer Range0   = 0;                                        // 0
    localparam integer Range1   = 255 / 3;                                  // 85
    localparam integer Range2   = 255 * 2 / 3;                              // 170
    localparam integer Range3   = 255;                                      // 255

    localparam integer Scale    = 1;
    localparam integer level0   = 0;                                        // 0
    localparam integer level1   = (255 / 3) >> Scale;                       // 42
    localparam integer level2   = 255 - ((255 / 3) >> Scale);               // 213
    localparam integer level3   = 255;                                      // 255

    localparam integer MidGrad = (level2 - level1) / (Range2 - Range1);    // 2

    logic [7:0] r_adj,
                g_adj,
                b_adj;

    always_comb begin
        if (r_i < Range1) begin                             // r_i   in [  0,  84]
            r_adj = r_i >> Scale;                           // r_adj in [  0,  42]
        end else if (r_i < Range2) begin                    // r_i   in [ 85, 169]
            r_adj = level1 + (r_i - Range1) * MidGrad;     // r_adj in [ 42, 210]
        end else begin                                      // r_i   in [170, 255]
            r_adj = level2 + ((r_i - Range2) >> Scale);     // r_adj in [213, 255]
        end
    end
    always_comb begin
        if (g_i < Range1) begin
            g_adj = g_i >> Scale;
        end else if (g_i < Range2) begin
            g_adj = level1 + (g_i - Range1) * MidGrad;
        end else begin
            g_adj = level2 + ((g_i - Range2) >> Scale);
        end
    end
    always_comb begin
        if (b_i < Range1) begin
            b_adj = b_i >> Scale;
        end else if (b_i < Range2) begin
            b_adj = level1 + (b_i - Range1) * MidGrad;
        end else begin
            b_adj = level2 + ((b_i - Range2) >> Scale);
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
