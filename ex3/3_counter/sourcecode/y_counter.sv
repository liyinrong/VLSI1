/**
  * Track the vertical (i.e., y-direction) position in a pixel stream and raise a signal at the end
  * of each of a configurable number of sections.
  */
module y_counter #(
    parameter integer YResolution,
    parameter integer YNumSections
) (
    input  logic    clk_i,
    input  logic    rst_ni,

    input  logic    valid_i,
    input  logic    ready_i,
    input  logic    hsync_i,
    input  logic    vsync_i,

    // Is high when the next pixel is in a new vertical region
    output logic    y_edge_o
);

    logic [31:0]    y_count_d,  y_count_q;
    logic           hsync_sampled_d, hsync_sampled_q;
    logic           y_edge_d, y_edge_q;


    // TODO: Implement registers
    always_ff @(posedge clk_i) begin
        if(~rst_ni) begin
            y_count_q <= 32'b0;
            hsync_sampled_q <= 1'b0;
            y_edge_q <= 1'b0;
        end
        else begin
            y_count_q <= y_count_d;
            hsync_sampled_q <= hsync_sampled_d;
            y_edge_q <= y_edge_d;
        end
    end

    // TODO: Implement y_count_d, y_edge_d and hsync_sampled_d code
    assign hsync_sampled_d = (valid_i && ready_i) ? hsync_i : hsync_sampled_q;

    always_comb begin
        y_count_d = y_count_q;
        y_edge_d = 1'b0;
        if(valid_i && ready_i) begin
            if(vsync_i) begin
                y_count_d = 32'b0;
            end
            else if(hsync_sampled_d & ~hsync_sampled_q) begin
                y_count_d = y_count_q + 32'd1;
                if(y_count_d == (YResolution/YNumSections)) begin
                    y_count_d = 32'b0;
                    y_edge_d = 1'b1;
                end
            end
        end
    end

    assign y_edge_o = y_edge_q;

endmodule
