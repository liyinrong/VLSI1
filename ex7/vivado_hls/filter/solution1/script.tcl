############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2017 Xilinx, Inc. All Rights Reserved.
############################################################
open_project filter
set_top filter_hls
add_files ../cpp/filter_hls.cpp
add_files ../cpp/filter_hls.h
add_files -tb ../cpp/filter_app.cpp
open_solution "solution1"
set_part {xc7z020clg400-1} -tool vivado
create_clock -period 8 -name default
#source "./filter/solution1/directives.tcl"
csim_design -compiler gcc
csynth_design
cosim_design
export_design -format ip_catalog
