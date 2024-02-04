.PHONY: sep_comb_ff clean

sep_comb_ff: clean
	vivado-2017.2 vivado -mode gui -source scripts/sep_comb_ff.tcl

clean:
	$(RM) -rf *.{cache,hw,ioplanning,ip_user_files,sim,srcs,runs,xpr} .Xil || true
	$(RM) -f vivado*.{debug,jou,log,str,zip} || true
	$(RM) *.log *.data || true
