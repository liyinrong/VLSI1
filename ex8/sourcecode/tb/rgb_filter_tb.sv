module rgb_filter_tb ();

  localparam time     CLK_PERIOD     = 50ns;
  localparam unsigned RST_CLK_CYCLES = 10;
  localparam time     APPL_DELAY     = CLK_PERIOD * 3;
  localparam time     ACQ_DELAY      = CLK_PERIOD * 4;

  logic               clk,
                      rst_n;

  logic [218:0]       stim;
  logic [23:0]        act_resp,
                      exp_resp;

  rgb_filter dut (
    .clk_i    ( clk               ),
    .rst_ni   ( rst_n             ),

    .switch_i ( stim[218:216]     ),

    .r_i      ( stim[215:144]     ),
    .g_i      ( stim[143: 72]     ),
    .b_i      ( stim[ 71:  0]     ),
    .hsync_i  ( 1'b1              ),
    .vsync_i  ( 1'b0              ),
    .vde_i    ( 1'b1              ),
    .valid_i  ( 1'b1              ),
    .ready_o  (                   ),

    .r_o      ( act_resp[23:16]   ),
    .g_o      ( act_resp[15: 8]   ),
    .b_o      ( act_resp[ 7: 0]   ),
    .hsync_o  (                   ),
    .vsync_o  (                   ),
    .vde_o    (                   ),
    .valid_o  (                   ),
    .ready_i  ( 1'b1              )
  );

  clk_rst_gen #(
    .ClkPeriod      ( CLK_PERIOD     ),
    .RstClkCycles   ( RST_CLK_CYCLES )
  ) i_clk_rst_gen (
    .clk_o          ( clk            ),
    .rst_no         ( rst_n          )
  );

  // Apply stimuli from file.
  initial begin: stim_appl
    integer stim_fd = $fopen("stimuli_filter.txt", "r");

    if (stim_fd == 0)
      $fatal(0, "Could not open stimuli file!");

    stim = '0;
    wait (rst_n);

    while (!$feof(stim_fd)) begin
      @(posedge clk);
      #(APPL_DELAY);
      $fscanf(stim_fd, "%h\n", stim);
    end

    $fclose(stim_fd);
  end

  // Check actual against expected responses from file.
  initial begin: exp_resp_acq_check
    integer exp_resp_fd, n_errs, n_checks;

    exp_resp_fd = $fopen("exp_resp_filter.txt", "r");

    if (exp_resp_fd == 0)
      $fatal(0, "Could not open expected responses file!");

    n_errs   = 0;
    n_checks = 0;
    exp_resp = 0;
    wait (rst_n);

    while (!$feof(exp_resp_fd)) begin
      @(posedge clk);
      #(APPL_DELAY);

      $fscanf(exp_resp_fd, "%h\n", exp_resp);
      #(ACQ_DELAY-APPL_DELAY);

      assert (exp_resp == act_resp) else begin
        $error("Expected %h, got %h!", exp_resp, act_resp);
        n_errs += 1;
      end

      n_checks += 1;
    end

    $fclose(exp_resp_fd);

    if (n_errs > 0) begin
      $display("Test failed with ", n_errs, " mismatches out of ", n_checks, " checks!");
    end else begin
      $display("Test passed with ", n_errs, " mismatches out of ", n_checks, " checks.");
    end

    #(CLK_PERIOD);
    $finish();
  end

endmodule // rgb_filter_tb
