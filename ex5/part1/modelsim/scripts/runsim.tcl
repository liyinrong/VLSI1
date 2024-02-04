if {$DEBUG == "ON"} {
    set VOPT_ARG "+acc"
    echo $VOPT_ARG
    set DB_SW "-debugdb"
} else {
    set DB_SW ""
}

if {$COVERAGE == "ON"} {
    set COV_SW -coverage
} else {
    set COV_SW ""
}

if {$SOLCOMMAND == "NONE"} {
    set REALSOLCOMMAND ""
} else {
    set REALSOLCOMMAND $SOLCOMMAND
}

vsim -voptargs=$VOPT_ARG $DB_SW $COV_SW -pedanticerrors -lib $LIB $TB_DUT -suppress PLI-3691 $DEFINE $REALSOLCOMMAND

if {$DEBUG == "ON"} {
    add wave -r /dut/*
}

run -a

if {$COVERAGE == "ON"} {
    coverage report -totals -out myreport.txt
    coverage report -html
}
