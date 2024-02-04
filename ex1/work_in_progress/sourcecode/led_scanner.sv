/**
  * TODO: header
  */

module led_scanner #(
    parameter integer NumLeds,
    parameter integer RefreshIval
) (
    input  logic                 clk_i,
    input  logic                 rst_ni,
    output logic [NumLeds-1:0]   led_o
);

    // Check module parameters at elaboration time.
    if (NumLeds != 4) begin
        $error("Unsupported number of LEDs!");
    end

    // Define constants.
    localparam integer LogPeriod = NumLeds-1;
    localparam integer PosBitw = $clog2(NumLeds);

    // Define types.
    typedef logic [0:NumLeds-1][$clog2(LogPeriod)-1:0]  active_t;
    typedef enum logic {Forward, Backward}              state_t;

    // Define signals.
    active_t                            log_active;
    logic [PosBitw-1:0]                 pos_cnt_d,          pos_cnt_q;
    logic [$clog2(RefreshIval)-1:0]     ref_cnt_d,          ref_cnt_q;
    state_t                             state_d,            state_q;

    // Define LUT for LED values.
    const active_t log_active_lut [0:NumLeds-1] = {
        {2'b00, 2'b01, 2'b10, 2'b11},
        {2'b01, 2'b10, 2'b11, 2'b10},
        {2'b10, 2'b11, 2'b10, 2'b01},
        {2'b11, 2'b10, 2'b01, 2'b00}
    };

    assign log_active = log_active_lut[pos_cnt_q];

    assign ref_cnt_d = (ref_cnt_q < RefreshIval) ? ref_cnt_q + 1 : '0;

    always_comb begin
        pos_cnt_d   = pos_cnt_q;
        state_d     = state_q;

        if (ref_cnt_q == 1'b1) begin
            case (state_q)

                Forward: begin
                    pos_cnt_d = pos_cnt_q + 1;
                    if (pos_cnt_q == NumLeds-1) begin
                        pos_cnt_d   = pos_cnt_q - 1;
                        state_d     = Backward;
                    end
                end

                Backward: begin
                    pos_cnt_d = pos_cnt_q - 1;
                    if (pos_cnt_q == '0) begin
                        pos_cnt_d   = 1'b1;
                        state_d     = Forward;
                    end
                end

                default: begin
                    state_d = Forward;
                end
            endcase
        end
    end

    generate for (genvar i = 0; i < NumLeds; i++) begin: gen_led_pwms
        log_pulse_width_modulator #(
            .LogPeriod (LogPeriod)
        ) i_log_pwm (
            .clk_i          (clk_i),
            .rst_ni         (rst_ni),
            .log_active_i   (log_active[i]),
            .oup_o          (led_o[i])
        );
    end endgenerate

    always_ff @(posedge clk_i) begin
        if (~rst_ni) begin
            pos_cnt_q   <= '0;
            ref_cnt_q   <= '0;
            state_q     <= Forward;
        end else begin
            pos_cnt_q   <= pos_cnt_d;
            ref_cnt_q   <= ref_cnt_d;
            state_q     <= state_d;
        end
    end

endmodule
