module vid_pipeline #(
    /// Constants, DO NOT CHANGE!
    localparam integer NumFilters = 4
) (
    input  logic                    clk_i,
    input  logic                    rst_ni,

    input  logic [NumFilters-1:0]    enable_i,

    input  logic [7:0]              r_i,
    input  logic [7:0]              g_i,
    input  logic [7:0]              b_i,
    input  logic                    hsync_i,
    input  logic                    vsync_i,
    input  logic                    vde_i,
    input  logic                    valid_i,
    output logic                    ready_o,

    output logic [7:0]              r_o,
    output logic [7:0]              g_o,
    output logic [7:0]              b_o,
    output logic                    hsync_o,
    output logic                    vsync_o,
    output logic                    vde_o,
    output logic                    valid_o,
    input  logic                    ready_i
);

    logic [7:0]     gy_p0,
                    gy_p1,
                    r_p1,   g_p1,   b_p1,
                    rs_p1,  gs_p1,  bs_p1,
                    r_p2,   g_p2,   b_p2,
                    rn_p2,  gn_p2,  bn_p2,
                    r_p3,   g_p3,   b_p3,
                    rc_p3,  gc_p3,  bc_p3;

    logic           hsync_p1,   vsync_p1,   vde_p1,     valid_p1,   ready_p1,
                    hsync_p2,   vsync_p2,   vde_p2,     valid_p2,   ready_p2,
                    hsync_p3,   vsync_p3,   vde_p3,     valid_p3,   ready_p3;

    rgb_grayscaler i_rgb_grayscaler (
        .en_i   (enable_i[0]),

        .r_i    (r_i),
        .g_i    (g_i),
        .b_i    (b_i),

        .gray_o (gy_p0)
    );

    rgb_reg #(
        .Width (4*8)
    ) i_reg_p1 (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),

        .rgb_i      ({r_i, g_i, b_i, gy_p0}),
        .hsync_i    (hsync_i),
        .vsync_i    (vsync_i),
        .vde_i      (vde_i),
        .valid_i    (valid_i),
        .ready_o    (ready_o),

        .rgb_o      ({r_p1, g_p1, b_p1, gy_p1}),
        .hsync_o    (hsync_p1),
        .vsync_o    (vsync_p1),
        .vde_o      (vde_p1),
        .valid_o    (valid_p1),
        .ready_i    (ready_p1)
    );

    rgb_saturator i_rgb_saturator (
        .en_i   (enable_i[1]),

        .r_i    (r_p1),
        .g_i    (g_p1),
        .b_i    (b_p1),
        .gy_i   (gy_p1),

        .r_o    (rs_p1),
        .g_o    (gs_p1),
        .b_o    (bs_p1)
    );

    rgb_reg #(
        .Width (3*8)
    ) i_reg_p2 (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),

        .rgb_i      ({rs_p1, gs_p1, bs_p1}),
        .hsync_i    (hsync_p1),
        .vsync_i    (vsync_p1),
        .vde_i      (vde_p1),
        .valid_i    (valid_p1),
        .ready_o    (ready_p1),

        .rgb_o      ({r_p2, g_p2, b_p2}),
        .hsync_o    (hsync_p2),
        .vsync_o    (vsync_p2),
        .vde_o      (vde_p2),
        .valid_o    (valid_p2),
        .ready_i    (ready_p2)
    );

    rgb_inverter i_rgb_inverter (
        .en_i   (enable_i[2]),

        .r_i    (r_p2),
        .g_i    (g_p2),
        .b_i    (b_p2),

        .r_o    (rn_p2),
        .g_o    (gn_p2),
        .b_o    (bn_p2)
    );

    rgb_reg #(
        .Width (3*8)
    ) i_reg_p3 (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),

        .rgb_i      ({rn_p2, gn_p2, bn_p2}),
        .hsync_i    (hsync_p2),
        .vsync_i    (vsync_p2),
        .vde_i      (vde_p2),
        .valid_i    (valid_p2),
        .ready_o    (ready_p2),

        .rgb_o      ({r_p3, g_p3, b_p3}),
        .hsync_o    (hsync_p3),
        .vsync_o    (vsync_p3),
        .vde_o      (vde_p3),
        .valid_o    (valid_p3),
        .ready_i    (ready_p3)
    );

    rgb_contrast_adj i_rgb_contrast_adj (
        .en_i   (enable_i[3]),

        .r_i    (r_p3),
        .g_i    (g_p3),
        .b_i    (b_p3),

        .r_o    (rc_p3),
        .g_o    (gc_p3),
        .b_o    (bc_p3)
    );

    rgb_reg #(
        .Width (3*8)
    ) i_reg_p4 (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),

        .rgb_i      ({rc_p3, gc_p3, bc_p3}),
        .hsync_i    (hsync_p3),
        .vsync_i    (vsync_p3),
        .vde_i      (vde_p3),
        .valid_i    (valid_p3),
        .ready_o    (ready_p3),

        .rgb_o      ({r_o, g_o, b_o}),
        .hsync_o    (hsync_o),
        .vsync_o    (vsync_o),
        .vde_o      (vde_o),
        .valid_o    (valid_o),
        .ready_i    (ready_i)
    );

endmodule
