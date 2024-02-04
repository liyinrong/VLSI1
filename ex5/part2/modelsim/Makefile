.PHONY: all
all: compile

TB_DUT ?= tb_shiftreg

SOLFILE = DEFAULT

ifneq ($(SOLFILE), DEFAULT)
	SOLCOMMAND = -GExpectedFileName="../simvectors/$(SOLFILE)"
else
	SOLCOMMAND = NONE
endif

.PHONY: compile
compile: scripts/compile.tcl
	questa-2019.3 vsim -c -do "set TB_DUT $(TB_DUT); source scripts/compile.tcl"

.PHONY: runsim
runsim: scripts/runsim.tcl
	questa-2019.3 vsim -gui -do "set TB_DUT $(TB_DUT); set SOLCOMMAND $(SOLCOMMAND); source scripts/compile_n_runsim.tcl"

.PHONY: clean
clean:
	rm -rf modelsim.ini transcript vsim.wlf work vsim.dbg
