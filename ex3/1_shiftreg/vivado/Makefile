.PHONY: all
all: gui

.PHONY: gui
gui: shift_reg_chain.xpr
	vivado-2017.2 vivado -mode gui -source scripts/open_proj.tcl shift_reg_chain.xpr &

shift_reg_chain.xpr: scripts/init_proj.tcl
	vivado-2017.2 vivado -mode batch -source scripts/init_proj.tcl

.PHONY: bitstream
bitstream: shift_reg_chain.xpr
	vivado-2017.2 vivado -source scripts/gen_bitstream.tcl shift_reg_chain.xpr

.PHONY: clean
clean:
	rm -rf *.{cache,hw,ioplanning,ip_user_files,sim,srcs,runs,xpr} vivado*.{jou,log,str,zip} .Xil webtalk.*
