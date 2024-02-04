/**
  * Clock Prescaler
  *
  * Reduces a clock frequency by integer division.  Use this module only if the output clock is very
  * slow (up to a few hundred Hz) and has very relaxed quality requirements (e.g., jitter);
  * otherwise, use dedicated clock manipulation resources.
  *
  * Maintainer: VLSI I Assistants <vlsi1@iis.ee.ethz.ch>
  */

module clock_prescaler #(
    // Integer clock divider; i.e., freq(clk_o) = freq(clk_i) / DIV, where DIV must be even.
    parameter unsigned Div
) (
    input  logic    clk_i,
    input  logic    rst_ni,
    output logic    clk_o
);

    generate if (Div <= 0) begin
        $fatal("Clock divison by zero not possible!");
    end else if (Div == 1) begin
        assign clk_o = rst_ni ? clk_i : 1'b0;
    end else if (Div % 2 != 0) begin
        $fatal("Clock division by uneven factor not supported!");
    end else begin: gen_clock_div_even_and_greater_than_two

        localparam unsigned Threshold = Div >> 1;
        localparam unsigned CntWidth = $clog2(Threshold);

        logic                   clk_d,  clk_q;
        logic [CntWidth-1:0]   cnt_d,  cnt_q;

        assign clk_d = (cnt_q == '0) ? ~clk_q : clk_q;

        assign cnt_d = (cnt_q < Threshold-1) ? cnt_q + 1 : '0;

        assign clk_o = clk_q;

        always_ff @(posedge clk_i) begin
            if (~rst_ni) begin
                clk_q <= 1'b0;
                cnt_q <= '0;
            end else begin
                clk_q <= clk_d;
                cnt_q <= cnt_d;
            end
        end

     end endgenerate

endmodule
