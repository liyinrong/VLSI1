set DEBUG ON

if {$DEBUG == "ON"} {
    set VOPT_ARG "+acc"
    echo $VOPT_ARG
    set DB_SW "-debugdb"
} else {
    set DB_SW ""
}

# TODO: specify name of the top testbench
vsim -voptargs=$VOPT_ARG $DB_SW -pedanticerrors -lib $LIB gray_count_tb

if {$DEBUG == "ON"} {
    add wave -r /dut/*
}

run -a
