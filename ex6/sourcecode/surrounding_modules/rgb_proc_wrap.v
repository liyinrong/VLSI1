/**
  * Verilog Wrapper for RGB Processing
  *
  * This module exposes the RGB Processing module in Vivado-compatible Verilog.
  */
module rgb_proc_wrap (
    input           clk_i,
    input           rst_ni,

    input           enable_i,

    input  [2:0]    switch_i,

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

    wire [7:0]  proc_rt_inp_reg_r,      proc_rt_inp_reg_g,      proc_rt_inp_reg_b,
                proc_oup_r,             proc_oup_g,             proc_oup_b;

    wire [23:0] inp_reg_rgb,
                // proc path
                proc_rt_oup_reg_rgb,
                proc_oup_reg_rgb,
                // FF path
                ff_shim_reg_rgb,
                ff_shim_reg2_rgb,
                ff_oup_reg_rgb,
                // oup reg
                oup_reg_rgb;

    wire        inp_reg_hsync,          inp_reg_vsync,          inp_reg_vde,
                // proc path
                proc_rt_inp_reg_hsync,  proc_rt_inp_reg_vsync,  proc_rt_inp_reg_vde,
                proc_oup_hsync,         proc_oup_vsync,         proc_oup_vde,
                proc_rt_oup_reg_hsync,  proc_rt_oup_reg_vsync,  proc_rt_oup_reg_vde,
                proc_oup_reg_hsync,     proc_oup_reg_vsync,     proc_oup_reg_vde,
                // FF path
                ff_shim_reg_hsync,      ff_shim_reg_vsync,      ff_shim_reg_vde,
                ff_shim_reg2_hsync,     ff_shim_reg2_vsync,     ff_shim_reg2_vde,
                ff_oup_reg_hsync,       ff_oup_reg_vsync,       ff_oup_reg_vde,
                // oup reg
                oup_reg_hsync,          oup_reg_vsync,          oup_reg_vde;

    wire        inp_reg_valid,          inp_reg_ready,
                // proc path
                proc_inp_valid,         proc_inp_ready,
                proc_rt_inp_reg_valid,  proc_rt_inp_reg_ready,
                proc_oup_valid,         proc_oup_ready,
                proc_rt_oup_reg_valid,  proc_rt_oup_reg_ready,
                proc_oup_reg_valid,     proc_oup_reg_ready,
                // FF path
                ff_valid,               ff_ready,
                ff_shim_reg_valid,      ff_shim_reg_ready,
                ff_shim_reg2_valid,     ff_shim_reg2_ready,
                ff_oup_reg_valid,       ff_oup_reg_ready,
                // oup reg
                oup_reg_valid,          oup_reg_ready;

    rgb_spill_reg #(
        .Width      (24)
    ) i_inp_reg (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),

        .rgb_i      ({r_i, g_i, b_i}),
        .hsync_i    (hsync_i),
        .vsync_i    (vsync_i),
        .vde_i      (vde_i),
        .valid_i    (valid_i),
        .ready_o    (ready_o),

        .rgb_o      (inp_reg_rgb),
        .hsync_o    (inp_reg_hsync),
        .vsync_o    (inp_reg_vsync),
        .vde_o      (inp_reg_vde),
        .valid_o    (inp_reg_valid),
        .ready_i    (inp_reg_ready)
    );

    stream_demux #(
        .NumOup  (2)
    ) i_inp_demux (
        .inp_valid_i    (inp_reg_valid),
        .inp_ready_o    (inp_reg_ready),

        .oup_sel_i      (enable_i),

        .oup_valid_o    ({proc_inp_valid, ff_valid}),
        .oup_ready_i    ({proc_inp_ready, ff_ready})
    );

    rgb_reg #(
        .Width      (24)
    ) i_proc_rt_inp_reg (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),

        .rgb_i      (inp_reg_rgb),
        .hsync_i    (inp_reg_hsync),
        .vsync_i    (inp_reg_vsync),
        .vde_i      (inp_reg_vde),
        .valid_i    (proc_inp_valid),
        .ready_o    (proc_inp_ready),

        .rgb_o      ({proc_rt_inp_reg_r, proc_rt_inp_reg_g, proc_rt_inp_reg_b}),
        .hsync_o    (proc_rt_inp_reg_hsync),
        .vsync_o    (proc_rt_inp_reg_vsync),
        .vde_o      (proc_rt_inp_reg_vde),
        .valid_o    (proc_rt_inp_reg_valid),
        .ready_i    (proc_rt_inp_reg_ready)
    );

    rgb_proc i_rgb_proc (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),

        .switch_i   (switch_i),

        .r_i        (proc_rt_inp_reg_r),
        .g_i        (proc_rt_inp_reg_g),
        .b_i        (proc_rt_inp_reg_b),
        .hsync_i    (proc_rt_inp_reg_hsync),
        .vsync_i    (proc_rt_inp_reg_vsync),
        .vde_i      (proc_rt_inp_reg_vde),
        .valid_i    (proc_rt_inp_reg_valid),
        .ready_o    (proc_rt_inp_reg_ready),

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
        .Width      (24)
    ) i_proc_rt_oup_reg (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),

        .rgb_i      ({proc_oup_r, proc_oup_g, proc_oup_b}),
        .hsync_i    (proc_oup_hsync),
        .vsync_i    (proc_oup_vsync),
        .vde_i      (proc_oup_vde),
        .valid_i    (proc_oup_valid),
        .ready_o    (proc_oup_ready),

        .rgb_o      (proc_rt_oup_reg_rgb),
        .hsync_o    (proc_rt_oup_reg_hsync),
        .vsync_o    (proc_rt_oup_reg_vsync),
        .vde_o      (proc_rt_oup_reg_vde),
        .valid_o    (proc_rt_oup_reg_valid),
        .ready_i    (proc_rt_oup_reg_ready)
    );

    rgb_spill_reg #(
        .Width      (24)
    ) i_proc_oup_reg (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),

        .rgb_i      (proc_rt_oup_reg_rgb),
        .hsync_i    (proc_rt_oup_reg_hsync),
        .vsync_i    (proc_rt_oup_reg_vsync),
        .vde_i      (proc_rt_oup_reg_vde),
        .valid_i    (proc_rt_oup_reg_valid),
        .ready_o    (proc_rt_oup_reg_ready),

        .rgb_o      (proc_oup_reg_rgb),
        .hsync_o    (proc_oup_reg_hsync),
        .vsync_o    (proc_oup_reg_vsync),
        .vde_o      (proc_oup_reg_vde),
        .valid_o    (proc_oup_reg_valid),
        .ready_i    (proc_oup_reg_ready)
    );

    rgb_reg #(
        .Width      (24)
    ) i_ff_shim_reg (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),

        .rgb_i      (inp_reg_rgb),
        .hsync_i    (inp_reg_hsync),
        .vsync_i    (inp_reg_vsync),
        .vde_i      (inp_reg_vde),
        .valid_i    (ff_valid),
        .ready_o    (ff_ready),

        .rgb_o      (ff_shim_reg_rgb),
        .hsync_o    (ff_shim_reg_hsync),
        .vsync_o    (ff_shim_reg_vsync),
        .vde_o      (ff_shim_reg_vde),
        .valid_o    (ff_shim_reg_valid),
        .ready_i    (ff_shim_reg_ready)
    );

    rgb_reg #(
        .Width      (24)
    ) i_ff_shim_reg2 (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),

        .rgb_i      (ff_shim_reg_rgb),
        .hsync_i    (ff_shim_reg_hsync),
        .vsync_i    (ff_shim_reg_vsync),
        .vde_i      (ff_shim_reg_vde),
        .valid_i    (ff_shim_reg_valid),
        .ready_o    (ff_shim_reg_ready),

        .rgb_o      (ff_shim_reg2_rgb),
        .hsync_o    (ff_shim_reg2_hsync),
        .vsync_o    (ff_shim_reg2_vsync),
        .vde_o      (ff_shim_reg2_vde),
        .valid_o    (ff_shim_reg2_valid),
        .ready_i    (ff_shim_reg2_ready)
    );

    rgb_spill_reg #(
        .Width      (24)
    ) i_ff_oup_reg (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),

        .rgb_i      (ff_shim_reg2_rgb),
        .hsync_i    (ff_shim_reg2_hsync),
        .vsync_i    (ff_shim_reg2_vsync),
        .vde_i      (ff_shim_reg2_vde),
        .valid_i    (ff_shim_reg2_valid),
        .ready_o    (ff_shim_reg2_ready),

        .rgb_o      (ff_oup_reg_rgb),
        .hsync_o    (ff_oup_reg_hsync),
        .vsync_o    (ff_oup_reg_vsync),
        .vde_o      (ff_oup_reg_vde),
        .valid_o    (ff_oup_reg_valid),
        .ready_i    (ff_oup_reg_ready)
    );

    rgb_mux #(
        .Width      (24),
        .NumInp     (2)
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
        .Width      (24)
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
