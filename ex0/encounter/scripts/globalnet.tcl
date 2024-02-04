#
# create logical connectivity for power/ground pins,
# connect logic one/zero (1'b1/1'b0) in netlist to power/ground
#

clearGlobalNets

# stcell core-power/ground connection
globalNetConnect VDD -type pgpin -pin VDD -all
globalNetConnect VSS -type pgpin -pin VSS -all

# Memory/Rom (HM) core-power/ground connection
globalNetConnect VDD -type pgpin -pin VCC -inst *
globalNetConnect VSS -type pgpin -pin GND -inst *

# tie cell one/zero logic
globalNetConnect VDD -type tiehi
globalNetConnect VSS -type tielo

# Pads (IO) IO-power/ground connection
globalNetConnect VDDIO -type pgpin -pin VDDIO -inst *
globalNetConnect VSSIO -type pgpin -pin VSSIO -inst *
