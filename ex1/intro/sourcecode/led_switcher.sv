/**
  * LED Switcher
  *
  * Drive LEDs from input switches (simple feedforward).
  */

module led_switcher #(
    parameter integer NumLeds    // Number of LEDs
) (
    input  logic [NumLeds-1:0]   switch_i,
    output logic [NumLeds-1:0]   led_o
);

    assign led_o = switch_i;

endmodule
