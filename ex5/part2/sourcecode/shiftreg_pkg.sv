// Copyright (c) 2022 Integrated Systems Laboratory, ETH Zurich
// Used for the VLSI 1 course
//
// Author: Marco Bertuletti <mbertuletti@iis.ee.ethz.ch>

package shiftreg_pkg;

  parameter int Stage1Width = 5;
  parameter int Stage2Width = 7;
  parameter int Stage3Width = 9;
  parameter int Stage4Width = 11;

  parameter int InputWidth  = Stage1Width;
  parameter int OutputWidth = 13;

  typedef logic[Stage1Width-1:0] stage1_type;
  typedef logic[Stage2Width-1:0] stage2_type;
  typedef logic[Stage3Width-1:0] stage3_type;
  typedef logic[Stage4Width-1:0] stage4_type;

endpackage
