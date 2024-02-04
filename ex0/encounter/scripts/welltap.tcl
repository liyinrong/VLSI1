# v0.1  - <muheim@ee.ethz.ch> - Fri Jun 10 11:01:58 CEST 2011
#  - new


set wellTapList {}
dbForEachHeadCell [dbgHead] cellPtr {
  if [string match "WT3*" [dbCellName $cellPtr]]  {
    lappend wellTapList [dbCellName $cellPtr]
  }
}



addWellTap -cell [lindex $wellTapList 0] -cellInterval 30 -checkerBoard 
