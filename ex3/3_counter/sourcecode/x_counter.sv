/**
  * Track the horizontal (i.e., x-direction) position in a pixel stream and raise a signal at the
  * end of each of a configurable number of sections.
  */
module x_counter #(
    parameter integer XResolution,
    parameter integer XNumSections
) (
    input  logic    clk_i,
    input  logic    rst_ni,

    input  logic    valid_i,
    input  logic    ready_i,
    input  logic    hsync_i,
    input  logic    vde_i,

    // Is high when the current pixel the last in an horizontal region
    output logic    x_edge_o
);

    logic [31:0]    x_count_d,  x_count_q;
    logic           x_edge_d,   x_edge_q;

    // TODO: Implement x_count_q and x_edge_q registers
    always_ff @(posedge clk_i) begin
        if(~rst_ni) begin
            x_count_q <= 32'b0;
            x_edge_q <= 1'b0;
        end
        else begin
            x_count_q <= x_count_d;
            x_edge_q <= x_edge_d;
        end
    end

    // TODO: Implement x_count_d and x_edge_d code
    always_comb begin
        x_count_d = x_count_q;
        x_edge_d = 1'b0;
        if(valid_i && ready_i) begin
            if(hsync_i) begin
                x_count_d = 32'b0;
            end
            else if(vde_i) begin
                x_count_d = x_count_q + 32'd1;
                if(x_count_d == (XResolution/XNumSections)) begin
                    x_count_d = 32'b0;
                    x_edge_d = 1'b1;
                end
            end
        end
    end

    assign x_edge_o = x_edge_q;

endmodule
