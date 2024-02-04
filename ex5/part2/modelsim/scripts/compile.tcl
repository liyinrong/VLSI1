# Script to compile RTL sourcecode

set DEBUG ON
set COVERAGE OFF

# Set working library.
set LIB work

# If a simulation is loaded, quit it so that it compiles in a clean working library.
set STATUS [runStatus]
if {$STATUS ne "nodesign"} {
    quit -sim
}

# Start with a clean working library.
if { [file exists $LIB] == 1} {
    echo "lib exist"
    file delete -force -- $LIB
}
vlib $LIB

if {$COVERAGE == "ON"} {
    set COV_TYPE bcst
} else {
    set COV_TYPE 0
}

vlog -sv -pedanticerrors -cover $COV_TYPE -work $LIB -f ../sourcecode/file.list

vlog -sv -work $LIB -cover $COV_TYPE -f ../sourcecode/tb/file.list
