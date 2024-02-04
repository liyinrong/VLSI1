/**
  * Track the horizontal (i.e., x-direction) position in a pixel stream and raise a signal at the
  * end of each of a configurable number of sections.
  */
module x_counter #(
    parameter integer X_RESOLUTION,
    parameter integer X_NUM_SECTIONS
) (
    input  logic    clk_i,
    input  logic    rst_ni,

    input  logic    valid_i,
    input  logic    ready_i,
    input  logic    hsync_i,
    input  logic    vde_i,

    output logic    x_edge_o
);

    logic [31:0]    x_count_d,  x_count_q;
    logic           x_edge_d,   x_edge_q;

    // TODO x_counter code

    // END TODO

endmodule
