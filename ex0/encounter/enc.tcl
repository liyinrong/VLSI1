# 
# Encounter init 
#
# v0.5 bm  - Tue Sep  9 15:10:37 CEST 2014
# - Add suppress message
# v0.4 bm  - Wed Sep  3 14:57:00 CEST 2014
# - Absolute path for env(TMPDIR) otherwise the external QRC (10.1.1-s119)
#   started when using the qrc.extra.cmd file, it included GDS of the libs..
# v0.3 bm  - Tue May  6 09:36:55 CEST 2014
# - Remove the set the signalStorm STA engine. It is obsolete for edi 13.
# - Add setDelayCalMode
# v0.2 bm  - Wed Jul  4 13:30:54 CEST 2012
# - Set the grid per gate here instate in the checkdesign.tcl 
# v0.1 bm  - Fri Jun 10 16:16:00 CEST 2011
# - copy from umcL90 v0.2 and updtet it to umcL65

# enable footprintless optimization flow
set dbgGPSAutoCellFunction 1

# change report timing format to include also the load
set_global report_timing_format {instance arc cell slew load delay arrival}
#set_global timing_report_timing_header_detail_info extended

# alternatively you can also add fanout to the report
#set_global report_timing_format {instance arc cell slew load fanout delay arrival}

# to allowed after CTS to do the reload the constraint withe 
# "set_analysis_view -update_timing" after "update_constraint_mode ..."
set_global timing_defer_mmmc_object_updates true


# To prevent using the signal integrity for timing calculate.
# It also not asking for using Chip Variation doing the timing calculation after
# routing.
setDelayCalMode -siAware false

# setDoAssign behaviour
# assign statements will be kept
#setDoAssign off
# assign statements will be replaced by a BUFFER of the given type 
setDoAssign on -buffer BUFM2W

# set the temp dir
set env(TMPDIR) "$env(PWD)/../tmp"

# set the technology
setDesignMode -process 65

# umc65 has 4 grid units per gate
set dbgSitesPerGate 4

# suppress message
suppressMessage ENCLF-200 ;    # Message: Pin 'SIG' in macro 'DI_G' has no ANTENNAGATEAREA value defined. The library data is incomplete and some process antenna rules will not be checked correctly.
suppressMessage TECHLIB-436 ;  # Message: Attribute 'max_fanout' on 'output/inout' pin 'CO0B' of cell 'ADCSOM4W' is not defined in the library.
suppressMessage ENCFP-3961 ;   # Message: techSite 'iocorner' has no related Cells, So Cannnot calculated VDDonbotom attributes. Need correct LEF file
suppressMessage ENCFP-325 ;    # Message: Floorplan of the design is resized. All current floorplan objects are automatically derived based on specified new floorplan. This may change blocks, fixed standard cells, existing routes and blockages.
suppressMessage ENCSR-2455 ;   # Message: An unexpected implant layer:SPSHVT is found between layer:LPLUS and layer:CONT. Move the implant layer to the beginning or the end of LAYER section in the LEF tech file.

suppressMessage ENCSR-4302 ;   # Message: Cap-table is found in the design, so the same information from LEF will be ignored.

suppressMessage ENCESI-2013 ;  # Message: The instance pad_DataIn_DI_10 term OE has zero voltage, resetting to default vdd.

suppressMessage ENCCK-951 ;    # Message: Net Clk_C have 1164 pins.

suppressMessage NRDB-733 ;     # Message: PIN Clk_CI in CELL_VIEW filter_chip,init does not have physical port.

suppressMessage ENCEXT-3493 ;  # Message:  Design extraction status is reset when the setExtractRCMode command is called. Either re-generate the parasitic data by calling the extractRC command or run the spefIn command to read the parasitic data.

suppressMessage ENCVPA-55 ;    # Message: Option -leffile for command verifyProcessAntenna is obsolete. Use 'lefOut -5.5 | -5.6 fileName' instead. The obsolete option still works in this release, but to avoid this warning and to ensure compatibility with future releases, remove -leffile from your script.

suppressMessage SDF-802 ;      # Message: The sum of the Setup and Hold sides of the SETUPHOLD check on pin i_filter_top/u_filter_CoeffAddrCNT_DP_reg_10_/SE is negative - which is illegal in SDF V3.0. The negative side of the SETUPHOLD will be postively adjusted so that the resulting sum is zero. This will result in a more conservative analysis of the adjusted check.  Negative SETUPHOLD sums maybe an indication of a characterization problem in your timing libraries. You can set the timing global timing_write_sdf_allow_negative_setuphold_sum to 'true' to loosen this restriction.

suppressMessage NREX-28 ;      # Message:  The height of the first routing layer ME1 is 0.000000. It should be larger than 0.000000.
suppressMessage NREX-30 ;      # Message:  Please also check the height and metal thickness values for the routing layers higher than routing layer ME1.

suppressMessage NRDB-665 ;     # Message:  NET DataOut_DO[10] has a detail routed segment whose one end (-0.001 -0.001) is outside of design boundary (0.000 0.000 1200.000 1200.000).
suppressMessage NRIG-44 ;      # Message:  Imported NET DataOut_DO[10] has LVS problem. The integrity of the wires will be checked. NanoRoute will continue. Check the net for FIXED or misaligned routing connections. If necessary, skip this net or delete the net routing.
