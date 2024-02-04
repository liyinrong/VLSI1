#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/usr/pack/vivado-2017.2-kgf/SDK/2017.2/bin:/usr/pack/vivado-2017.2-kgf/Vivado/2017.2/ids_lite/ISE/bin/lin64:/usr/pack/vivado-2017.2-kgf/Vivado/2017.2/bin
else
  PATH=/usr/pack/vivado-2017.2-kgf/SDK/2017.2/bin:/usr/pack/vivado-2017.2-kgf/Vivado/2017.2/ids_lite/ISE/bin/lin64:/usr/pack/vivado-2017.2-kgf/Vivado/2017.2/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=/usr/pack/vivado-2017.2-kgf/Vivado/2017.2/ids_lite/ISE/lib/lin64
else
  LD_LIBRARY_PATH=/usr/pack/vivado-2017.2-kgf/Vivado/2017.2/ids_lite/ISE/lib/lin64:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/home/vlsi1_010hs23/ex6/vivado/ex6.runs/synth_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

EAStep vivado -log zybo_top_wrapper.vds -m64 -product Vivado -mode batch -messageDb vivado.pb -notrace -source zybo_top_wrapper.tcl
