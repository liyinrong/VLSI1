.PHONY: inferred_latch bad_generics clean

inferred_latch: clean
	vivado-2017.2 vivado -mode gui -source scripts/inferred_latch.tcl

bad_generics: clean
	vivado-2017.2 vivado -mode gui -source scripts/bad_generics.tcl

clean:
	$(RM) -rf *.{cache,hw,ioplanning,ip_user_files,sim,srcs,runs,xpr} .Xil || true
	$(RM) -f vivado*.{debug,jou,log,str,zip} || true
	$(RM) *.log *.data || true
