//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.2 (lin64) Build 1909853 Thu Jun 15 18:39:10 MDT 2017
//Date        : Sat Jan 27 18:18:14 2024
//Host        : tardis-c03 running 64-bit Debian GNU/Linux 10 (buster)
//Command     : generate_target zybo_top_wrapper.bd
//Design      : zybo_top_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module zybo_top_wrapper
   (btn_i,
    clk_i,
    hdmi_rx_clk_n_i,
    hdmi_rx_clk_p_i,
    hdmi_rx_ddc_scl_io,
    hdmi_rx_ddc_sda_io,
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
  inout hdmi_rx_ddc_scl_io;
  inout hdmi_rx_ddc_sda_io;
  output hdmi_rx_hpd_o;
  input [2:0]hdmi_rx_n_i;
  input [2:0]hdmi_rx_p_i;
  output hdmi_tx_clk_n_o;
  output hdmi_tx_clk_p_o;
  output [2:0]hdmi_tx_n_o;
  output [2:0]hdmi_tx_p_o;
  output [3:0]led_o;
  input [3:0]switch_i;

  wire [3:0]btn_i;
  wire clk_i;
  wire hdmi_rx_clk_n_i;
  wire hdmi_rx_clk_p_i;
  wire hdmi_rx_ddc_scl_i;
  wire hdmi_rx_ddc_scl_io;
  wire hdmi_rx_ddc_scl_o;
  wire hdmi_rx_ddc_scl_t;
  wire hdmi_rx_ddc_sda_i;
  wire hdmi_rx_ddc_sda_io;
  wire hdmi_rx_ddc_sda_o;
  wire hdmi_rx_ddc_sda_t;
  wire hdmi_rx_hpd_o;
  wire [2:0]hdmi_rx_n_i;
  wire [2:0]hdmi_rx_p_i;
  wire hdmi_tx_clk_n_o;
  wire hdmi_tx_clk_p_o;
  wire [2:0]hdmi_tx_n_o;
  wire [2:0]hdmi_tx_p_o;
  wire [3:0]led_o;
  wire [3:0]switch_i;

  IOBUF hdmi_rx_ddc_scl_iobuf
       (.I(hdmi_rx_ddc_scl_o),
        .IO(hdmi_rx_ddc_scl_io),
        .O(hdmi_rx_ddc_scl_i),
        .T(hdmi_rx_ddc_scl_t));
  IOBUF hdmi_rx_ddc_sda_iobuf
       (.I(hdmi_rx_ddc_sda_o),
        .IO(hdmi_rx_ddc_sda_io),
        .O(hdmi_rx_ddc_sda_i),
        .T(hdmi_rx_ddc_sda_t));
  zybo_top zybo_top_i
       (.btn_i(btn_i),
        .clk_i(clk_i),
        .hdmi_rx_clk_n_i(hdmi_rx_clk_n_i),
        .hdmi_rx_clk_p_i(hdmi_rx_clk_p_i),
        .hdmi_rx_ddc_scl_i(hdmi_rx_ddc_scl_i),
        .hdmi_rx_ddc_scl_o(hdmi_rx_ddc_scl_o),
        .hdmi_rx_ddc_scl_t(hdmi_rx_ddc_scl_t),
        .hdmi_rx_ddc_sda_i(hdmi_rx_ddc_sda_i),
        .hdmi_rx_ddc_sda_o(hdmi_rx_ddc_sda_o),
        .hdmi_rx_ddc_sda_t(hdmi_rx_ddc_sda_t),
        .hdmi_rx_hpd_o(hdmi_rx_hpd_o),
        .hdmi_rx_n_i(hdmi_rx_n_i),
        .hdmi_rx_p_i(hdmi_rx_p_i),
        .hdmi_tx_clk_n_o(hdmi_tx_clk_n_o),
        .hdmi_tx_clk_p_o(hdmi_tx_clk_p_o),
        .hdmi_tx_n_o(hdmi_tx_n_o),
        .hdmi_tx_p_o(hdmi_tx_p_o),
        .led_o(led_o),
        .switch_i(switch_i));
endmodule
