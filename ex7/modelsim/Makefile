.PHONY: all
all: run

.PHONY: run
run: scripts/compile.tcl scripts/runsim.tcl
	vsim-10.7b -batch -do scripts/compile.tcl
	vsim-10.7b -gui -do scripts/runsim.tcl &

.PHONY: clean
clean:
	rm -rf covhtmlreport modelsim.ini myreport.txt transcript vsim.wlf work vsim.dbg
