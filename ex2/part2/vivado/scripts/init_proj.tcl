source scripts/check_vivado.tcl

source scripts/proj_config.tcl

# Create new project.
create_project $project_name . -part xc7z020clg400-1
set_property board_part digilentinc.com:zybo-z7-20:part0:1.0 [current_project]
set_property target_language Verilog [current_project]

# Add source and constraint files.
add_files -fileset sources_1 -norecurse [glob ../sourcecode/*.sv]
add_files -fileset sources_1 [glob ../sourcecode/surrounding_modules/*]
add_files -fileset constrs_1 -norecurse ./constraints/zybo-z7.xdc
add_files -fileset sim_1 [glob ../sourcecode/tb/*]
add_files -fileset sim_1 [glob ../simvectors/*]
update_compile_order -fileset sources_1

# Define synthesis and implementation strategies.
set_property strategy Flow_PerfOptimized_high [get_runs synth_1]
set_property STEPS.SYNTH_DESIGN.ARGS.RETIMING true [get_runs synth_1]
set_property strategy Performance_Retiming [get_runs impl_1]

# Add IP repository.
set_property ip_repo_paths ./ip_repo [current_project]
update_ip_catalog

source scripts/msg_config.tcl

# Create block design.
create_bd_design zybo_top

# Add ports. {{{
create_bd_port -dir I -type clk clk_i
set_property CONFIG.FREQ_HZ 125000000 [get_bd_ports {clk_i}]

create_bd_port -dir I -from 3 -to 0 switch_i

create_bd_port -dir O hdmi_rx_hpd_o
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 hdmi_rx_ddc
foreach suffix [list p n] {
    create_bd_port -dir I               hdmi_rx_clk_${suffix}_i
    create_bd_port -dir I -from 2 -to 0 hdmi_rx_${suffix}_i
}

foreach suffix [list p n] {
    create_bd_port -dir O               hdmi_tx_clk_${suffix}_o
    create_bd_port -dir O -from 2 -to 0 hdmi_tx_${suffix}_o
}
# }}}

# Define dual-clock FIFOs along with concatenation into and slicing out of them. {{{
proc gen_concat {scope nports {suffix ""}} {
    set path $scope/concat
    if {$suffix ne ""} {
        set path [format "%s_%s" $path $suffix]
    }
    create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 $path
    set_property -dict [list CONFIG.NUM_PORTS $nports] [get_bd_cells $path]
}
proc gen_dc_fifo {scope} {
    set path $scope/dc_fifo
    create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.1 $path
    startgroup
        set_property -dict [list \
                CONFIG.Fifo_Implementation          {Independent_Clocks_Builtin_FIFO} \
                CONFIG.INTERFACE_TYPE               {Native} \
                CONFIG.Reset_Type                   {Asynchronous_Reset} \
                CONFIG.Use_Dout_Reset               {false} \
                CONFIG.Input_Data_Width             {27} \
                CONFIG.Input_Depth                  {512} \
                CONFIG.Output_Data_Width            {27} \
                CONFIG.Output_Depth                 {512} \
                CONFIG.Data_Count_Width             {9} \
                CONFIG.Write_Data_Count_Width       {9} \
                CONFIG.Read_Data_Count_Width        {9} \
                CONFIG.Full_Threshold_Assert_Value  {502} \
                CONFIG.Full_Threshold_Negate_Value  {501} \
                CONFIG.Empty_Threshold_Assert_Value {5} \
                CONFIG.Empty_Threshold_Negate_Value {6} \
            ] [get_bd_cells $path]
        if {$scope eq "hdmi_rx"} {
            set_property -dict [list \
                    CONFIG.Read_Clock_Frequency     {150} \
                    CONFIG.Write_Clock_Frequency    {200} \
                CONFIG.Valid_Flag                   {true} \
            ] [get_bd_cells $path]
        } {
            set_property -dict [list \
                    CONFIG.Read_Clock_Frequency     {200} \
                    CONFIG.Write_Clock_Frequency    {150} \
            ] [get_bd_cells $path]
        }
    endgroup
    connect_bd_net [get_bd_pins $scope/concat/dout] [get_bd_pins $path/din]
}
proc gen_slices {scope} {
    foreach slice [list \
        [list vde 26 26] \
        [list hsync 25 25] \
        [list vsync 24 24] \
        [list r 23 16] \
        [list g 15 8] \
        [list b 7 0] \
    ] {
        set path [format "%s/slice_%s" $scope [lindex $slice 0]]
        set from [lindex $slice 1]
        set to [lindex $slice 2]
        set width [expr $from - $to + 1]
        create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 $path
        set_property -dict [list \
                CONFIG.DIN_WIDTH    {27} \
                CONFIG.DIN_FROM     $from \
                CONFIG.DIN_TO       $to \
                CONFIG.DOUT_WIDTH   $width \
            ] [get_bd_cells $path]
        connect_bd_net [get_bd_pins $scope/dc_fifo/dout] [get_bd_pins $path/Din]
    }
}
# }}}

# HDMI Rx {{{
create_bd_cell -type hier hdmi_rx

# Inputs
connect_bd_net [create_bd_pin -dir I hdmi_rx/clk_i] [get_bd_ports clk_i]
foreach suffix [list p n] {
    connect_bd_net [create_bd_pin -dir I -from 2 -to 0 hdmi_rx/hdmi_${suffix}_i] \
        [get_bd_ports hdmi_rx_${suffix}_i]
    connect_bd_net [create_bd_pin -dir I hdmi_rx/hdmi_clk_${suffix}_i] \
        [get_bd_ports hdmi_rx_clk_${suffix}_i]
}
connect_bd_intf_net \
    [create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 hdmi_rx/ddc] \
    [get_bd_intf_ports hdmi_rx_ddc]
create_bd_pin -dir I hdmi_rx/ready_i

# Clock Generator {{{
create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.4 hdmi_rx/clk_gen
# Configuration
set_property -dict [list \
        CONFIG.PRIMITIVE                    {PLL} \
        CONFIG.USE_RESET                    {false} \
        CONFIG.PRIM_IN_FREQ.VALUE_SRC       {USER} \
        CONFIG.PRIM_IN_FREQ                 {125} \
        CONFIG.FEEDBACK_SOURCE              {FDBK_AUTO} \
        CONFIG.CLKIN1_JITTER_PS             {80.0} \
        CONFIG.MMCM_DIVCLK_DIVIDE           {5} \
        CONFIG.MMCM_CLKFBOUT_MULT_F         {48} \
        CONFIG.MMCM_COMPENSATION            {ZHOLD} \
        CONFIG.NUM_OUT_CLKS                 {2} \
        CONFIG.MMCM_CLKIN1_PERIOD           {8.000} \
        CONFIG.CLKOUT1_REQUESTED_OUT_FREQ   {200.000} \
        CONFIG.CLKOUT1_DRIVES               {BUFG} \
        CONFIG.MMCM_CLKOUT0_DIVIDE_F        {6} \
        CONFIG.CLKOUT1_JITTER               {161.296} \
        CONFIG.CLKOUT1_PHASE_ERROR          {222.305} \
        CONFIG.CLKOUT2_USED                 {true} \
        CONFIG.MMCM_CLKIN2_PERIOD           {10.000} \
        CONFIG.CLKOUT2_REQUESTED_OUT_FREQ   {150.000} \
        CONFIG.MMCM_CLKOUT1_DIVIDE_F        {8} \
        CONFIG.CLKOUT2_JITTER               {168.006} \
        CONFIG.CLKOUT2_PHASE_ERROR          {222.305} \
    ] [get_bd_cells hdmi_rx/clk_gen]
# Clock input
connect_bd_net [get_bd_pins hdmi_rx/clk_gen/clk_in1] [get_bd_pins hdmi_rx/clk_i]
# }}}

# Reset Generator
create_bd_cell -type module -reference rst_gen_wrap hdmi_rx/rst_gen
connect_bd_net [get_bd_pins hdmi_rx/rst_gen/clk_i]  [get_bd_pins hdmi_rx/clk_gen/clk_out2]
connect_bd_net [get_bd_pins hdmi_rx/rst_gen/rst_ni] [get_bd_pins hdmi_rx/clk_gen/locked]

# DVI-to-RGB
create_bd_cell -type ip -vlnv digilentinc.com:ip:dvi2rgb:1.9 hdmi_rx/dvi2rgb
set_property -dict [list \
        CONFIG.kRstActiveHigh   {false} \
        CONFIG.kDebug           {false} \
        CONFIG.kClkRange        {1} \
        CONFIG.kEdidFileName    {dgl_1080p_cea.data} \
    ] [get_bd_cells hdmi_rx/dvi2rgb]
connect_bd_net [get_bd_pins hdmi_rx/dvi2rgb/RefClk] [get_bd_pins hdmi_rx/clk_gen/clk_out1]
connect_bd_net [get_bd_pins hdmi_rx/dvi2rgb/aRst_n] [get_bd_pins hdmi_rx/rst_gen/rst_no]
foreach suffix [list p n] {
    connect_bd_net [get_bd_pins hdmi_rx/dvi2rgb/TMDS_Data_${suffix}] \
        [get_bd_pins hdmi_rx/hdmi_${suffix}_i]
    connect_bd_net [get_bd_pins hdmi_rx/dvi2rgb/TMDS_Clk_${suffix}] \
        [get_bd_pins hdmi_rx/hdmi_clk_${suffix}_i]
}
connect_bd_intf_net [get_bd_intf_pins hdmi_rx/dvi2rgb/DDC] [get_bd_intf_pins hdmi_rx/ddc]

# Concatenation into FIFO
gen_concat "hdmi_rx" 4
connect_bd_net [get_bd_pins hdmi_rx/concat/In0] [get_bd_pins hdmi_rx/dvi2rgb/vid_pData]
connect_bd_net [get_bd_pins hdmi_rx/concat/In1] [get_bd_pins hdmi_rx/dvi2rgb/vid_pVSync]
connect_bd_net [get_bd_pins hdmi_rx/concat/In2] [get_bd_pins hdmi_rx/dvi2rgb/vid_pHSync]
connect_bd_net [get_bd_pins hdmi_rx/concat/In3] [get_bd_pins hdmi_rx/dvi2rgb/vid_pVDE]

# Dual-clock FIFO to separate HDMI Rx from processing
gen_dc_fifo "hdmi_rx"
connect_bd_net [get_bd_pins hdmi_rx/dc_fifo/rst]    [get_bd_pins hdmi_rx/rst_gen/rst_o]
connect_bd_net [get_bd_pins hdmi_rx/dc_fifo/wr_clk] [get_bd_pins hdmi_rx/dvi2rgb/PixelClk]
connect_bd_net [get_bd_pins hdmi_rx/dc_fifo/rd_clk] [get_bd_pins hdmi_rx/clk_gen/clk_out2]
connect_bd_net [get_bd_pins hdmi_rx/dc_fifo/wr_en]  [get_bd_pins hdmi_rx/dvi2rgb/aPixelClkLckd]
connect_bd_net [get_bd_pins hdmi_rx/dc_fifo/rd_en]  [get_bd_pins hdmi_rx/ready_i]

# Slices out of FIFO
gen_slices "hdmi_rx"

# Outputs
connect_bd_net [create_bd_pin -dir O hdmi_rx/proc_clk_o]    [get_bd_pins hdmi_rx/clk_gen/clk_out2]
connect_bd_net [create_bd_pin -dir O hdmi_rx/rst_o]         [get_bd_pins hdmi_rx/rst_gen/rst_o]
connect_bd_net [create_bd_pin -dir O hdmi_rx/rst_no]        [get_bd_pins hdmi_rx/rst_gen/rst_no]
connect_bd_net [create_bd_pin -dir O hdmi_rx/hdmi_clk_o]    [get_bd_pins hdmi_rx/dvi2rgb/PixelClk]
connect_bd_net [create_bd_pin -dir O hdmi_rx/hdmi_rst_no]   [get_bd_pins hdmi_rx/dvi2rgb/aPixelClkLckd]
connect_bd_net [create_bd_pin -dir O hdmi_rx/valid_o]       [get_bd_pins hdmi_rx/dc_fifo/valid]
foreach p [list r g b vsync hsync vde] {
    connect_bd_net [create_bd_pin -dir O hdmi_rx/${p}_o] [get_bd_pins hdmi_rx/slice_${p}/Dout]
}
connect_bd_net [get_bd_ports hdmi_rx_hpd_o] [get_bd_pins hdmi_rx/rst_no]
# }}}

# RGB Processing {{{
create_bd_cell -type module -reference rgb_proc_wrap rgb_proc
connect_bd_net [get_bd_pins rgb_proc/clk_i] [get_bd_pins hdmi_rx/proc_clk_o]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 slice_switch_3
set_property -dict [list \
        CONFIG.DIN_WIDTH    4 \
        CONFIG.DIN_FROM     3 \
        CONFIG.DIN_TO       3 \
        CONFIG.DOUT_WIDTH   1 \
    ] [get_bd_cells slice_switch_3]
connect_bd_net [get_bd_ports switch_i] [get_bd_pins slice_switch_3/Din]
connect_bd_net [get_bd_pins slice_switch_3/Dout] [get_bd_pins rgb_proc/enable_i]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 slice_switch_210
set_property -dict [list \
        CONFIG.DIN_WIDTH    4 \
        CONFIG.DIN_FROM     2 \
        CONFIG.DIN_TO       0 \
        CONFIG.DOUT_WIDTH   3 \
    ] [get_bd_cells slice_switch_210]
connect_bd_net [get_bd_ports switch_i] [get_bd_pins slice_switch_210/Din]
connect_bd_net [get_bd_pins slice_switch_210/Dout] [get_bd_pins rgb_proc/switch_i]
foreach p [list rst_n r_ g_ b_ vsync_ hsync_ vde_ valid_] {
    connect_bd_net [get_bd_pins rgb_proc/${p}i] [get_bd_pins hdmi_rx/${p}o]
}
connect_bd_net [get_bd_pins rgb_proc/ready_o] [get_bd_pins hdmi_rx/ready_i]
# }}}

# HDMI Tx {{{
create_bd_cell -type hier hdmi_tx
foreach sig [list rst_ proc_clk_ hdmi_clk_ hdmi_rst_n] {
    connect_bd_net [create_bd_pin -dir I hdmi_tx/${sig}i] [get_bd_pins hdmi_rx/${sig}o]
}
foreach p [list r g b vsync hsync vde valid] {
    connect_bd_net [create_bd_pin -dir I hdmi_tx/${p}_i] [get_bd_pins rgb_proc/${p}_o]
}

# Concatenation into FIFO
gen_concat "hdmi_tx" 6
connect_bd_net [get_bd_pins hdmi_tx/concat/In0] [get_bd_pins hdmi_tx/b_i]
connect_bd_net [get_bd_pins hdmi_tx/concat/In1] [get_bd_pins hdmi_tx/g_i]
connect_bd_net [get_bd_pins hdmi_tx/concat/In2] [get_bd_pins hdmi_tx/r_i]
connect_bd_net [get_bd_pins hdmi_tx/concat/In3] [get_bd_pins hdmi_tx/vsync_i]
connect_bd_net [get_bd_pins hdmi_tx/concat/In4] [get_bd_pins hdmi_tx/hsync_i]
connect_bd_net [get_bd_pins hdmi_tx/concat/In5] [get_bd_pins hdmi_tx/vde_i]

# Dual-clock FIFO to separate processing from HDMI Tx
gen_dc_fifo "hdmi_tx"
connect_bd_net [get_bd_pins hdmi_tx/dc_fifo/rst]    [get_bd_pins hdmi_tx/rst_i]
connect_bd_net [get_bd_pins hdmi_tx/dc_fifo/wr_clk] [get_bd_pins hdmi_tx/proc_clk_i]
connect_bd_net [get_bd_pins hdmi_tx/dc_fifo/rd_clk] [get_bd_pins hdmi_tx/hdmi_clk_i]
connect_bd_net [get_bd_pins hdmi_tx/dc_fifo/wr_en]  [get_bd_pins hdmi_tx/valid_i]
connect_bd_net [get_bd_pins hdmi_tx/dc_fifo/rd_en]  [get_bd_pins hdmi_tx/hdmi_rst_ni]

# Output Flag 'Valid'
create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 hdmi_tx/inv_fifo_full
set_property -dict [list \
        CONFIG.C_SIZE       {1} \
        CONFIG.C_OPERATION  {not} \
        CONFIG.LOGO_FILE    {data/sym_notgate.png} \
    ] [get_bd_cells hdmi_tx/inv_fifo_full]
connect_bd_net [get_bd_pins hdmi_tx/inv_fifo_full/Op1] [get_bd_pins hdmi_tx/dc_fifo/full]
connect_bd_net [create_bd_pin -dir O hdmi_tx/ready_o] [get_bd_pins hdmi_tx/inv_fifo_full/Res]

# Slices out of FIFO
gen_slices "hdmi_tx"

# Concatenation into RGB
gen_concat "hdmi_tx" 3 "rgb"
connect_bd_net [get_bd_pins hdmi_tx/concat_rgb/In0] [get_bd_pins hdmi_tx/slice_b/Dout]
connect_bd_net [get_bd_pins hdmi_tx/concat_rgb/In1] [get_bd_pins hdmi_tx/slice_g/Dout]
connect_bd_net [get_bd_pins hdmi_tx/concat_rgb/In2] [get_bd_pins hdmi_tx/slice_r/Dout]

# RGB-to-DVI
create_bd_cell -type ip -vlnv digilentinc.com:ip:rgb2dvi:1.4 hdmi_tx/rgb2dvi
set_property -dict [list \
        CONFIG.kRstActiveHigh   {false} \
        CONFIG.kClkPrimitive    {MMCM} \
    ] [get_bd_cells hdmi_tx/rgb2dvi]
connect_bd_net [get_bd_pins hdmi_tx/rgb2dvi/aRst_n]     [get_bd_pins hdmi_tx/hdmi_rst_ni]
connect_bd_net [get_bd_pins hdmi_tx/rgb2dvi/PixelClk]   [get_bd_pins hdmi_tx/hdmi_clk_i]
connect_bd_net [get_bd_pins hdmi_tx/rgb2dvi/vid_pData]  [get_bd_pins hdmi_tx/concat_rgb/dout]
connect_bd_net [get_bd_pins hdmi_tx/rgb2dvi/vid_pVSync] [get_bd_pins hdmi_tx/slice_vsync/Dout]
connect_bd_net [get_bd_pins hdmi_tx/rgb2dvi/vid_pHSync] [get_bd_pins hdmi_tx/slice_hsync/Dout]
connect_bd_net [get_bd_pins hdmi_tx/rgb2dvi/vid_pVDE]   [get_bd_pins hdmi_tx/slice_vde/Dout]

# Outputs
connect_bd_net [get_bd_pins hdmi_tx/ready_o] [get_bd_pins rgb_proc/ready_i]
foreach suffix [list n p] {
    set pin [create_bd_pin -dir O hdmi_tx/hdmi_clk_${suffix}_o]
    connect_bd_net $pin [get_bd_pins hdmi_tx/rgb2dvi/TMDS_Clk_${suffix}]
    connect_bd_net $pin [get_bd_ports hdmi_tx_clk_${suffix}_o]
    set pin [create_bd_pin -dir O -from 2 -to 0 hdmi_tx/hdmi_${suffix}_o]
    connect_bd_net $pin [get_bd_pins hdmi_tx/rgb2dvi/TMDS_Data_${suffix}]
    connect_bd_net $pin [get_bd_ports hdmi_tx_${suffix}_o]
}
# }}}

# Generate top-level wrapper.
source scripts/bd_config.tcl
make_wrapper -files [get_files ${bddir}/${topname}.bd] -top
add_files -norecurse $bddir/hdl/${topname}_wrapper.v
update_compile_order -fileset sources_1
set_property top zybo_top_wrapper [current_fileset]
update_compile_order -fileset sources_1

# Disable out-of-context synthesis to allow retiming of modules.
set_property synth_checkpoint_mode None [get_files ${bddir}/${topname}.bd]

# Testbench: Define top-level module and simulation time.
set_property top rgb_proc_tb [get_filesets sim_1]
set_property -name {xsim.simulate.runtime} -value {1ms} -objects [get_filesets sim_1]
