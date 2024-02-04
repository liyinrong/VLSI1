// Copyright (c) 2022 Integrated Systems Laboratory, ETH Zurich
// Used for the VLSI 1 course
// 
// Author: Michael Rogenmoser <michaero@iis.ee.ethz.ch>

// Traffic Light controller TB
module tb_traffic_ctrl #(
  parameter string StimFileName = "../simvectors/traffic_light_stimuli.asc",
  parameter string ExpectedFileName = "../simvectors/initial_expresp.asc"
  // parameter string ExpectedFileName = "../simvectors/red2green_expresp.asc"
  // parameter string ExpectedFileName = "../simvectors/flash_all_expresp.asc"
) ();

  timeunit 1ns;
  timeprecision 10ps;

  localparam time CLK_PERIOD = 10ns;
  localparam time APPL_DELAY = 2ns;
  localparam time ACQ_DELAY  = 8ns;
  localparam unsigned RST_CLK_CYCLES = 10;

  typedef struct packed {
    logic Timer, Button;
  } stimuli_t;

  logic clk, rst_n;
  // logic button, timer;
  stimuli_t stim;
  logic [2:0] lights;
  string reference = "%%";

  clk_rst_gen #(
    .ClkPeriod     ( CLK_PERIOD ),
    .RstClkCycles ( RST_CLK_CYCLES )
  ) i_clk_rst_gen (
    .clk_o  ( clk   ),
    .rst_no ( rst_n )
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
    $fgets(line,stim_fd);
    while (line.substr(0,0) == reference.substr(0,0) && !$feof(stim_fd)) begin
      $fgets(line,stim_fd);
    end
    wait(rst_n);
    while (!$feof(stim_fd)) begin
      @(posedge clk);
      #(APPL_DELAY);
      stim.Timer = line.substr(2,2).atobin();
      stim.Button = line.substr(4,4).atobin();
      $fgets(line,stim_fd);
    end
    $fclose(stim_fd);
  end

  // DUT
`ifdef USE_BAD

    traffic_ctrl_bad dut (
      .clk_i    (clk    ),
      .rst_ni   (rst_n  ),
      .lights_o (lights ),
      .timer_i  (stim.Timer  ),
      .button_i (stim.Button )
    );

`else

    traffic_ctrl_good dut (
      .clk_i    ( clk    ),
      .rst_ni   ( rst_n  ),
      .lights_o ( lights ),
      .timer_i  ( stim.Timer  ),
      .button_i ( stim.Button )
    );

`endif

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
    wait(rst_n);
    while (!$feof(expected_fd)) begin
      @(posedge clk);
      #(ACQ_DELAY);

      if (lights != line.substr(0,2).atobin()) begin
        $display("Error at %t: detected %3b, required %3b", $time, lights, line.substr(0,2).atobin());
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
