# v0.2 - <muheim@ee.ethz.ch> - Wed Mar 18 10:33:26 CET 2015
#  - fix that is working proper also in difrent vt
# v0.1  - <muheim@ee.ethz.ch> - Mon Jun 20 14:07:38 CEST 2011
#  - copy from lf150  v0.1
#    add Tie search

set tieCellList {}
dbForEachHeadCell [dbgHead] cellPtr {
  if [string match "TIE*" [dbCellName $cellPtr]]  {
    lappend tieCellList [dbCellName $cellPtr]
  }
}

foreach c $tieCellList {
  if [string match "TIE1R" $c]  {
    set useTie1Cell $c
  }
  if [string match "TIE1W" $c]  {
    set useTie1Cell $c
  }
  if [string match "TIE1S" $c]  {
    set useTie1Cell $c
  }

  if [string match "TIE0R" $c]  {
    set useTie0Cell $c
  }
  if [string match "TIE0W" $c]  {
    set useTie0Cell $c
  }
  if [string match "TIE0S" $c]  {
    set useTie0Cell $c
  }
}

if {[info exists useTie1Cell] &&  $useTie1Cell ne "" &&
    [info exists useTie0Cell] &&  $useTie0Cell ne "" } {
  # first delete all existing tie cells 
  deleteTieHiLo -cell $tieCellList

  # set tiehilo mode and insert the new cells
  setTieHiLoMode -reset
  setTieHiLoMode -maxFanout 12 -maxDistance 200 -createHierPort true \
                 -cell [list $useTie1Cell $useTie0Cell]
  # -createHierPort true - try

  addTieHiLo -prefix tieoff

  #sometimes there are overlaps
  refinePlace
} else {
  puts "ERROR: find no Tie Cell!"
}


