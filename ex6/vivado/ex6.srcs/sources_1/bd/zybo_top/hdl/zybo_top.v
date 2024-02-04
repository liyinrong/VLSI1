//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.2 (lin64) Build 1909853 Thu Jun 15 18:39:10 MDT 2017
//Date        : Sat Jan 27 18:18:14 2024
//Host        : tardis-c03 running 64-bit Debian GNU/Linux 10 (buster)
//Command     : generate_target zybo_top.bd
//Design      : zybo_top
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module hdmi_rx_imp_1BNS5YU
   (b_o,
    clk_i,
    ddc_scl_i,
    ddc_scl_o,
    ddc_scl_t,
    ddc_sda_i,
    ddc_sda_o,
    ddc_sda_t,
    full,
    g_o,
    hdmi_clk_n_i,
    hdmi_clk_o,
    hdmi_clk_p_i,
    hdmi_n_i,
    hdmi_p_i,
    hdmi_rst_no,
    hsync_o,
    proc_clk_o,
    r_o,
    ready_i,
    rst_no,
    rst_o,
    valid_o,
    vde_o,
    vsync_o);
  output [7:0]b_o;
  input clk_i;
  input ddc_scl_i;
  output ddc_scl_o;
  output ddc_scl_t;
  input ddc_sda_i;
  output ddc_sda_o;
  output ddc_sda_t;
  output full;
  output [7:0]g_o;
  input hdmi_clk_n_i;
  output hdmi_clk_o;
  input hdmi_clk_p_i;
  input [2:0]hdmi_n_i;
  input [2:0]hdmi_p_i;
  output hdmi_rst_no;
  output [0:0]hsync_o;
  output proc_clk_o;
  output [7:0]r_o;
  input ready_i;
  output rst_no;
  output rst_o;
  output [0:0]valid_o;
  output [0:0]vde_o;
  output [0:0]vsync_o;

  wire [7:0]b_slice_Dout;
  wire clk_gen_clk_out1;
  wire clk_gen_clk_out2;
  wire clk_gen_locked;
  wire clk_i_1;
  wire [26:0]concat_rgb_dout;
  wire dvi2rgb_DDC_SCL_I;
  wire dvi2rgb_DDC_SCL_O;
  wire dvi2rgb_DDC_SCL_T;
  wire dvi2rgb_DDC_SDA_I;
  wire dvi2rgb_DDC_SDA_O;
  wire dvi2rgb_DDC_SDA_T;
  wire dvi2rgb_PixelClk;
  wire dvi2rgb_aPixelClkLckd;
  wire [23:0]dvi2rgb_vid_pData;
  wire dvi2rgb_vid_pHSync;
  wire dvi2rgb_vid_pVDE;
  wire dvi2rgb_vid_pVSync;
  wire [7:0]g_slice_Dout;
  wire hdmi_clk_n_i_1;
  wire hdmi_clk_p_i_1;
  wire [2:0]hdmi_n_i_1;
  wire [2:0]hdmi_p_i_1;
  wire [0:0]hsync_slice_Dout;
  wire [0:0]not_empty_Res;
  wire [7:0]r_slice_Dout;
  wire ready_i_1;
  wire rst_gen_rst_no;
  wire rst_gen_rst_o;
  wire [26:0]rx_dc_fifo_dout;
  wire rx_dc_fifo_empty;
  wire rx_dc_fifo_full;
  wire [0:0]vde_slice_Dout;
  wire [0:0]vsync_slice_Dout;

  assign b_o[7:0] = b_slice_Dout;
  assign clk_i_1 = clk_i;
  assign ddc_scl_o = dvi2rgb_DDC_SCL_O;
  assign ddc_scl_t = dvi2rgb_DDC_SCL_T;
  assign ddc_sda_o = dvi2rgb_DDC_SDA_O;
  assign ddc_sda_t = dvi2rgb_DDC_SDA_T;
  assign dvi2rgb_DDC_SCL_I = ddc_scl_i;
  assign dvi2rgb_DDC_SDA_I = ddc_sda_i;
  assign full = rx_dc_fifo_full;
  assign g_o[7:0] = g_slice_Dout;
  assign hdmi_clk_n_i_1 = hdmi_clk_n_i;
  assign hdmi_clk_o = dvi2rgb_PixelClk;
  assign hdmi_clk_p_i_1 = hdmi_clk_p_i;
  assign hdmi_n_i_1 = hdmi_n_i[2:0];
  assign hdmi_p_i_1 = hdmi_p_i[2:0];
  assign hdmi_rst_no = dvi2rgb_aPixelClkLckd;
  assign hsync_o[0] = hsync_slice_Dout;
  assign proc_clk_o = clk_gen_clk_out2;
  assign r_o[7:0] = r_slice_Dout;
  assign ready_i_1 = ready_i;
  assign rst_no = rst_gen_rst_no;
  assign rst_o = rst_gen_rst_o;
  assign valid_o[0] = not_empty_Res;
  assign vde_o[0] = vde_slice_Dout;
  assign vsync_o[0] = vsync_slice_Dout;
  zybo_top_clk_gen_0 clk_gen
       (.clk_in1(clk_i_1),
        .clk_out1(clk_gen_clk_out1),
        .clk_out2(clk_gen_clk_out2),
        .locked(clk_gen_locked));
  zybo_top_xlconcat_0_5 concat_rgb
       (.In0(dvi2rgb_vid_pData),
        .In1(dvi2rgb_vid_pVSync),
        .In2(dvi2rgb_vid_pHSync),
        .In3(dvi2rgb_vid_pVDE),
        .dout(concat_rgb_dout));
  zybo_top_dvi2rgb_0 dvi2rgb
       (.PixelClk(dvi2rgb_PixelClk),
        .RefClk(clk_gen_clk_out1),
        .SCL_I(dvi2rgb_DDC_SCL_I),
        .SCL_O(dvi2rgb_DDC_SCL_O),
        .SCL_T(dvi2rgb_DDC_SCL_T),
        .SDA_I(dvi2rgb_DDC_SDA_I),
        .SDA_O(dvi2rgb_DDC_SDA_O),
        .SDA_T(dvi2rgb_DDC_SDA_T),
        .TMDS_Clk_n(hdmi_clk_n_i_1),
        .TMDS_Clk_p(hdmi_clk_p_i_1),
        .TMDS_Data_n(hdmi_n_i_1),
        .TMDS_Data_p(hdmi_p_i_1),
        .aPixelClkLckd(dvi2rgb_aPixelClkLckd),
        .aRst_n(rst_gen_rst_no),
        .pRst_n(1'b1),
        .vid_pData(dvi2rgb_vid_pData),
        .vid_pHSync(dvi2rgb_vid_pHSync),
        .vid_pVDE(dvi2rgb_vid_pVDE),
        .vid_pVSync(dvi2rgb_vid_pVSync));
  zybo_top_util_vector_logic_0_1 not_empty
       (.Op1(rx_dc_fifo_empty),
        .Res(not_empty_Res));
  zybo_top_rst_gen_0 rst_gen
       (.clk_i(clk_gen_clk_out2),
        .rst_ni(clk_gen_locked),
        .rst_no(rst_gen_rst_no),
        .rst_o(rst_gen_rst_o));
  zybo_top_fifo_generator_0_1 rx_dc_fifo
       (.din(concat_rgb_dout),
        .dout(rx_dc_fifo_dout),
        .empty(rx_dc_fifo_empty),
        .full(rx_dc_fifo_full),
        .rd_clk(clk_gen_clk_out2),
        .rd_en(ready_i_1),
        .rst(rst_gen_rst_o),
        .wr_clk(dvi2rgb_PixelClk),
        .wr_en(dvi2rgb_aPixelClkLckd));
  zybo_top_r_slice_1 slice_b
       (.Din(rx_dc_fifo_dout),
        .Dout(b_slice_Dout));
  zybo_top_r_slice_0 slice_g
       (.Din(rx_dc_fifo_dout),
        .Dout(g_slice_Dout));
  zybo_top_data_slice_0 slice_hsync
       (.Din(rx_dc_fifo_dout),
        .Dout(hsync_slice_Dout));
  zybo_top_xlslice_0_1 slice_r
       (.Din(rx_dc_fifo_dout),
        .Dout(r_slice_Dout));
  zybo_top_data_slice_2 slice_vde
       (.Din(rx_dc_fifo_dout),
        .Dout(vde_slice_Dout));
  zybo_top_data_slice_1 slice_vsync
       (.Din(rx_dc_fifo_dout),
        .Dout(vsync_slice_Dout));
endmodule

module hdmi_tx_imp_1AAPD2P
   (b_i,
    full,
    g_i,
    hdmi_clk_i,
    hdmi_clk_n_o,
    hdmi_clk_p_o,
    hdmi_n_o,
    hdmi_p_o,
    hdmi_rst_ni,
    hsync_i,
    proc_clk_i,
    r_i,
    ready_o,
    rst_i,
    valid_i,
    vde_i,
    vsync_i);
  input [7:0]b_i;
  output full;
  input [7:0]g_i;
  input hdmi_clk_i;
  output hdmi_clk_n_o;
  output hdmi_clk_p_o;
  output [2:0]hdmi_n_o;
  output [2:0]hdmi_p_o;
  input hdmi_rst_ni;
  input hsync_i;
  input proc_clk_i;
  input [7:0]r_i;
  output [0:0]ready_o;
  input rst_i;
  input valid_i;
  input vde_i;
  input vsync_i;

  wire [7:0]b_i_1;
  wire [26:0]concat_dout;
  wire [23:0]concat_rgb_dout;
  wire [7:0]g_i_1;
  wire hdmi_clk_i_1;
  wire hdmi_rst_ni_1;
  wire hsync_i_1;
  wire [0:0]not_full_Res;
  wire proc_clk_i_1;
  wire [7:0]r_i_1;
  wire rgb2dvi_TMDS_Clk_n;
  wire rgb2dvi_TMDS_Clk_p;
  wire [2:0]rgb2dvi_TMDS_Data_n;
  wire [2:0]rgb2dvi_TMDS_Data_p;
  wire rst_i_1;
  wire [7:0]slice_b_Dout;
  wire [7:0]slice_g_Dout;
  wire [0:0]slice_hsync_Dout;
  wire [7:0]slice_r_Dout;
  wire [0:0]slice_vde_Dout;
  wire [0:0]slice_vsync_Dout;
  wire [26:0]tx_dc_fifo_dout;
  wire tx_dc_fifo_full;
  wire valid_i_1;
  wire vde_i_1;
  wire vsync_i_1;

  assign b_i_1 = b_i[7:0];
  assign full = tx_dc_fifo_full;
  assign g_i_1 = g_i[7:0];
  assign hdmi_clk_i_1 = hdmi_clk_i;
  assign hdmi_clk_n_o = rgb2dvi_TMDS_Clk_n;
  assign hdmi_clk_p_o = rgb2dvi_TMDS_Clk_p;
  assign hdmi_n_o[2:0] = rgb2dvi_TMDS_Data_n;
  assign hdmi_p_o[2:0] = rgb2dvi_TMDS_Data_p;
  assign hdmi_rst_ni_1 = hdmi_rst_ni;
  assign hsync_i_1 = hsync_i;
  assign proc_clk_i_1 = proc_clk_i;
  assign r_i_1 = r_i[7:0];
  assign ready_o[0] = not_full_Res;
  assign rst_i_1 = rst_i;
  assign valid_i_1 = valid_i;
  assign vde_i_1 = vde_i;
  assign vsync_i_1 = vsync_i;
  zybo_top_concat_0 concat
       (.In0(b_i_1),
        .In1(g_i_1),
        .In2(r_i_1),
        .In3(vsync_i_1),
        .In4(hsync_i_1),
        .In5(vde_i_1),
        .dout(concat_dout));
  zybo_top_concat_rgb_0 concat_rgb
       (.In0(slice_b_Dout),
        .In1(slice_g_Dout),
        .In2(slice_r_Dout),
        .dout(concat_rgb_dout));
  zybo_top_util_vector_logic_0_0 not_full
       (.Op1(tx_dc_fifo_full),
        .Res(not_full_Res));
  zybo_top_rgb2dvi_0 rgb2dvi
       (.PixelClk(hdmi_clk_i_1),
        .TMDS_Clk_n(rgb2dvi_TMDS_Clk_n),
        .TMDS_Clk_p(rgb2dvi_TMDS_Clk_p),
        .TMDS_Data_n(rgb2dvi_TMDS_Data_n),
        .TMDS_Data_p(rgb2dvi_TMDS_Data_p),
        .aRst_n(hdmi_rst_ni_1),
        .vid_pData(concat_rgb_dout),
        .vid_pHSync(slice_hsync_Dout),
        .vid_pVDE(slice_vde_Dout),
        .vid_pVSync(slice_vsync_Dout));
  zybo_top_slice_b_0 slice_b
       (.Din(tx_dc_fifo_dout),
        .Dout(slice_b_Dout));
  zybo_top_slice_g_0 slice_g
       (.Din(tx_dc_fifo_dout),
        .Dout(slice_g_Dout));
  zybo_top_slice_hsync_0 slice_hsync
       (.Din(tx_dc_fifo_dout),
        .Dout(slice_hsync_Dout));
  zybo_top_slice_r_0 slice_r
       (.Din(tx_dc_fifo_dout),
        .Dout(slice_r_Dout));
  zybo_top_slice_vde_0 slice_vde
       (.Din(tx_dc_fifo_dout),
        .Dout(slice_vde_Dout));
  zybo_top_slice_vsync_0 slice_vsync
       (.Din(tx_dc_fifo_dout),
        .Dout(slice_vsync_Dout));
  zybo_top_fifo_generator_0_2 tx_dc_fifo
       (.din(concat_dout),
        .dout(tx_dc_fifo_dout),
        .full(tx_dc_fifo_full),
        .rd_clk(hdmi_clk_i_1),
        .rd_en(hdmi_rst_ni_1),
        .rst(rst_i_1),
        .wr_clk(proc_clk_i_1),
        .wr_en(valid_i_1));
endmodule

(* CORE_GENERATION_INFO = "zybo_top,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=zybo_top,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=30,numReposBlks=28,numNonXlnxBlks=4,numHierBlks=2,maxHierDepth=1,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=2,numPkgbdBlks=0,bdsource=USER,synth_mode=Global}" *) (* HW_HANDOFF = "zybo_top.hwdef" *) 
module zybo_top
   (btn_i,
    clk_i,
    hdmi_rx_clk_n_i,
    hdmi_rx_clk_p_i,
    hdmi_rx_ddc_scl_i,
    hdmi_rx_ddc_scl_o,
    hdmi_rx_ddc_scl_t,
    hdmi_rx_ddc_sda_i,
    hdmi_rx_ddc_sda_o,
    hdmi_rx_ddc_sda_t,
    hdmi_rx_hpd_o,
    hdmi_rx_n_i,
    hdmi_rx_p_i,
    hdmi_tx_clk_n_o,
    hdmi_tx_clk_p_o,
    hdmi_tx_n_o,
    hdmi_tx_p_o,
    led_o,
    switch_i);
  input [3:0]btn_i;
  input clk_i;
  input hdmi_rx_clk_n_i;
  input hdmi_rx_clk_p_i;
  input hdmi_rx_ddc_scl_i;
  output hdmi_rx_ddc_scl_o;
  output hdmi_rx_ddc_scl_t;
  input hdmi_rx_ddc_sda_i;
  output hdmi_rx_ddc_sda_o;
  output hdmi_rx_ddc_sda_t;
  output hdmi_rx_hpd_o;
  input [2:0]hdmi_rx_n_i;
  input [2:0]hdmi_rx_p_i;
  output hdmi_tx_clk_n_o;
  output hdmi_tx_clk_p_o;
  output [2:0]hdmi_tx_n_o;
  output [2:0]hdmi_tx_p_o;
  output [3:0]led_o;
  input [3:0]switch_i;

  wire [7:0]b_i_1;
  wire clk_i_1;
  wire [3:0]concat_led_dout;
  wire hdmi_clk_i_1;
  wire hdmi_rst_ni_1;
  wire [7:0]hdmi_rx_b_o;
  wire hdmi_rx_clk_n_i_1;
  wire hdmi_rx_clk_p_i_1;
  wire hdmi_rx_ddc1_SCL_I;
  wire hdmi_rx_ddc1_SCL_O;
  wire hdmi_rx_ddc1_SCL_T;
  wire hdmi_rx_ddc1_SDA_I;
  wire hdmi_rx_ddc1_SDA_O;
  wire hdmi_rx_ddc1_SDA_T;
  wire hdmi_rx_full;
  wire [7:0]hdmi_rx_g_o;
  wire [0:0]hdmi_rx_hsync_o;
  wire [2:0]hdmi_rx_n_i_1;
  wire [2:0]hdmi_rx_p_i_1;
  wire [7:0]hdmi_rx_r_o;
  wire hdmi_rx_rst_no;
  wire hdmi_rx_rst_o;
  wire [0:0]hdmi_rx_valid_o;
  wire [0:0]hdmi_rx_vde_o;
  wire [0:0]hdmi_rx_vsync_o;
  wire hdmi_tx_full;
  wire hdmi_tx_hdmi_clk_n_o;
  wire hdmi_tx_hdmi_clk_p_o;
  wire [2:0]hdmi_tx_hdmi_n_o;
  wire [2:0]hdmi_tx_hdmi_p_o;
  wire [0:0]hdmi_tx_ready_o;
  wire proc_clk_i_1;
  wire [7:0]r_i_1;
  wire [7:0]rgb_proc_wrap_0_g_o;
  wire rgb_proc_wrap_0_hsync_o;
  wire rgb_proc_wrap_0_ready_o;
  wire rgb_proc_wrap_0_vde_o;
  wire [0:0]slice_enable_Dout;
  wire [2:0]slice_switch_Dout;
  wire [3:0]switch_i_1;
  wire valid_i_1;
  wire vsync_i_1;
  wire [1:0]xlconstant_0_dout;

  assign clk_i_1 = clk_i;
  assign hdmi_rx_clk_n_i_1 = hdmi_rx_clk_n_i;
  assign hdmi_rx_clk_p_i_1 = hdmi_rx_clk_p_i;
  assign hdmi_rx_ddc1_SCL_I = hdmi_rx_ddc_scl_i;
  assign hdmi_rx_ddc1_SDA_I = hdmi_rx_ddc_sda_i;
  assign hdmi_rx_ddc_scl_o = hdmi_rx_ddc1_SCL_O;
  assign hdmi_rx_ddc_scl_t = hdmi_rx_ddc1_SCL_T;
  assign hdmi_rx_ddc_sda_o = hdmi_rx_ddc1_SDA_O;
  assign hdmi_rx_ddc_sda_t = hdmi_rx_ddc1_SDA_T;
  assign hdmi_rx_hpd_o = hdmi_rx_rst_no;
  assign hdmi_rx_n_i_1 = hdmi_rx_n_i[2:0];
  assign hdmi_rx_p_i_1 = hdmi_rx_p_i[2:0];
  assign hdmi_tx_clk_n_o = hdmi_tx_hdmi_clk_n_o;
  assign hdmi_tx_clk_p_o = hdmi_tx_hdmi_clk_p_o;
  assign hdmi_tx_n_o[2:0] = hdmi_tx_hdmi_n_o;
  assign hdmi_tx_p_o[2:0] = hdmi_tx_hdmi_p_o;
  assign led_o[3:0] = concat_led_dout;
  assign switch_i_1 = switch_i[3:0];
  zybo_top_xlconcat_0_0 concat_led
       (.In0(hdmi_tx_full),
        .In1(xlconstant_0_dout),
        .In2(hdmi_rx_full),
        .dout(concat_led_dout));
  zybo_top_xlconstant_0_0 constant_0
       (.dout(xlconstant_0_dout));
  hdmi_rx_imp_1BNS5YU hdmi_rx
       (.b_o(hdmi_rx_b_o),
        .clk_i(clk_i_1),
        .ddc_scl_i(hdmi_rx_ddc1_SCL_I),
        .ddc_scl_o(hdmi_rx_ddc1_SCL_O),
        .ddc_scl_t(hdmi_rx_ddc1_SCL_T),
        .ddc_sda_i(hdmi_rx_ddc1_SDA_I),
        .ddc_sda_o(hdmi_rx_ddc1_SDA_O),
        .ddc_sda_t(hdmi_rx_ddc1_SDA_T),
        .full(hdmi_rx_full),
        .g_o(hdmi_rx_g_o),
        .hdmi_clk_n_i(hdmi_rx_clk_n_i_1),
        .hdmi_clk_o(hdmi_clk_i_1),
        .hdmi_clk_p_i(hdmi_rx_clk_p_i_1),
        .hdmi_n_i(hdmi_rx_n_i_1),
        .hdmi_p_i(hdmi_rx_p_i_1),
        .hdmi_rst_no(hdmi_rst_ni_1),
        .hsync_o(hdmi_rx_hsync_o),
        .proc_clk_o(proc_clk_i_1),
        .r_o(hdmi_rx_r_o),
        .ready_i(rgb_proc_wrap_0_ready_o),
        .rst_no(hdmi_rx_rst_no),
        .rst_o(hdmi_rx_rst_o),
        .valid_o(hdmi_rx_valid_o),
        .vde_o(hdmi_rx_vde_o),
        .vsync_o(hdmi_rx_vsync_o));
  hdmi_tx_imp_1AAPD2P hdmi_tx
       (.b_i(b_i_1),
        .full(hdmi_tx_full),
        .g_i(rgb_proc_wrap_0_g_o),
        .hdmi_clk_i(hdmi_clk_i_1),
        .hdmi_clk_n_o(hdmi_tx_hdmi_clk_n_o),
        .hdmi_clk_p_o(hdmi_tx_hdmi_clk_p_o),
        .hdmi_n_o(hdmi_tx_hdmi_n_o),
        .hdmi_p_o(hdmi_tx_hdmi_p_o),
        .hdmi_rst_ni(hdmi_rst_ni_1),
        .hsync_i(rgb_proc_wrap_0_hsync_o),
        .proc_clk_i(proc_clk_i_1),
        .r_i(r_i_1),
        .ready_o(hdmi_tx_ready_o),
        .rst_i(hdmi_rx_rst_o),
        .valid_i(valid_i_1),
        .vde_i(rgb_proc_wrap_0_vde_o),
        .vsync_i(vsync_i_1));
  zybo_top_rgb_proc_wrap_0_0 rgb_proc_wrap_0
       (.b_i(hdmi_rx_b_o),
        .b_o(b_i_1),
        .clk_i(proc_clk_i_1),
        .enable_i(slice_enable_Dout),
        .g_i(hdmi_rx_g_o),
        .g_o(rgb_proc_wrap_0_g_o),
        .hsync_i(hdmi_rx_hsync_o),
        .hsync_o(rgb_proc_wrap_0_hsync_o),
        .r_i(hdmi_rx_r_o),
        .r_o(r_i_1),
        .ready_i(hdmi_tx_ready_o),
        .ready_o(rgb_proc_wrap_0_ready_o),
        .rst_ni(hdmi_rx_rst_no),
        .switch_i(slice_switch_Dout),
        .valid_i(hdmi_rx_valid_o),
        .valid_o(valid_i_1),
        .vde_i(hdmi_rx_vde_o),
        .vde_o(rgb_proc_wrap_0_vde_o),
        .vsync_i(hdmi_rx_vsync_o),
        .vsync_o(vsync_i_1));
  zybo_top_xlslice_0_0 slice_enable
       (.Din(switch_i_1),
        .Dout(slice_enable_Dout));
  zybo_top_xlslice_0_2 slice_switch
       (.Din(switch_i_1),
        .Dout(slice_switch_Dout));
endmodule
