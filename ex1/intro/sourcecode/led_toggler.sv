/**
  * LED Toggler
  *
  * Drive LEDs from a register in which individual LEDs can be toggled.  The "cursor" position,
  * i.e., which LED gets toggled, is part of the state of this entity.
  *
  * Maintainer: VLSI I Assistants <vlsi1@iis.ee.ethz.ch>
  */

module led_toggler #(
    parameter integer NumLeds    // Number of LEDs
) (
    input  logic                clk_i,
    input  logic                rst_ni,

    // 1 -> set "cursor" to the next LED.  Does not wrap at the last LED.
    input  logic                next_i,

    // 1 -> set "cursor" to the previous LED.  Does not wrap at the first LED.  If both `next_i` and
    // `prev_i` are `1` during a clock cycle, `next_i` prevails.
    input  logic                prev_i,

    // 1 -> toggle the LED at the current "cursor" position.
    input  logic                toggle_i,

    output logic [NumLeds-1:0]   led_o
);

    // The state of the LEDs.
    logic [NumLeds-1:0]          led_d,              led_q;

    // The position of the "cursor".
    logic [$clog2(NumLeds)-1:0]  pos_d,              pos_q;

    // Update the LED state.
    always_comb begin
        led_d = led_q;
        if (toggle_i) begin
            led_d[pos_q] = !led_q[pos_q];
        end
    end

    // Drive outputs.
    assign led_o = led_q;

    // Update the "cursor" position.
    always_comb begin
        pos_d = pos_q;
        if (next_i && pos_q < NumLeds-1) begin
            pos_d = pos_q + 1;
        end else if (prev_i && pos_q > 0) begin
            pos_d = pos_q - 1;
        end
    end

    // Registers
    always_ff @(posedge clk_i) begin
        if (~rst_ni) begin
            led_q <= '0;
            pos_q <= '0;
        end else begin
            led_q <= led_d;
            pos_q <= pos_d;
        end
    end

endmodule

