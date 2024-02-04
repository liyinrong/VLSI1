/**
  * Track the vertical (i.e., y-direction) position in a pixel stream and raise a signal at the end
  * of each of a configurable number of sections.
  */
module y_counter #(
    parameter integer Y_RESOLUTION,
    parameter integer Y_NUM_SECTIONS
) (
    input  logic    clk_i,
    input  logic    rst_ni,

    input  logic    valid_i,
    input  logic    ready_i,
    input  logic    hsync_i,
    input  logic    vsync_i,

    output logic    y_edge_o
);

    logic [31:0]    y_count_d,  y_count_q;

    logic           hsync_d,    hsync_q,
                    y_edge_d,   y_edge_q;

    // TODO y_counter code

    // END TODO

endmodule
