/**
  * TODO: header
  */

module pulse_width_modulator #(
    parameter integer Period
) (
    input  logic                        clk_i,
    input  logic                        rst_ni,
    input  logic [$clog2(Period)-1:0]   active_i,
    output logic                        oup_o
);

    // Define constants.
    localparam integer CntBitw = $clog2(Period);

    // Define signals.
    logic [CntBitw-1:0]    cnt_q,          cnt_d;

    assign cnt_d = (cnt_q < Period-1) ? cnt_q + 1 : '0;

    always_comb begin
        if (active_i == '0) begin
            oup_o = 1'b0;
        end else begin
            oup_o = (cnt_q <= active_i);
        end
    end

    always_ff @(posedge clk_i) begin
        if (~rst_ni) begin
            cnt_q <= '0;
        end else begin
            cnt_q <= cnt_d;
        end
    end

endmodule
