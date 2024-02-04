# v0.1  - <muheim@ee.ethz.ch> - Wed Jun 15 09:48:51 CEST 2011
#  - copy from umcL90
# v0.2 bm  - Wed Jul  4 13:30:54 CEST 2012
# - Remove the seating of the grid per gate set it in enc.tcl.
# v0.3 - <muheim@ee.ethz.ch> - Tue May  6 09:25:52 CEST 2014
# - remove reportWire, reportGateCount
#   add summaryReport
# v0.4 - <muheim@ee.ethz.ch> - Tue Sep 23 09:11:50 CEST 2014
# - create wellTapList when not existing
#   use the first element of wellTapList

# is the design name specified ???
if { [ info exists DESIGNNAME ] } {
   set NAME "$DESIGNNAME"

} else {
    set NAME "final"

}

# create the verify under reports when not existing
if {![file exists reports/verify]} {
  file mkdir reports/verify
}

# when the wellTapList is not set we create it
if {![info exists wellTapList]} {
  set wellTapList {}
  dbForEachHeadCell [dbgHead] cellPtr {
    if [string match "WT3*" [dbCellName $cellPtr]]  {
      lappend wellTapList [dbCellName $cellPtr]
    }
  }
}


## verify
puts "porform Connectivity, Geometry, ProcessAntenna and WellTap Checks"
verifyConnectivity -type all -geomConnect -report reports/verify/${NAME}.connect.rpt
verifyGeometry -antenna -report reports/verify/${NAME}_geom.rpt
verifyProcessAntenna -leffile reports/verify/${NAME}_antenna.lef -reportfile reports/verify/${NAME}_antenna.rpt 
verifyWellTap -cell [lindex $wellTapList  0] -rule 30 -report  reports/verify/${NAME}_wellTap.rpt 


## reports
puts ""
puts "Writing summary report"
summaryReport -noHtml -outfile reports/verify/summaryReport.rpt

puts ""
puts "Checking nets that exceed the default delay limit"
puts "There should be no nets in the report below"
report_net -min_fanout [lindex $rdaUseDefaultDelayLimit 0]

