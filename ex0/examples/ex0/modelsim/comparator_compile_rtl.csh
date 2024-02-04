#! /bin/tcsh -f

# script for compile the RTL sourcecode of the comparator


set VER=10.3a
set LIB=work


if (-e ${LIB}) then
  rm -rf ${LIB}
endif

vlib-${VER} ${LIB}

# sourcecode
vcom-${VER}  -work ${LIB} -check_synthesis ../sourcecode/comparator.vhd

# testbench
vcom-${VER}  -work ${LIB} ../sourcecode/comparator_tb.vhd

# batch (shell)
#echo vsim-${VER} -lib ${LIB} -c  -do ./run_all.tcl comparator_tb

# GUI
echo "###"
echo "### Start simulation using:"
echo "###"
echo "###    vsim-10.3a -voptargs='+acc' -lib work comparator_tb &"
echo "###"
