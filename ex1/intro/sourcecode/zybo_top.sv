/**
  * Top-Level Design for the Zybo Introduction Example
  *
  * Simple top-level design to introduce the Zybo FPGA board by displaying inputs (switches and push
  * buttons) on the LEDs.  There are two output modes, which are switched by a push button.  The
  * other inputs have different roles depending on the output mode.
  *
  * Maintainer: VLSI I Assistants <vlsi1@iis.ee.ethz.ch>
  */

 module zybo_top #(
     parameter integer NumLeds = 4,
     parameter integer NumBtns = 4
 ) (
     input  logic               clk_i,
     input  logic [NumBtns-1:0]  btn_i,
     input  logic [NumLeds-1:0]  switch_i,
     output logic [NumLeds-1:0]  led_o
 );

    logic [NumBtns-1:0]  btn,
                        dbnc_btn;

    logic [NumLeds-1:0]  led_switcher_oup,
                        led_toggler_oup;

    logic               mode_d,             mode_q,
                        rst_n;

    generate for (genvar i = 0; i < NumBtns; i++) begin: gen_btn_pulses
        debouncer #(
            .NumCycles(5000000)
        ) i_debouncer (
            .clk_i  (clk_i),
            .rst_ni (rst_n),
            .inp_i  (btn_i[i]),
            .oup_o  (dbnc_btn[i])
        );
        rising_edge_pulser i_rising_edge_pulser (
            .clk_i  (clk_i),
            .rst_ni (rst_n),
            .inp_i  (dbnc_btn[i]),
            .pulse_o(btn[i])
        );
    end endgenerate

    led_switcher #(
        .NumLeds(NumLeds)
    ) i_led_switcher (
        .switch_i   (switch_i),
        .led_o      (led_switcher_oup)
    );

    led_toggler #(
        .NumLeds(NumLeds)
    ) i_led_toggler (
        .clk_i      (clk_i),
        .rst_ni     (rst_n),
        .next_i     (btn[3]),
        .prev_i     (btn[1]),
        .toggle_i   (btn[2]),
        .led_o      (led_toggler_oup)
    );

    // Use button 0 to cycle through modes.
    always_comb begin
        mode_d = mode_q;
        if (btn[0]) begin
            if (mode_q < 1) begin
                mode_d = mode_q + 1;
            end else begin
                mode_d = '0;
            end
        end
    end

    // Multiplex LED output depending on the currently active mode.
    always_comb begin
        case (mode_q)
            1'b0:       led_o = led_switcher_oup;
            1'b1:       led_o = led_toggler_oup;
            default:    led_o = '0;
        endcase
    end

    // Reset Generator
    rst_gen #(
        .RstClkCycles (10)
    ) i_rst_gen (
        .clk_i  (clk_i),
        .rst_ni (1'b1),
        .rst_o  (),
        .rst_no (rst_n)
    );

    // Registers
    always_ff @(posedge clk_i) begin
        if (~rst_n) begin
            mode_q <= '0;
        end else begin
            mode_q <= mode_d;
        end
    end

 endmodule


