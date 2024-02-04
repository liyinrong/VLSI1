/**
  * Verilog Wrapper for RGB Processing
  *
  * This module exposes the RGB Processing module in Vivado-compatible Verilog.
  */
module rgb_proc_wrap (
    input           clk_i,
    input           rst_ni,

    input  [1:0]    btn_i,
    output [3:0]    led_o,
    input           enable_i,

    input  [7:0]    r_i,
    input  [7:0]    g_i,
    input  [7:0]    b_i,
    input           hsync_i,
    input           vsync_i,
    input           vde_i,
    input           valid_i,
    output          ready_o,

    output [7:0]    r_o,
    output [7:0]    g_o,
    output [7:0]    b_o,
    output          hsync_o,
    output          vsync_o,
    output          vde_o,
    output          valid_o,
    input           ready_i
);

    wire [7:0]  inp_reg_r,  inp_reg_g,  inp_reg_b,
                proc_oup_r, proc_oup_g, proc_oup_b;

    wire [23:0] proc_oup_reg_rgb,
                ff_oup_reg_rgb,
                oup_reg_rgb;

    wire        inp_reg_hsync,      inp_reg_vsync,      inp_reg_vde,
                proc_oup_hsync,     proc_oup_vsync,     proc_oup_vde,
                proc_oup_reg_hsync, proc_oup_reg_vsync, proc_oup_reg_vde,
                ff_oup_reg_hsync,   ff_oup_reg_vsync,   ff_oup_reg_vde,
                oup_reg_hsync,      oup_reg_vsync,      oup_reg_vde;

    wire        inp_reg_valid,      inp_reg_ready,
                proc_inp_valid,     proc_inp_ready,
                ff_valid,           ff_ready,
                proc_oup_valid,     proc_oup_ready,
                proc_oup_reg_valid, proc_oup_reg_ready,
                ff_oup_reg_valid,   ff_oup_reg_ready,
                oup_reg_valid,      oup_reg_ready;

    rgb_spill_reg #(
        .WIDTH      (24)
    ) i_inp_reg (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),

        .rgb_i      ({r_i, g_i, b_i}),
        .hsync_i    (hsync_i),
        .vsync_i    (vsync_i),
        .vde_i      (vde_i),
        .valid_i    (valid_i),
        .ready_o    (ready_o),

        .rgb_o      ({inp_reg_r, inp_reg_g, inp_reg_b}),
        .hsync_o    (inp_reg_hsync),
        .vsync_o    (inp_reg_vsync),
        .vde_o      (inp_reg_vde),
        .valid_o    (inp_reg_valid),
        .ready_i    (inp_reg_ready)
    );

    stream_demux #(
        .N_OUP  (2)
    ) i_inp_demux (
        .inp_valid_i    (inp_reg_valid),
        .inp_ready_o    (inp_reg_ready),

        .oup_sel_i      (enable_i),

        .oup_valid_o    ({proc_inp_valid, ff_valid}),
        .oup_ready_i    ({proc_inp_ready, ff_ready})
    );

    rgb_proc i_rgb_proc (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),
        .btn_i      (btn_i),
        .led_o      (led_o),

        .r_i        (inp_reg_r),
        .g_i        (inp_reg_g),
        .b_i        (inp_reg_b),
        .hsync_i    (inp_reg_hsync),
        .vsync_i    (inp_reg_vsync),
        .vde_i      (inp_reg_vde),
        .valid_i    (proc_inp_valid),
        .ready_o    (proc_inp_ready),

        .r_o        (proc_oup_r),
        .g_o        (proc_oup_g),
        .b_o        (proc_oup_b),
        .hsync_o    (proc_oup_hsync),
        .vsync_o    (proc_oup_vsync),
        .vde_o      (proc_oup_vde),
        .valid_o    (proc_oup_valid),
        .ready_i    (proc_oup_ready)
    );

    rgb_reg #(
        .WIDTH      (24)
    ) i_proc_oup_reg (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),

        .rgb_i      ({proc_oup_r, proc_oup_g, proc_oup_b}),
        .hsync_i    (proc_oup_hsync),
        .vsync_i    (proc_oup_vsync),
        .vde_i      (proc_oup_vde),
        .valid_i    (proc_oup_valid),
        .ready_o    (proc_oup_ready),

        .rgb_o      (proc_oup_reg_rgb),
        .hsync_o    (proc_oup_reg_hsync),
        .vsync_o    (proc_oup_reg_vsync),
        .vde_o      (proc_oup_reg_vde),
        .valid_o    (proc_oup_reg_valid),
        .ready_i    (proc_oup_reg_ready)
    );

    rgb_reg #(
        .WIDTH      (24)
    ) i_ff_shim_reg (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),

        .rgb_i      ({inp_reg_r, inp_reg_g, inp_reg_b}),
        .hsync_i    (inp_reg_hsync),
        .vsync_i    (inp_reg_vsync),
        .vde_i      (inp_reg_vde),
        .valid_i    (ff_valid),
        .ready_o    (ff_ready),

        .rgb_o      (ff_oup_reg_rgb),
        .hsync_o    (ff_oup_reg_hsync),
        .vsync_o    (ff_oup_reg_vsync),
        .vde_o      (ff_oup_reg_vde),
        .valid_o    (ff_oup_reg_valid),
        .ready_i    (ff_oup_reg_ready)
    );

    rgb_mux #(
        .WIDTH      (24),
        .N_INP      (2)
    ) i_oup_mux (
        .rgb_i      ({proc_oup_reg_rgb,     ff_oup_reg_rgb}),
        .hsync_i    ({proc_oup_reg_hsync,   ff_oup_reg_hsync}),
        .vsync_i    ({proc_oup_reg_vsync,   ff_oup_reg_vsync}),
        .vde_i      ({proc_oup_reg_vde,     ff_oup_reg_vde}),
        .valid_i    ({proc_oup_reg_valid,   ff_oup_reg_valid}),
        .ready_o    ({proc_oup_reg_ready,   ff_oup_reg_ready}),

        .inp_sel_i  (enable_i),

        .rgb_o      (oup_reg_rgb),
        .hsync_o    (oup_reg_hsync),
        .vsync_o    (oup_reg_vsync),
        .vde_o      (oup_reg_vde),
        .valid_o    (oup_reg_valid),
        .ready_i    (oup_reg_ready)
    );

    rgb_spill_reg #(
        .WIDTH      (24)
    ) i_oup_reg (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),

        .rgb_i      (oup_reg_rgb),
        .hsync_i    (oup_reg_hsync),
        .vsync_i    (oup_reg_vsync),
        .vde_i      (oup_reg_vde),
        .valid_i    (oup_reg_valid),
        .ready_o    (oup_reg_ready),

        .rgb_o      ({r_o, g_o, b_o}),
        .hsync_o    (hsync_o),
        .vsync_o    (vsync_o),
        .vde_o      (vde_o),
        .valid_o    (valid_o),
        .ready_i    (ready_i)
    );

endmodule
