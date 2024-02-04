# v0.2  - <muheim@ee.ethz.ch> - Fri Aug 15 08:54:31 CEST 2014
#  - Changed the script no empty entrees will be created in to the list,
#    and the full range  filler cells without decoupling capacitors.
# v0.1  - <muheim@ee.ethz.ch> - Mon Jun 20 15:58:42 CEST 2011
#  - new

#
# insert core filler cells
#
# Note: FILE** and FILEP** contain decoupling capacitors
#

set fillerCellList {}
dbForEachHeadCell [dbgHead] cellPtr {
  if [string match "FIL*" [dbCellName $cellPtr]]  {
    lappend fillerCellList [dbCellName $cellPtr]
  }
}

# S
set fillerCellHVTList {}
set fillerCellRVTList {}
# W
set fillerCellLVTList {}

foreach c [list P64 P32 P16 P8 6 4 3 ]  {
  dbForEachHeadCell [dbgHead] cellPtr {
    if [string match "FILE${c}S" [dbCellName $cellPtr]]  {
      lappend fillerCellHVTList [dbCellName $cellPtr]
    }
    if [string match "FILE${c}R" [dbCellName $cellPtr]]  {
      lappend fillerCellRVTList [dbCellName $cellPtr]
    }
    if [string match "FILE${c}W" [dbCellName $cellPtr]]  {
      lappend fillerCellLVTList [dbCellName $cellPtr]
    }
  }
}

set fillerCellNoCList {}
foreach c [list 64 32 16 8 4 2 1]  {
  lappend fillerCellNoCList [ lsearch -inline -regexp $fillerCellList "FIL${c}\[W|R|S\]$"]
}



if [llength $fillerCellHVTList ] {
  addFiller -cell $fillerCellHVTList -prefix fillcore 
  addFiller -cell $fillerCellNoCList -prefix fillcore 
} elseif [llength $fillerCellRVTList ] {
  addFiller -cell $fillerCellRVTList -prefix fillcore 
  addFiller -cell $fillerCellNoCList -prefix fillcore 
} elseif [llength $fillerCellLVTList ] {
  addFiller -cell $fillerCellLVTList -prefix fillcore 
  addFiller -cell $fillerCellNoCList -prefix fillcore 
} else {
  puts "ERROR: find no Fill Cell!"
}
