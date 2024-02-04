# v0.4 - muheim - Fri Aug 29 13:47:30 CEST 2014
# - add func_view to the hold of set_analysis_view
# v0.3 - muheim - Mon Jun 16 14:22:33 CEST 2014
# - rename mmmc_test_mode.sdc
# v0.2 - muheim - Wed Apr 30 10:15:11 CEST 2014
# - Remove the captbl for create_rc_corner it is not set anymore for edi13 
#   and beyond.
# - Add {*} in front of '[glob' to generate a correct list not a list of lists.

#################################################################
## Script to setup the MMMC (Multi-Mode Multi Corner) analysis 
#################################################################
## Adapt according to your design


#################################################################
## INITIALIZATION
#################################################################

## Three delay calculation corners are defined here typical, best, worst
## the long command parses the 
create_library_set -name typical_libs \
                   -timing [ list \
                              {*}[glob -nocomplain tech/lib/*_tc.*lib] \
                              {*}[glob -nocomplain tech/lib/*_1d2vtc.*lib] \
                              {*}[glob -nocomplain tech/lib/*_tt1v25c.*lib] \
                              {*}[glob -nocomplain tech/lib/*_1d0vtc.*lib] \
                              {*}[glob -nocomplain tech/lib/*_TC.*lib] \
                              {*}[glob -nocomplain tech/lib/*_tt1p2v25c.*lib] \
                           ]
create_library_set -name best_libs \
                   -timing [ list \
                              {*}[glob -nocomplain tech/lib/*_bc.*lib] \
                              {*}[glob -nocomplain tech/lib/*_1d32vbc.*lib] \
                              {*}[glob -nocomplain tech/lib/*_ff1p1vm40c.*lib] \
                              {*}[glob -nocomplain tech/lib/*_1d1vbc.*lib] \
                              {*}[glob -nocomplain tech/lib/*_BC.*lib] \
                              {*}[glob -nocomplain tech/lib/*_ff1p32vm40c.*lib] \
                           ]
create_library_set -name worst_libs \
                    -timing [ list \
		                    {*}[glob -nocomplain tech/lib/*_wc.*lib] \
		                    {*}[glob -nocomplain tech/lib/*_1d08vwc.*lib] \
		                    {*}[glob -nocomplain tech/lib/*_ss0p9v125c.*lib] \
		                    {*}[glob -nocomplain tech/lib/*_0d9vwc.*lib] \
		                    {*}[glob -nocomplain tech/lib/*_WC.*lib] \
		                    {*}[glob -nocomplain tech/lib/*_ss1p08v125c.*lib] \
                     ]

# RC corners
create_rc_corner -name typical_rc -qx_tech_file tech/qrcTechFile_typical.tch 
create_rc_corner -name best_rc    -qx_tech_file tech/qrcTechFile_rcmin.tch
create_rc_corner -name worst_rc   -qx_tech_file tech/qrcTechFile_rcmax.tch
                       
## Three delay corners are defined here
create_delay_corner -name typical_delay -library_set typical_libs -rc_corner typical_rc
create_delay_corner -name best_delay    -library_set best_libs    -rc_corner best_rc
create_delay_corner -name worst_delay   -library_set worst_libs   -rc_corner worst_rc


#################################################################
## LOAD CONSTRAINTS
#################################################################

## Here the SDC files that are part of MMMC flow are defined. 
## In this fictional example we have three modes 
##  1) functional: standard mode where the chip is functioning normally,
##                 timing paths from test inputs are disabled
##  2) test      : works with a slower clock, timing paths from test 
##                 inputs are enabled
##  3) hold      : Timing mode to check hold violations covers both cases.
##
## Each of the above mode will have their own constraints defined in a 
## separate SDC file. IN addition, there is a mmmc_shared.sdc that contains
## constraints that are common between two modes. These are just examples, 
## adjust according to your own requirements
##
create_constraint_mode -name func_mode -sdc_files [list src/mmmc_functional.sdc \
                                                        src/mmmc_shared.sdc ]   
create_constraint_mode -name test_mode -sdc_files [list src/mmmc_test.sdc \
                                                        src/mmmc_shared.sdc ]  
create_constraint_mode -name hold_mode -sdc_files [list src/mmmc_hold.sdc \
                                                        src/mmmc_shared.sdc ]  

## now we create a view that combined the MODE with the CORNER
## hence the name Multi MODE multi CORNER.
##
## This example uses three views:
##
create_analysis_view -name func_view -delay_corner typical_delay -constraint_mode func_mode
create_analysis_view -name test_view -delay_corner typical_delay -constraint_mode test_mode
create_analysis_view -name hold_view -delay_corner best_delay    -constraint_mode hold_mode

#################################################################
## SET ANALYSIS VIEWS
#################################################################

## This command determines which VIEWS will be used for analysis. In this
## example we use both 'functional' and 'test_mode' when doing setup analysis
## and we use only the 'hold' view when doing hold analysis. 

set_analysis_view -setup { func_view test_view } \
                  -hold  { hold_view }
                  
## *IMPORTANT* It is actually possible that due to the differences in modelling,
##             for some circuits it could actually be possible that hold violations
##             can occur for 'typical' or 'worst' timing. We would advise to create
##             hold views with three different delay corners, just to make sure that this
##             is not the case. 
                  
                  
## The MMMC will affect the way some of the commands are going to work:
## use:
##   timeDesign -expandedViews
## to get separate reports for each view
                  
