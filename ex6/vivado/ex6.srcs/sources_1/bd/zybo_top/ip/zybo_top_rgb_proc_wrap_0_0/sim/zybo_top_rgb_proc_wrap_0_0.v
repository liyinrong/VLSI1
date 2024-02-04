// (c) Copyright 1995-2024 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: user.org:module_ref:rgb_proc_wrap:1.0
// IP Revision: 1

`timescale 1ns/1ps

(* DowngradeIPIdentifiedWarnings = "yes" *)
module zybo_top_rgb_proc_wrap_0_0 (
  clk_i,
  rst_ni,
  enable_i,
  switch_i,
  r_i,
  g_i,
  b_i,
  hsync_i,
  vsync_i,
  vde_i,
  valid_i,
  ready_o,
  r_o,
  g_o,
  b_o,
  hsync_o,
  vsync_o,
  vde_o,
  valid_o,
  ready_i
);

input wire clk_i;
input wire rst_ni;
input wire enable_i;
input wire [2 : 0] switch_i;
input wire [7 : 0] r_i;
input wire [7 : 0] g_i;
input wire [7 : 0] b_i;
input wire hsync_i;
input wire vsync_i;
input wire vde_i;
input wire valid_i;
output wire ready_o;
output wire [7 : 0] r_o;
output wire [7 : 0] g_o;
output wire [7 : 0] b_o;
output wire hsync_o;
output wire vsync_o;
output wire vde_o;
output wire valid_o;
input wire ready_i;

  rgb_proc_wrap inst (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .enable_i(enable_i),
    .switch_i(switch_i),
    .r_i(r_i),
    .g_i(g_i),
    .b_i(b_i),
    .hsync_i(hsync_i),
    .vsync_i(vsync_i),
    .vde_i(vde_i),
    .valid_i(valid_i),
    .ready_o(ready_o),
    .r_o(r_o),
    .g_o(g_o),
    .b_o(b_o),
    .hsync_o(hsync_o),
    .vsync_o(vsync_o),
    .vde_o(vde_o),
    .valid_o(valid_o),
    .ready_i(ready_i)
  );
endmodule
