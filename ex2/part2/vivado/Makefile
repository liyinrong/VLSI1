.PHONY: all
all: gui

.PHONY: gui
gui: ex2-part2.xpr
	vivado-2017.2 vivado -mode gui -source scripts/open_proj.tcl ex2-part2.xpr &

ex2-part2.xpr: scripts/init_proj.tcl
	vivado-2017.2 vivado -mode batch -source scripts/init_proj.tcl

.PHONY: bitstream
bitstream: ex2-part2.xpr
	vivado-2017.2 vivado -source scripts/gen_bitstream.tcl ex2-part2.xpr

.PHONY: clean
clean:
	rm -rf *.{cache,hw,ioplanning,ip_user_files,sim,srcs,runs,xpr}
	rm -f vivado*.{jou,log,str,zip}
