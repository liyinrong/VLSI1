#################################################################
## Example MMMC SDC files
#################################################################
##
## There are 5 files in this fictional MMMC (multi-mode multi-corner)
## analysis setup:
##   - src/sample/mmmc_shared.sdc        SDC file with common constraints
##   - src/sample/mmmc_functional.sdc    Functional mode constraints
##   - src/sample/mmmc_test.sdc          Test mode constraints
##   - src/sample/mmmc_hold.sdc          Hold timing analysis mode
##   - src/sample/mmmc.view.tcl          Sample TCL file that can be adapted
##
## Please note these are just for reference, develop your own scripts!
##
#################################################################

## This mode is only used for hold analysis. Period is not very important
## however, it is important for the output timing.
create_clock -period  25 [get_ports {Clk_CI}]
set_propagated_clock [get_ports {Clk_CI}]

## Be careful with the I/O timing, Especially after clock insertion. Silly
## values here may result in additional delay elements to slow down the
## input, so that input hold times are satisfied.
set_input_delay  1.75 -clock {Clk_CI} [remove_from_collection [get_ports *I] [get_ports {Clk_CI}]]
## Be careful with the period.
set_output_delay 13.25 -clock {Clk_CI} [get_ports *O]


## Be careful with false_paths. Scan chains are especially vulnerable
## to hold violations, do NOT disable paths, unless you are sure that 
## it will not mask a hold violation.


## In practice, using the test_mode with best dcase timing could be 
## sufficient. It is not necessary to always have a separate SDC
