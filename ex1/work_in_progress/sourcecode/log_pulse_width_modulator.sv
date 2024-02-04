/**
  * TODO: header
  */

module log_pulse_width_modulator #(
    parameter integer LogPeriod
) (
    input  logic                            clk_i,
    input  logic                            rst_ni,
    input  logic [$clog2(LogPeriod)-1:0]   log_active_i,
    output logic                            oup_o
);

    // Define constants.
    localparam integer Period = 1 << LogPeriod;

    // Define signals.
    logic [LogPeriod-1:0]  active;

    // Determine the `active` value by shifting constant 1 to the left (equivalent to binary
    // exponentiation) and subtracting 1 from the result.
    always_comb begin
        // The result of the left shift must be wide enough to not overflow, and the bit length of
        // the result of a left shift is the bit length of its left operand.  In our case, the left
        // operand is a constant 1.  Thus, we define a local signal `const_1` that is wide
        // `LogPeriod` wide, which is how far we can shift at most.
        static logic [LogPeriod:0] const_1 = 1;
        active = (const_1 << log_active_i) - 1;
    end

    pulse_width_modulator #(
        .Period (Period)
    ) i_pwm (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),
        .active_i   (active),
        .oup_o      (oup_o)
    );

endmodule
