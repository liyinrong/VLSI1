/**
  * Verilog Wrapper for the Synchronous Reset Generator
  */

module rst_gen_wrap #(
    parameter integer RST_CLK_CYCLES = 10 // Verilog requires a default value.
) (
    input  clk_i,   // Referenc clock
    input  rst_ni,  // External active-low reset
    output rst_o,   // Active-high reset output
    output rst_no   // Active-low reset output
);

    rst_gen #(
        .RST_CLK_CYCLES (RST_CLK_CYCLES)
    ) i_rst_gen (
        .clk_i  (clk_i),
        .rst_ni (rst_ni),
        .rst_o  (rst_o),
        .rst_no (rst_no)
    );

endmodule
