module rgb_reg #(
    parameter integer WIDTH
) (
    input  logic                clk_i,
    input  logic                rst_ni,

    input  logic [WIDTH-1:0]    rgb_i,
    input  logic                hsync_i,
    input  logic                vsync_i,
    input  logic                vde_i,
    input  logic                valid_i,
    output logic                ready_o,

    output logic [WIDTH-1:0]    rgb_o,
    output logic                hsync_o,
    output logic                vsync_o,
    output logic                vde_o,
    output logic                valid_o,
    input  logic                ready_i
);

    logic [WIDTH-1:0]   rgb_d,          rgb_q;
    logic               hsync_d,        hsync_q,
                        vde_d,          vde_q,
                        vsync_d,        vsync_q;

    typedef enum logic {EMPTY, FULL} state_t;
    state_t         state_d,        state_q;

    always_comb begin
        hsync_d = hsync_q;
        rgb_d   = rgb_q;
        vde_d   = vde_q;
        vsync_d = vsync_q;
        valid_o = 1'b0;
        ready_o = 1'b0;
        state_d = state_q;

        case (state_q)
            EMPTY: begin
                ready_o = 1'b1;
                if (valid_i) begin
                    hsync_d = hsync_i;
                    rgb_d   = rgb_i;
                    vde_d   = vde_i;
                    vsync_d = vsync_i;
                    state_d = FULL;
                end
            end

            FULL: begin
                valid_o = 1'b1;
                if (ready_i) begin
                    // Because downstream is ready to accept, we are also ready to accept.
                    ready_o = 1'b1;
                    // If upstream data is valid, store it on the next clock edge.
                    if (valid_i) begin
                        hsync_d = hsync_i;
                        rgb_d   = rgb_i;
                        vde_d   = vde_i;
                        vsync_d = vsync_i;
                    // Otherwise, we become empty.
                    end else begin
                        state_d = EMPTY;
                    end
                end
            end

            default: state_d = EMPTY;
        endcase
    end

    always_ff @(posedge clk_i) begin
        if (~rst_ni) begin
            hsync_q <= 1'b0;
            rgb_q   <=   '0;
            state_q <= EMPTY;
            vde_q   <= 1'b0;
            vsync_q <= 1'b0;
        end else begin
            hsync_q <= hsync_d;
            rgb_q   <= rgb_d;
            state_q <= state_d;
            vde_q   <= vde_d;
            vsync_q <= vsync_d;
        end
    end

    assign hsync_o  = hsync_q;
    assign rgb_o    = rgb_q;
    assign vde_o    = vde_q;
    assign vsync_o  = vsync_q;

endmodule
