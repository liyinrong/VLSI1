.PHONY: all
all: gui

.PHONY: gui
gui: vivado-hdmi.xpr
	vivado-2017.2 vivado -mode gui -source scripts/open_proj.tcl vivado-hdmi.xpr &

vivado-hdmi.xpr: scripts/init_proj.tcl
	vivado-2017.2 vivado -mode batch -source scripts/init_proj.tcl

.PHONY: bitstream
bitstream: vivado-hdmi.xpr
	vivado-2017.2 vivado -source scripts/gen_bitstream.tcl vivado-hdmi.xpr

.PHONY: clean
clean:
	rm -rf *.{cache,hw,ioplanning,ip_user_files,sim,srcs,runs,xpr} .Xil || true
	rm -f vivado*.{debug,jou,log,str,zip} || true
	rm *.log *.data || true
