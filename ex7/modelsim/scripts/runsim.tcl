quietly set LIB work
quietly set VOPT_ARG "+acc=mnap"

vsim -voptargs=$VOPT_ARG -pedanticerrors -lib $LIB rgb_proc_tb

add wave /clk
add wave /rst_n
add wave /stim
add wave /act_resp

add wave -r /dut/*

run -a
