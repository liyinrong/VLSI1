# v0.1  - <muheim@ee.ethz.ch> - Mon Jun 20 15:58:42 CEST 2011
#  - new

#
# remove core filler cells
#


set fillerCellList {}
dbForEachHeadCell [dbgHead] cellPtr {
  if [string match "FIL*" [dbCellName $cellPtr]]  {
    lappend fillerCellList [dbCellName $cellPtr]
  }
}

deleteFiller -cell $fillerCellList

