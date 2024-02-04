/**
  * TODO: header
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

    logic               rst_n;

    logic [NumBtns-1:0]  btn,
                        dbnc_btn;

    logic [NumLeds-1:0]  led_scanner_oup,
                        led_switcher_oup,
                        led_toggler_oup;

    logic [1:0]         mode_d,             mode_q;

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

    led_scanner #(
        .NumLeds       (NumLeds),
        .RefreshIval   (10000000)
    ) i_led_scanner (
        .clk_i      (clk_i),
        .rst_ni     (rst_n),
        .led_o      (led_scanner_oup)
    );

    // Use button 0 to cycle through modes.
    always_comb begin
        mode_d = mode_q;
        if (btn[0]) begin
            if (mode_q < 2) begin
                mode_d = mode_q + 1;
            end else begin
                mode_d = '0;
            end
        end
    end

    // Multiplex LED output depending on the currently active mode.
    always_comb begin
        case (mode_q)
            2'b00:      led_o = led_switcher_oup;
            2'b01:      led_o = led_toggler_oup;
            2'b10:      led_o = led_scanner_oup;
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
