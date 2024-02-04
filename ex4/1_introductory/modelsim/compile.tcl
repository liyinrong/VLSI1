# Script to compile RTL sourcecode

set DEBUG OFF

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
    # file delete -force -- $LIB
}
vlib $LIB

# TODO: Add command to compile DUT from file list.
vlog -sv -pedanticerrors -work $LIB -f ../sourcecode/file.list

# TODO: Add command to compile TB from file list.
vlog -sv -work $LIB -f ../sourcecode/tb/file.list
