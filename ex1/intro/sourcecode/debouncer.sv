/**
  * Debouncer
  *
  * Debounces a signal, i.e., only propagates a value change if the value stays stable for a
  * configurable number of clock cycles.
  *
  * Maintainer: VLSI I Assistants <vlsi1@iis.ee.ethz.ch>
  */

module debouncer #(
    // Number of clock cycles for which the input must remain stable to change the output to the
    // same value as the input
    parameter integer NumCycles
) (
    input  logic clk_i,
    input  logic rst_ni,
    input  logic inp_i,     // Signal to be debounced
    output logic oup_o      // Debounced output
);

    localparam integer CntBitw = $clog2(NumCycles + 1);

    typedef enum logic [1:0] {Low, ToHigh, High, ToLow} state_t;

    logic [CntBitw-1:0]    cnt_d,      cnt_q;
    state_t                 state_d,    state_q;

    always_comb begin
        cnt_d   = cnt_q + 1;
        oup_o   = 1'b0;
        state_d = state_q;

        case (state_q)

            Low: begin
                oup_o = 1'b0;
                if (inp_i == 1'b1) begin
                    cnt_d   = '0;
                    state_d = ToHigh;
                end
            end

            ToHigh: begin
                oup_o = 1'b0;
                if (inp_i == 1'b0) begin
                    state_d = Low;
                end else if (cnt_q == NumCycles) begin
                    state_d = High;
                end
            end

            High: begin
                oup_o = 1'b1;
                if (inp_i == 1'b0) begin
                    cnt_d   = '0;
                    state_d = ToLow;
                end
            end

            ToLow: begin
                oup_o = 1'b1;
                if (inp_i == 1'b1) begin
                    state_d = High;
                end else if (cnt_q == NumCycles) begin
                    state_d = Low;
                end
            end

            default: begin
                state_d = Low;
            end
        endcase
    end

    always_ff @(posedge clk_i) begin
        if (~rst_ni) begin
            cnt_q   <= '0;
            state_q <= Low;
        end else begin
            cnt_q   <= cnt_d;
            state_q <= state_d;
        end
    end

endmodule
