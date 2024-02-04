// Copyright (c) 2022 Integrated Systems Laboratory, ETH Zurich
// Used for the VLSI 1 course
// 
// Author: Michael Rogenmoser <michaero@iis.ee.ethz.ch>

module tb_fsm_counter #(
  parameter string StimFileName = "../simvectors/counter_stimuli.asc",
  // parameter string ExpectedFileName = "../simvectors/counter_initial_expresp.asc"
  parameter string ExpectedFileName = "../simvectors/counter_change3_expresp.asc"
) ();

  timeunit 1ns;
  timeprecision 10ps;

  localparam time CLK_PERIOD = 10ns;
  localparam time APPL_DELAY = 2ns;
  localparam time ACQ_DELAY  = 8ns;
  localparam unsigned RST_CLK_CYCLES = 10;

  typedef struct packed {
    logic init, hold, direction;
  } stimuli_t;

  logic clk, rst_n;
  // logic button, timer;
  stimuli_t stim;
  logic [3:0] count;
  string reference = "%%";

  clk_rst_gen #(
    .ClkPeriod     ( CLK_PERIOD ),
    .RstClkCycles ( RST_CLK_CYCLES )
  ) i_clk_rst_gen (
    .clk_o  ( clk   ),
    .rst_no (  )
  );

  // Application
  initial begin: application_block
    integer stim_fd;
    string line;
    stim_fd = $fopen(StimFileName, "r");
    if (stim_fd == 0) begin
      $fatal(1, "Could not open stimuli file!");
    end

    stim = '0;
    rst_n = '0;
    $fgets(line,stim_fd);
    while (line.substr(0,0) == reference.substr(0,0) && !$feof(stim_fd)) begin
      $fgets(line,stim_fd);
    end
    while (!$feof(stim_fd)) begin
      @(posedge clk);
      #(APPL_DELAY);
      rst_n = line.substr(0,0).atobin();
      stim.init = line.substr(2,2).atobin();
      stim.hold = line.substr(4,4).atobin();
      stim.direction = line.substr(6,6).atobin();
      $fgets(line,stim_fd);
    end
    $fclose(stim_fd);
  end

  fsm_counter dut (
    .clk_i       ( clk            ),
    .rst_ni      ( rst_n          ),
    .init_i      ( stim.init      ),
    .hold_i      ( stim.hold      ),
    .direction_i ( stim.direction ),
    .count_o     ( count          )
  );


  // Acquisition and Evaluation
  initial begin: acquisition_checker_block
    integer expected_fd;
    automatic integer num_errors = 0;
    string line;
    expected_fd = $fopen(ExpectedFileName, "r");
    if (expected_fd == 0) begin
      $fatal(1, "Could not open responses file!");
    end

    $fgets(line,expected_fd);
    while(line.substr(0,0) == reference.substr(0,0) && !$feof(expected_fd)) begin
      $fgets(line,expected_fd);
    end
    while (!$feof(expected_fd)) begin
      @(posedge clk);
      #(ACQ_DELAY);

      if (count != line.substr(0,3).atobin()) begin
        $display("Error at %t: detected %3b, required %3b", $time, count, line.substr(0,3).atobin());
        num_errors = num_errors + 1;
      end

      $fgets(line,expected_fd);
    end
    $fclose(expected_fd);
    $display("Finished simulation with %d Errors.", num_errors);
    if (num_errors == '0) begin
      $display("TEST SUCCEEDED");
    end else begin
      $display("TEST FAILED");
    end
    $stop();
  end

endmodule
