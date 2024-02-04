module filt_fsm (
    input  logic        clk_i,
    input  logic        rst_ni,

    input  logic        vsync_i,
    input  logic        hsync_i,
    input  logic        x_edge_i,
    input  logic        y_edge_i,
    output logic [3:0]  enable_o
);

    logic [3:0] enable_d, enable_q;

    assign enable_o = enable_q;

    always_comb begin
        enable_d = enable_q;
        if (vsync_i) begin
            enable_d = '0;
        end else begin
            if (y_edge_i) begin
                enable_d[3:2] = enable_q[3:2] + 1;
            end
            if (hsync_i) begin
                enable_d[1:0] = '0;
            end else if (x_edge_i) begin
                enable_d[1:0] = enable_q[1:0] + 1;
            end
        end
    end

    always_ff @(posedge clk_i, negedge rst_ni) begin
        if (!rst_ni) begin
            enable_q <= '0;
        end else begin
            enable_q <= enable_d;
        end
    end

endmodule
