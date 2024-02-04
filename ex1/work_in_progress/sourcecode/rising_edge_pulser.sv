/**
  * Rising-Edge Pulser
  *
  * Outputs `1` for a single clock cycle if the input switches from `0` to `1` between two clock
  * cycles.
  */

module rising_edge_pulser (
    input  logic clk_i,
    input  logic rst_ni,
    input  logic inp_i,
    output logic pulse_o
);

    logic prev_inp_d,       prev_inp_q;

    assign prev_inp_d = inp_i;
    assign pulse_o = (inp_i && !prev_inp_q);

    always_ff @(posedge clk_i) begin
        if (~rst_ni) begin
            prev_inp_q <= 1'b0;
        end else begin
            prev_inp_q <= prev_inp_d;
        end
    end

endmodule
