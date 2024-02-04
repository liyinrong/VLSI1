/** Randomizing Synchronous Holdable Driver
  */
module rand_synch_holdable_driver #(
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
    input  logic    hold_i,
    output T        oup_o
);

    timeunit 1ns;
    timeprecision 10ps;

    if (MaxWaitCycles < MinWaitCycles) begin
        $error("MaxWaitCycles must be >= MinWaitCycles!");
    end

    int unsigned rand_delay, rand_success;

    initial begin
        oup_o = '0;
        wait (rst_ni);
        @(posedge clk_i);
        forever begin
            rand_success = std::randomize(rand_delay) with {
                rand_delay >= MinWaitCycles;
                rand_delay <= MaxWaitCycles;
            };
            assert(rand_success) else $error("Failed to randomize wait cycles!");
            repeat(rand_delay) begin
                @(posedge clk_i);
            end
            #(ApplDelay);
            if (!hold_i) begin
                void'(std::randomize(oup_o));
            end
        end
    end

endmodule
