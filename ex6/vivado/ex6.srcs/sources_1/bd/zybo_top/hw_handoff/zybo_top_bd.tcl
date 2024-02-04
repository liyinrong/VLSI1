
################################################################
# This is a generated script based on design: zybo_top
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2017.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source zybo_top_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# rgb_proc_wrap, rst_gen_wrap

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg400-1
   set_property BOARD_PART digilentinc.com:zybo-z7-20:part0:1.0 [current_project]
}


# CHANGE DESIGN NAME HERE
set design_name zybo_top

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: hdmi_tx
proc create_hier_cell_hdmi_tx { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_hdmi_tx() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -from 7 -to 0 b_i
  create_bd_pin -dir O full
  create_bd_pin -dir I -from 7 -to 0 g_i
  create_bd_pin -dir I hdmi_clk_i
  create_bd_pin -dir O hdmi_clk_n_o
  create_bd_pin -dir O hdmi_clk_p_o
  create_bd_pin -dir O -from 2 -to 0 hdmi_n_o
  create_bd_pin -dir O -from 2 -to 0 hdmi_p_o
  create_bd_pin -dir I hdmi_rst_ni
  create_bd_pin -dir I hsync_i
  create_bd_pin -dir I proc_clk_i
  create_bd_pin -dir I -from 7 -to 0 r_i
  create_bd_pin -dir O -from 0 -to 0 ready_o
  create_bd_pin -dir I rst_i
  create_bd_pin -dir I valid_i
  create_bd_pin -dir I vde_i
  create_bd_pin -dir I vsync_i

  # Create instance: concat, and set properties
  set concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat ]
  set_property -dict [ list \
CONFIG.IN0_WIDTH {8} \
CONFIG.IN1_WIDTH {8} \
CONFIG.IN2_WIDTH {8} \
CONFIG.NUM_PORTS {6} \
 ] $concat

  # Create instance: concat_rgb, and set properties
  set concat_rgb [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_rgb ]
  set_property -dict [ list \
CONFIG.IN0_WIDTH {8} \
CONFIG.IN1_WIDTH {8} \
CONFIG.IN2_WIDTH {8} \
CONFIG.NUM_PORTS {3} \
 ] $concat_rgb

  # Create instance: not_full, and set properties
  set not_full [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 not_full ]
  set_property -dict [ list \
CONFIG.C_OPERATION {not} \
CONFIG.C_SIZE {1} \
CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $not_full

  # Create instance: rgb2dvi, and set properties
  set rgb2dvi [ create_bd_cell -type ip -vlnv digilentinc.com:ip:rgb2dvi:1.4 rgb2dvi ]
  set_property -dict [ list \
CONFIG.kClkPrimitive {MMCM} \
CONFIG.kRstActiveHigh {false} \
 ] $rgb2dvi

  # Create instance: slice_b, and set properties
  set slice_b [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 slice_b ]
  set_property -dict [ list \
CONFIG.DIN_FROM {7} \
CONFIG.DIN_TO {0} \
CONFIG.DIN_WIDTH {27} \
CONFIG.DOUT_WIDTH {8} \
 ] $slice_b

  # Create instance: slice_g, and set properties
  set slice_g [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 slice_g ]
  set_property -dict [ list \
CONFIG.DIN_FROM {15} \
CONFIG.DIN_TO {8} \
CONFIG.DIN_WIDTH {27} \
CONFIG.DOUT_WIDTH {8} \
 ] $slice_g

  # Create instance: slice_hsync, and set properties
  set slice_hsync [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 slice_hsync ]
  set_property -dict [ list \
CONFIG.DIN_FROM {25} \
CONFIG.DIN_TO {25} \
CONFIG.DIN_WIDTH {27} \
CONFIG.DOUT_WIDTH {1} \
 ] $slice_hsync

  # Create instance: slice_r, and set properties
  set slice_r [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 slice_r ]
  set_property -dict [ list \
CONFIG.DIN_FROM {23} \
CONFIG.DIN_TO {16} \
CONFIG.DIN_WIDTH {27} \
CONFIG.DOUT_WIDTH {8} \
 ] $slice_r

  # Create instance: slice_vde, and set properties
  set slice_vde [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 slice_vde ]
  set_property -dict [ list \
CONFIG.DIN_FROM {26} \
CONFIG.DIN_TO {26} \
CONFIG.DIN_WIDTH {27} \
CONFIG.DOUT_WIDTH {1} \
 ] $slice_vde

  # Create instance: slice_vsync, and set properties
  set slice_vsync [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 slice_vsync ]
  set_property -dict [ list \
CONFIG.DIN_FROM {24} \
CONFIG.DIN_TO {24} \
CONFIG.DIN_WIDTH {27} \
CONFIG.DOUT_WIDTH {1} \
 ] $slice_vsync

  # Create instance: tx_dc_fifo, and set properties
  set tx_dc_fifo [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.1 tx_dc_fifo ]
  set_property -dict [ list \
CONFIG.Data_Count_Width {9} \
CONFIG.Empty_Threshold_Assert_Value {5} \
CONFIG.Empty_Threshold_Negate_Value {6} \
CONFIG.Fifo_Implementation {Independent_Clocks_Builtin_FIFO} \
CONFIG.Full_Threshold_Assert_Value {500} \
CONFIG.Full_Threshold_Negate_Value {499} \
CONFIG.Input_Data_Width {27} \
CONFIG.Input_Depth {512} \
CONFIG.Output_Data_Width {27} \
CONFIG.Output_Depth {512} \
CONFIG.Read_Clock_Frequency {100} \
CONFIG.Read_Data_Count_Width {9} \
CONFIG.Reset_Type {Asynchronous_Reset} \
CONFIG.Use_Dout_Reset {false} \
CONFIG.Write_Clock_Frequency {150} \
CONFIG.Write_Data_Count_Width {9} \
 ] $tx_dc_fifo

  # Create port connections
  connect_bd_net -net b_i_1 [get_bd_pins b_i] [get_bd_pins concat/In0]
  connect_bd_net -net concat_dout [get_bd_pins concat/dout] [get_bd_pins tx_dc_fifo/din]
  connect_bd_net -net concat_rgb_dout [get_bd_pins concat_rgb/dout] [get_bd_pins rgb2dvi/vid_pData]
  connect_bd_net -net g_i_1 [get_bd_pins g_i] [get_bd_pins concat/In1]
  connect_bd_net -net hdmi_clk_i_1 [get_bd_pins hdmi_clk_i] [get_bd_pins rgb2dvi/PixelClk] [get_bd_pins tx_dc_fifo/rd_clk]
  connect_bd_net -net hdmi_rst_ni_1 [get_bd_pins hdmi_rst_ni] [get_bd_pins rgb2dvi/aRst_n] [get_bd_pins tx_dc_fifo/rd_en]
  connect_bd_net -net hsync_i_1 [get_bd_pins hsync_i] [get_bd_pins concat/In4]
  connect_bd_net -net not_full_Res [get_bd_pins ready_o] [get_bd_pins not_full/Res]
  connect_bd_net -net proc_clk_i_1 [get_bd_pins proc_clk_i] [get_bd_pins tx_dc_fifo/wr_clk]
  connect_bd_net -net r_i_1 [get_bd_pins r_i] [get_bd_pins concat/In2]
  connect_bd_net -net rgb2dvi_TMDS_Clk_n [get_bd_pins hdmi_clk_n_o] [get_bd_pins rgb2dvi/TMDS_Clk_n]
  connect_bd_net -net rgb2dvi_TMDS_Clk_p [get_bd_pins hdmi_clk_p_o] [get_bd_pins rgb2dvi/TMDS_Clk_p]
  connect_bd_net -net rgb2dvi_TMDS_Data_n [get_bd_pins hdmi_n_o] [get_bd_pins rgb2dvi/TMDS_Data_n]
  connect_bd_net -net rgb2dvi_TMDS_Data_p [get_bd_pins hdmi_p_o] [get_bd_pins rgb2dvi/TMDS_Data_p]
  connect_bd_net -net rst_i_1 [get_bd_pins rst_i] [get_bd_pins tx_dc_fifo/rst]
  connect_bd_net -net slice_b_Dout [get_bd_pins concat_rgb/In0] [get_bd_pins slice_b/Dout]
  connect_bd_net -net slice_g_Dout [get_bd_pins concat_rgb/In1] [get_bd_pins slice_g/Dout]
  connect_bd_net -net slice_hsync_Dout [get_bd_pins rgb2dvi/vid_pHSync] [get_bd_pins slice_hsync/Dout]
  connect_bd_net -net slice_r_Dout [get_bd_pins concat_rgb/In2] [get_bd_pins slice_r/Dout]
  connect_bd_net -net slice_vde_Dout [get_bd_pins rgb2dvi/vid_pVDE] [get_bd_pins slice_vde/Dout]
  connect_bd_net -net slice_vsync_Dout [get_bd_pins rgb2dvi/vid_pVSync] [get_bd_pins slice_vsync/Dout]
  connect_bd_net -net tx_dc_fifo_dout [get_bd_pins slice_b/Din] [get_bd_pins slice_g/Din] [get_bd_pins slice_hsync/Din] [get_bd_pins slice_r/Din] [get_bd_pins slice_vde/Din] [get_bd_pins slice_vsync/Din] [get_bd_pins tx_dc_fifo/dout]
  connect_bd_net -net tx_dc_fifo_full [get_bd_pins full] [get_bd_pins not_full/Op1] [get_bd_pins tx_dc_fifo/full]
  connect_bd_net -net valid_i_1 [get_bd_pins valid_i] [get_bd_pins tx_dc_fifo/wr_en]
  connect_bd_net -net vde_i_1 [get_bd_pins vde_i] [get_bd_pins concat/In5]
  connect_bd_net -net vsync_i_1 [get_bd_pins vsync_i] [get_bd_pins concat/In3]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hdmi_rx
proc create_hier_cell_hdmi_rx { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_hdmi_rx() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 ddc

  # Create pins
  create_bd_pin -dir O -from 7 -to 0 b_o
  create_bd_pin -dir I clk_i
  create_bd_pin -dir O full
  create_bd_pin -dir O -from 7 -to 0 g_o
  create_bd_pin -dir I hdmi_clk_n_i
  create_bd_pin -dir O hdmi_clk_o
  create_bd_pin -dir I hdmi_clk_p_i
  create_bd_pin -dir I -from 2 -to 0 hdmi_n_i
  create_bd_pin -dir I -from 2 -to 0 hdmi_p_i
  create_bd_pin -dir O hdmi_rst_no
  create_bd_pin -dir O -from 0 -to 0 hsync_o
  create_bd_pin -dir O proc_clk_o
  create_bd_pin -dir O -from 7 -to 0 r_o
  create_bd_pin -dir I ready_i
  create_bd_pin -dir O rst_no
  create_bd_pin -dir O rst_o
  create_bd_pin -dir O -from 0 -to 0 valid_o
  create_bd_pin -dir O -from 0 -to 0 vde_o
  create_bd_pin -dir O -from 0 -to 0 vsync_o

  # Create instance: clk_gen, and set properties
  set clk_gen [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.4 clk_gen ]
  set_property -dict [ list \
CONFIG.CLKIN1_JITTER_PS {80.0} \
CONFIG.CLKOUT1_DRIVES {BUFG} \
CONFIG.CLKOUT1_JITTER {161.296} \
CONFIG.CLKOUT1_PHASE_ERROR {222.305} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200.000} \
CONFIG.CLKOUT2_JITTER {168.006} \
CONFIG.CLKOUT2_PHASE_ERROR {222.305} \
CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {150.000} \
CONFIG.CLKOUT2_USED {true} \
CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
CONFIG.MMCM_CLKFBOUT_MULT_F {48} \
CONFIG.MMCM_CLKIN1_PERIOD {8.000} \
CONFIG.MMCM_CLKIN2_PERIOD {10.000} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {6} \
CONFIG.MMCM_COMPENSATION {ZHOLD} \
CONFIG.MMCM_DIVCLK_DIVIDE {5} \
CONFIG.NUM_OUT_CLKS {2} \
CONFIG.PRIMITIVE {PLL} \
CONFIG.PRIM_IN_FREQ {125} \
CONFIG.USE_RESET {false} \
 ] $clk_gen

  # Create instance: concat_rgb, and set properties
  set concat_rgb [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_rgb ]
  set_property -dict [ list \
CONFIG.IN0_WIDTH {24} \
CONFIG.NUM_PORTS {4} \
 ] $concat_rgb

  # Create instance: dvi2rgb, and set properties
  set dvi2rgb [ create_bd_cell -type ip -vlnv digilentinc.com:ip:dvi2rgb:1.9 dvi2rgb ]
  set_property -dict [ list \
CONFIG.kClkRange {1} \
CONFIG.kEdidFileName {dgl_1080p_cea.data} \
CONFIG.kRstActiveHigh {false} \
 ] $dvi2rgb

  # Create instance: not_empty, and set properties
  set not_empty [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 not_empty ]
  set_property -dict [ list \
CONFIG.C_OPERATION {not} \
CONFIG.C_SIZE {1} \
CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $not_empty

  # Create instance: rst_gen, and set properties
  set block_name rst_gen_wrap
  set block_cell_name rst_gen
  if { [catch {set rst_gen [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $rst_gen eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: rx_dc_fifo, and set properties
  set rx_dc_fifo [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.1 rx_dc_fifo ]
  set_property -dict [ list \
CONFIG.Data_Count_Width {9} \
CONFIG.Empty_Threshold_Assert_Value {5} \
CONFIG.Empty_Threshold_Negate_Value {6} \
CONFIG.Fifo_Implementation {Independent_Clocks_Builtin_FIFO} \
CONFIG.Full_Threshold_Assert_Value {503} \
CONFIG.Full_Threshold_Negate_Value {502} \
CONFIG.Input_Data_Width {27} \
CONFIG.Input_Depth {512} \
CONFIG.Output_Data_Width {27} \
CONFIG.Output_Depth {512} \
CONFIG.Read_Clock_Frequency {150} \
CONFIG.Read_Data_Count_Width {9} \
CONFIG.Reset_Type {Asynchronous_Reset} \
CONFIG.Use_Dout_Reset {false} \
CONFIG.Write_Clock_Frequency {100} \
CONFIG.Write_Data_Count_Width {9} \
 ] $rx_dc_fifo

  # Create instance: slice_b, and set properties
  set slice_b [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 slice_b ]
  set_property -dict [ list \
CONFIG.DIN_FROM {7} \
CONFIG.DIN_TO {0} \
CONFIG.DIN_WIDTH {27} \
CONFIG.DOUT_WIDTH {8} \
 ] $slice_b

  # Create instance: slice_g, and set properties
  set slice_g [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 slice_g ]
  set_property -dict [ list \
CONFIG.DIN_FROM {15} \
CONFIG.DIN_TO {8} \
CONFIG.DIN_WIDTH {27} \
CONFIG.DOUT_WIDTH {8} \
 ] $slice_g

  # Create instance: slice_hsync, and set properties
  set slice_hsync [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 slice_hsync ]
  set_property -dict [ list \
CONFIG.DIN_FROM {25} \
CONFIG.DIN_TO {25} \
CONFIG.DIN_WIDTH {27} \
CONFIG.DOUT_WIDTH {1} \
 ] $slice_hsync

  # Create instance: slice_r, and set properties
  set slice_r [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 slice_r ]
  set_property -dict [ list \
CONFIG.DIN_FROM {23} \
CONFIG.DIN_TO {16} \
CONFIG.DIN_WIDTH {27} \
CONFIG.DOUT_WIDTH {8} \
 ] $slice_r

  # Create instance: slice_vde, and set properties
  set slice_vde [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 slice_vde ]
  set_property -dict [ list \
CONFIG.DIN_FROM {26} \
CONFIG.DIN_TO {26} \
CONFIG.DIN_WIDTH {27} \
CONFIG.DOUT_WIDTH {1} \
 ] $slice_vde

  # Create instance: slice_vsync, and set properties
  set slice_vsync [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 slice_vsync ]
  set_property -dict [ list \
CONFIG.DIN_FROM {24} \
CONFIG.DIN_TO {24} \
CONFIG.DIN_WIDTH {27} \
CONFIG.DOUT_WIDTH {1} \
 ] $slice_vsync

  # Create interface connections
  connect_bd_intf_net -intf_net dvi2rgb_DDC [get_bd_intf_pins ddc] [get_bd_intf_pins dvi2rgb/DDC]

  # Create port connections
  connect_bd_net -net b_slice_Dout [get_bd_pins b_o] [get_bd_pins slice_b/Dout]
  connect_bd_net -net clk_gen_clk_out1 [get_bd_pins clk_gen/clk_out1] [get_bd_pins dvi2rgb/RefClk]
  connect_bd_net -net clk_gen_clk_out2 [get_bd_pins proc_clk_o] [get_bd_pins clk_gen/clk_out2] [get_bd_pins rst_gen/clk_i] [get_bd_pins rx_dc_fifo/rd_clk]
  connect_bd_net -net clk_gen_locked [get_bd_pins clk_gen/locked] [get_bd_pins rst_gen/rst_ni]
  connect_bd_net -net clk_i_1 [get_bd_pins clk_i] [get_bd_pins clk_gen/clk_in1]
  connect_bd_net -net concat_rgb_dout [get_bd_pins concat_rgb/dout] [get_bd_pins rx_dc_fifo/din]
  connect_bd_net -net dvi2rgb_PixelClk [get_bd_pins hdmi_clk_o] [get_bd_pins dvi2rgb/PixelClk] [get_bd_pins rx_dc_fifo/wr_clk]
  connect_bd_net -net dvi2rgb_aPixelClkLckd [get_bd_pins hdmi_rst_no] [get_bd_pins dvi2rgb/aPixelClkLckd] [get_bd_pins rx_dc_fifo/wr_en]
  connect_bd_net -net dvi2rgb_vid_pData [get_bd_pins concat_rgb/In0] [get_bd_pins dvi2rgb/vid_pData]
  connect_bd_net -net dvi2rgb_vid_pHSync [get_bd_pins concat_rgb/In2] [get_bd_pins dvi2rgb/vid_pHSync]
  connect_bd_net -net dvi2rgb_vid_pVDE [get_bd_pins concat_rgb/In3] [get_bd_pins dvi2rgb/vid_pVDE]
  connect_bd_net -net dvi2rgb_vid_pVSync [get_bd_pins concat_rgb/In1] [get_bd_pins dvi2rgb/vid_pVSync]
  connect_bd_net -net g_slice_Dout [get_bd_pins g_o] [get_bd_pins slice_g/Dout]
  connect_bd_net -net hdmi_clk_n_i_1 [get_bd_pins hdmi_clk_n_i] [get_bd_pins dvi2rgb/TMDS_Clk_n]
  connect_bd_net -net hdmi_clk_p_i_1 [get_bd_pins hdmi_clk_p_i] [get_bd_pins dvi2rgb/TMDS_Clk_p]
  connect_bd_net -net hdmi_n_i_1 [get_bd_pins hdmi_n_i] [get_bd_pins dvi2rgb/TMDS_Data_n]
  connect_bd_net -net hdmi_p_i_1 [get_bd_pins hdmi_p_i] [get_bd_pins dvi2rgb/TMDS_Data_p]
  connect_bd_net -net hsync_slice_Dout [get_bd_pins hsync_o] [get_bd_pins slice_hsync/Dout]
  connect_bd_net -net not_empty_Res [get_bd_pins valid_o] [get_bd_pins not_empty/Res]
  connect_bd_net -net r_slice_Dout [get_bd_pins r_o] [get_bd_pins slice_r/Dout]
  connect_bd_net -net ready_i_1 [get_bd_pins ready_i] [get_bd_pins rx_dc_fifo/rd_en]
  connect_bd_net -net rst_gen_rst_no [get_bd_pins rst_no] [get_bd_pins dvi2rgb/aRst_n] [get_bd_pins rst_gen/rst_no]
  connect_bd_net -net rst_gen_rst_o [get_bd_pins rst_o] [get_bd_pins rst_gen/rst_o] [get_bd_pins rx_dc_fifo/rst]
  connect_bd_net -net rx_dc_fifo_dout [get_bd_pins rx_dc_fifo/dout] [get_bd_pins slice_b/Din] [get_bd_pins slice_g/Din] [get_bd_pins slice_hsync/Din] [get_bd_pins slice_r/Din] [get_bd_pins slice_vde/Din] [get_bd_pins slice_vsync/Din]
  connect_bd_net -net rx_dc_fifo_empty [get_bd_pins not_empty/Op1] [get_bd_pins rx_dc_fifo/empty]
  connect_bd_net -net rx_dc_fifo_full [get_bd_pins full] [get_bd_pins rx_dc_fifo/full]
  connect_bd_net -net vde_slice_Dout [get_bd_pins vde_o] [get_bd_pins slice_vde/Dout]
  connect_bd_net -net vsync_slice_Dout [get_bd_pins vsync_o] [get_bd_pins slice_vsync/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set hdmi_rx_ddc [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 hdmi_rx_ddc ]

  # Create ports
  set btn_i [ create_bd_port -dir I -from 3 -to 0 btn_i ]
  set clk_i [ create_bd_port -dir I -type clk clk_i ]
  set_property -dict [ list \
CONFIG.FREQ_HZ {125000000} \
 ] $clk_i
  set hdmi_rx_clk_n_i [ create_bd_port -dir I hdmi_rx_clk_n_i ]
  set hdmi_rx_clk_p_i [ create_bd_port -dir I hdmi_rx_clk_p_i ]
  set hdmi_rx_hpd_o [ create_bd_port -dir O hdmi_rx_hpd_o ]
  set hdmi_rx_n_i [ create_bd_port -dir I -from 2 -to 0 hdmi_rx_n_i ]
  set hdmi_rx_p_i [ create_bd_port -dir I -from 2 -to 0 hdmi_rx_p_i ]
  set hdmi_tx_clk_n_o [ create_bd_port -dir O hdmi_tx_clk_n_o ]
  set hdmi_tx_clk_p_o [ create_bd_port -dir O hdmi_tx_clk_p_o ]
  set hdmi_tx_n_o [ create_bd_port -dir O -from 2 -to 0 hdmi_tx_n_o ]
  set hdmi_tx_p_o [ create_bd_port -dir O -from 2 -to 0 hdmi_tx_p_o ]
  set led_o [ create_bd_port -dir O -from 3 -to 0 led_o ]
  set switch_i [ create_bd_port -dir I -from 3 -to 0 switch_i ]

  # Create instance: concat_led, and set properties
  set concat_led [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_led ]
  set_property -dict [ list \
CONFIG.IN1_WIDTH {2} \
CONFIG.NUM_PORTS {3} \
 ] $concat_led

  # Create instance: constant_0, and set properties
  set constant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 constant_0 ]
  set_property -dict [ list \
CONFIG.CONST_VAL {0} \
CONFIG.CONST_WIDTH {2} \
 ] $constant_0

  # Create instance: hdmi_rx
  create_hier_cell_hdmi_rx [current_bd_instance .] hdmi_rx

  # Create instance: hdmi_tx
  create_hier_cell_hdmi_tx [current_bd_instance .] hdmi_tx

  # Create instance: rgb_proc_wrap_0, and set properties
  set block_name rgb_proc_wrap
  set block_cell_name rgb_proc_wrap_0
  if { [catch {set rgb_proc_wrap_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $rgb_proc_wrap_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: slice_enable, and set properties
  set slice_enable [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 slice_enable ]
  set_property -dict [ list \
CONFIG.DIN_FROM {3} \
CONFIG.DIN_TO {3} \
CONFIG.DIN_WIDTH {4} \
CONFIG.DOUT_WIDTH {1} \
 ] $slice_enable

  # Create instance: slice_switch, and set properties
  set slice_switch [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 slice_switch ]
  set_property -dict [ list \
CONFIG.DIN_FROM {2} \
CONFIG.DIN_TO {0} \
CONFIG.DIN_WIDTH {4} \
CONFIG.DOUT_WIDTH {3} \
 ] $slice_switch

  # Create interface connections
  connect_bd_intf_net -intf_net hdmi_rx_ddc1 [get_bd_intf_ports hdmi_rx_ddc] [get_bd_intf_pins hdmi_rx/ddc]

  # Create port connections
  connect_bd_net -net b_i_1 [get_bd_pins hdmi_tx/b_i] [get_bd_pins rgb_proc_wrap_0/b_o]
  connect_bd_net -net clk_i_1 [get_bd_ports clk_i] [get_bd_pins hdmi_rx/clk_i]
  connect_bd_net -net concat_led_dout [get_bd_ports led_o] [get_bd_pins concat_led/dout]
  connect_bd_net -net hdmi_clk_i_1 [get_bd_pins hdmi_rx/hdmi_clk_o] [get_bd_pins hdmi_tx/hdmi_clk_i]
  connect_bd_net -net hdmi_rst_ni_1 [get_bd_pins hdmi_rx/hdmi_rst_no] [get_bd_pins hdmi_tx/hdmi_rst_ni]
  connect_bd_net -net hdmi_rx_b_o [get_bd_pins hdmi_rx/b_o] [get_bd_pins rgb_proc_wrap_0/b_i]
  connect_bd_net -net hdmi_rx_clk_n_i_1 [get_bd_ports hdmi_rx_clk_n_i] [get_bd_pins hdmi_rx/hdmi_clk_n_i]
  connect_bd_net -net hdmi_rx_clk_p_i_1 [get_bd_ports hdmi_rx_clk_p_i] [get_bd_pins hdmi_rx/hdmi_clk_p_i]
  connect_bd_net -net hdmi_rx_full [get_bd_pins concat_led/In2] [get_bd_pins hdmi_rx/full]
  connect_bd_net -net hdmi_rx_g_o [get_bd_pins hdmi_rx/g_o] [get_bd_pins rgb_proc_wrap_0/g_i]
  connect_bd_net -net hdmi_rx_hsync_o [get_bd_pins hdmi_rx/hsync_o] [get_bd_pins rgb_proc_wrap_0/hsync_i]
  connect_bd_net -net hdmi_rx_n_i_1 [get_bd_ports hdmi_rx_n_i] [get_bd_pins hdmi_rx/hdmi_n_i]
  connect_bd_net -net hdmi_rx_p_i_1 [get_bd_ports hdmi_rx_p_i] [get_bd_pins hdmi_rx/hdmi_p_i]
  connect_bd_net -net hdmi_rx_r_o [get_bd_pins hdmi_rx/r_o] [get_bd_pins rgb_proc_wrap_0/r_i]
  connect_bd_net -net hdmi_rx_rst_no [get_bd_ports hdmi_rx_hpd_o] [get_bd_pins hdmi_rx/rst_no] [get_bd_pins rgb_proc_wrap_0/rst_ni]
  connect_bd_net -net hdmi_rx_rst_o [get_bd_pins hdmi_rx/rst_o] [get_bd_pins hdmi_tx/rst_i]
  connect_bd_net -net hdmi_rx_valid_o [get_bd_pins hdmi_rx/valid_o] [get_bd_pins rgb_proc_wrap_0/valid_i]
  connect_bd_net -net hdmi_rx_vde_o [get_bd_pins hdmi_rx/vde_o] [get_bd_pins rgb_proc_wrap_0/vde_i]
  connect_bd_net -net hdmi_rx_vsync_o [get_bd_pins hdmi_rx/vsync_o] [get_bd_pins rgb_proc_wrap_0/vsync_i]
  connect_bd_net -net hdmi_tx_full [get_bd_pins concat_led/In0] [get_bd_pins hdmi_tx/full]
  connect_bd_net -net hdmi_tx_hdmi_clk_n_o [get_bd_ports hdmi_tx_clk_n_o] [get_bd_pins hdmi_tx/hdmi_clk_n_o]
  connect_bd_net -net hdmi_tx_hdmi_clk_p_o [get_bd_ports hdmi_tx_clk_p_o] [get_bd_pins hdmi_tx/hdmi_clk_p_o]
  connect_bd_net -net hdmi_tx_hdmi_n_o [get_bd_ports hdmi_tx_n_o] [get_bd_pins hdmi_tx/hdmi_n_o]
  connect_bd_net -net hdmi_tx_hdmi_p_o [get_bd_ports hdmi_tx_p_o] [get_bd_pins hdmi_tx/hdmi_p_o]
  connect_bd_net -net hdmi_tx_ready_o [get_bd_pins hdmi_tx/ready_o] [get_bd_pins rgb_proc_wrap_0/ready_i]
  connect_bd_net -net proc_clk_i_1 [get_bd_pins hdmi_rx/proc_clk_o] [get_bd_pins hdmi_tx/proc_clk_i] [get_bd_pins rgb_proc_wrap_0/clk_i]
  connect_bd_net -net r_i_1 [get_bd_pins hdmi_tx/r_i] [get_bd_pins rgb_proc_wrap_0/r_o]
  connect_bd_net -net rgb_proc_wrap_0_g_o [get_bd_pins hdmi_tx/g_i] [get_bd_pins rgb_proc_wrap_0/g_o]
  connect_bd_net -net rgb_proc_wrap_0_hsync_o [get_bd_pins hdmi_tx/hsync_i] [get_bd_pins rgb_proc_wrap_0/hsync_o]
  connect_bd_net -net rgb_proc_wrap_0_ready_o [get_bd_pins hdmi_rx/ready_i] [get_bd_pins rgb_proc_wrap_0/ready_o]
  connect_bd_net -net rgb_proc_wrap_0_vde_o [get_bd_pins hdmi_tx/vde_i] [get_bd_pins rgb_proc_wrap_0/vde_o]
  connect_bd_net -net slice_enable_Dout [get_bd_pins rgb_proc_wrap_0/enable_i] [get_bd_pins slice_enable/Dout]
  connect_bd_net -net slice_switch_Dout [get_bd_pins rgb_proc_wrap_0/switch_i] [get_bd_pins slice_switch/Dout]
  connect_bd_net -net switch_i_1 [get_bd_ports switch_i] [get_bd_pins slice_enable/Din] [get_bd_pins slice_switch/Din]
  connect_bd_net -net valid_i_1 [get_bd_pins hdmi_tx/valid_i] [get_bd_pins rgb_proc_wrap_0/valid_o]
  connect_bd_net -net vsync_i_1 [get_bd_pins hdmi_tx/vsync_i] [get_bd_pins rgb_proc_wrap_0/vsync_o]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins concat_led/In1] [get_bd_pins constant_0/dout]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


