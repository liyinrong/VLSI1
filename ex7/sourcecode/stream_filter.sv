module stream_filter (
    input  logic valid_i,
    output logic ready_o,
    input  logic drop_i,
    output logic valid_o,
    input  logic ready_i
);

    assign valid_o = drop_i ? 1'b0 : valid_i;
    assign ready_o = drop_i ? 1'b1 : ready_i;

endmodule
