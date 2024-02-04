/** Randomizing Synchronous Driver
  */
module rand_synch_driver #(
    parameter type      T = logic,  // Vivado requires a default value for type parameters.
    /// Minimum number of clock cycles to wait between applying two consecutive values.
    parameter integer   MinWaitCycles,
    /// Maximum number of clock cycles to wait between applying two consecutive values.
    parameter integer   MaxWaitCycles,
    /// Application delay: time delay before output changes after an active clock edge.
    parameter time      ApplDelay
) (
    input  logic    clk_i,
    input  logic    rst_ni,
    output T        oup_o
);

    rand_synch_holdable_driver #(
        .T                (T),
        .MinWaitCycles    (MinWaitCycles),
        .MaxWaitCycles    (MaxWaitCycles),
        .ApplDelay        (ApplDelay)
    ) i_driver (
        .clk_i  (clk_i),
        .rst_ni (rst_ni),
        .hold_i (1'b0),
        .oup_o  (oup_o)
    );

endmodule
