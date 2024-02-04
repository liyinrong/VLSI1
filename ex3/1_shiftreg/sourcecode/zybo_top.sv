/**
  * Zybo Top-Level Module to Demonstrate Shift Registers on LEDs
  *
  * Maintainer: VLSI I Assistants <vlsi1@iis.ee.ethz.ch>
  */

 module zybo_top #(
     parameter integer ClkDiv         = 50_000_000,
     parameter integer DebounceCycles = 50_000,
     localparam integer NumLeds       = 4
 ) (
     input  logic               clk_i,
     input  logic               btn_i,
     output logic [NumLeds-1:0] led_o
 );

    // Signal declarations
    logic rst_n;
    logic slow_clk;
    // TODO: Declare the rest of the signals in Figure 2 (dat, w_d, ...)
    logic dat, w_d, w_q1, w_q2, w_q3, w_q4;

    // Flip-flop registers
    // TODO: Implement your flip flops
    always_ff @(posedge slow_clk) begin
        if(~rst_n) begin
            w_q1 <= 1'b0;
            w_q2 <= 1'b0;
            w_q3 <= 1'b0;
            w_q4 <= 1'b0;
        end
        else begin
            w_q1 <= w_d;
            w_q2 <= w_q1;
            w_q3 <= w_q2;
            w_q4 <= w_q3;
        end
    end

    // Signal wiring
    // TODO: Assign the rest of the wires in Figure 2
    assign w_d = dat;
    assign led_o = {w_q4, w_q3, w_q2, w_q1};

    // Debouncer for button
    debouncer #(
        .NumCycles (DebounceCycles)
    ) i_debouncer (
        .clk_i  (clk_i),
        .rst_ni (rst_n),
        .inp_i  (btn_i),
        .oup_o  (dat)
    );

    // Reset Generator
    rst_gen #(
        .RstClkCycles (10)
    ) i_rst_gen (
        .clk_i  (clk_i),
        .rst_ni (1'b1),
        .rst_o  (),
        .rst_no (rst_n)
    );

    // Clock Prescaler
    clock_prescaler #(
        .Div (ClkDiv)
    ) i_clk_prescaler(
        .clk_i  (clk_i),
        .rst_ni (rst_n),
        .clk_o  (slow_clk)
    );

endmodule
