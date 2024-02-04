###########################################################################
#  power grid creation
##########################################################################
# v0.4  - <muheim@ee.ethz.ch> - Thu Aug  7 16:31:54 CEST 2014
#  - add ring for HM and create the grid on the end
# v0.3  - <muheim@ee.ethz.ch> - Wed May 21 08:49:16 CEST 2014
#  - be able to have one ore two core rings per P/G
#  - rename some variables and make it suitable for the edi13
#  - cleanup new order take out the no jog and trim_antenna_back.
#    The trim_antenna_back is not working proper so the jog is needed.
# v0.2  - <muheim@ee.ethz.ch> - Thu Aug  9 09:37:34 CEST 2012
#  - increase the distance between core and first ring,
#    std cells rows will connected to the secede ring only to ME6
# v0.1  - <muheim@ee.ethz.ch> - Mon Aug  8 14:28:53 CEST 2011
#  - copy from umcL130 v0.4 and mod
##########################################################################

## Strong recommended Floorplan sizes
## one core rings per P/G
#    floorPlan -site CORE -d X X 60 60 60 60
## two core rings per P/G
#    floorPlan -site CORE -d X X 30 30 30 30

## let us start with a cleanup
deleteAllPowerPreroutes
clearDrc

## just to be safe 
source scripts/globalnet.tcl

## standard cell and routing information settings
set cellHeight  1.8
set routGrid    0.2

## core ring settings
set pgcr1LayerH ME1
set pgcr1LayerV ME2
set pgcr2LayerH ME3
set pgcr2LayerV ME4
set pgcr3LayerH ME5
set pgcr3LayerV ME6
set pgcr4LayerH ME7
set pgcr4LayerV ME8

set pgcrSpacing 2
set pgcrWidth 12
set pgcrOffset 1.8

## net description for the core rings
## one core rings per P/G
set pgcrNet "VSS VDD"
## two core rings per P/G
#set pgcrNet "VSS VDD VSS VDD"

## core grid settings
set pgcgLayerH $pgcr4LayerH
set pgcgLayerV $pgcr4LayerV

#set pgcgWidthX [expr $routGrid * 10]
set pgcgWidthX [expr $routGrid * 30]
set pgcgWidthY [expr $routGrid * 3]

set pgcgSpacingX  [expr $pgcgWidthX * 4   - $pgcgWidthX]
set pgcgSpacingY  [expr $routGrid * 26 - $pgcgWidthY]
set pgcgDistanceX [expr $pgcgWidthX   * 8]
set pgcgDistanceY [expr $cellHeight * 6]

#set pgcgOffsetX  [expr $pgcgWidthX * 1.5 + (0.5 * $routGrid)]
set pgcgOffsetX  [expr 23 + (0.5 * $routGrid)]
set pgcgOffsetY  [expr $cellHeight - $pgcgWidthY/2]

## nets for the grid
set pgcgNet "VSS VDD"

## Core Rings creation and connection at all levels 
addRing -width  $pgcrWidth \
        -spacing $pgcrSpacing \
        -offset $pgcrOffset \
        -layer [list bottom $pgcr1LayerH top $pgcr1LayerH right $pgcr1LayerV left $pgcr1LayerV] \
        -nets $pgcrNet
addRing -width  $pgcrWidth \
        -spacing $pgcrSpacing \
        -offset $pgcrOffset \
        -layer [list bottom $pgcr2LayerH top $pgcr2LayerH right $pgcr2LayerV left $pgcr2LayerV] \
        -nets $pgcrNet
addRing -width  $pgcrWidth \
        -spacing $pgcrSpacing \
        -offset $pgcrOffset \
        -layer [list bottom $pgcr3LayerH top $pgcr3LayerH right $pgcr3LayerV left $pgcr3LayerV] \
        -nets $pgcrNet
addRing -width  $pgcrWidth \
        -spacing $pgcrSpacing \
        -offset $pgcrOffset \
        -layer [list bottom $pgcr4LayerH top $pgcr4LayerH right $pgcr4LayerV left $pgcr4LayerV] \
        -nets $pgcrNet



## Block Rings creation
addRing -around each_block -type block_rings \
        -width 0.3 \
        -spacing 0.3 \
        -offset 0.3 \
        -layer {bottom ME1 top ME1 right ME2 left ME2}  \
        -nets $pgcrNet


# connect power pads to power rings
sroute -connect { padPin } -padPinPortConnect  { allPort preferLayer } \
       -allowJogging 1 -allowLayerChange 1 \
       -padPinLayerRange [list $pgcr1LayerV $pgcr3LayerV ] \
       -targetViaLayerRange [list $pgcr1LayerV $pgcr3LayerV] \
       -crossoverViaLayerRange [list $pgcr1LayerV $pgcr3LayerV] \
       -nets $pgcrNet

# connect std cells
sroute -connect { corePin } \
       -allowLayerChange 1 \
       -targetViaLayerRange [list $pgcr1LayerV $pgcr3LayerV] \
       -targetPenetration { stripe 90 } \
       -nets $pgcrNet

## core grid creation and connection
addStripe -set_to_set_distance $pgcgDistanceY -ybottom_offset $pgcgOffsetY -spacing $pgcgSpacingY  -width $pgcgWidthY \
        -same_layer_target_only 1 -max_same_layer_jog_length 4 \
        -direction horizontal -layer $pgcgLayerH -padcore_ring_bottom_layer_limit $pgcr3LayerV \
        -extend_to all_domains \
        -nets $pgcgNet
addStripe -set_to_set_distance $pgcgDistanceX -spacing $pgcgSpacingX -xleft_offset $pgcgOffsetX -width $pgcgWidthX \
        -same_layer_target_only 1 -max_same_layer_jog_length 4 \
        -layer $pgcgLayerV \
        -nets $pgcgNet

redraw

