module hdmi_sync_gen #(
    parameter integer   XResolution,
    parameter integer   YResolution,
    parameter time      ApplDelay      // Stimulus application delay
) (
    input  logic    clk_i,
    input  logic    rst_ni,
    output logic    vsync_o,
    output logic    hsync_o,
    output logic    vde_o
);

    typedef enum {Pixel, Hblank, Vblank} pic_state_t;

    pic_state_t pic_state_d,    pic_state_q;

    integer     x_addr_d,       x_addr_q,
                y_addr_d,       y_addr_q;

    logic       hsync_d,        hsync_q,
                vsync_d,        vsync_q,
                vde_d,          vde_q;

    always_comb begin
        hsync_d     = 1'b0;
        pic_state_d = pic_state_q;
        vde_d       = 1'b0;
        vsync_d     = 1'b0;
        x_addr_d    = x_addr_q;
        y_addr_d    = y_addr_q;

        case (pic_state_q)
            Pixel: begin
                x_addr_d += 1;
                if (x_addr_q == XResolution) begin
                    x_addr_d = 0;
                    pic_state_d = Hblank;
                end else begin
                    vde_d = 1'b1;
                end
            end

            Hblank: begin
                if (x_addr_q == 10) begin
                    x_addr_d = 0;
                    if (y_addr_q == YResolution) begin
                        pic_state_d = Vblank;
                    end else begin
                        y_addr_d += 1;
                        pic_state_d = Pixel;
                    end
                end else begin
                    hsync_d = 1'b1;
                    x_addr_d += 1;
                end
            end

            Vblank: begin
                if (x_addr_q == 10) begin
                    x_addr_d = 0;
                    y_addr_d = 0;
                    pic_state_d = Pixel;
                end else begin
                    x_addr_d += 1;
                    hsync_d = 1'b1;
                    vsync_d = 1'b1;
                end
            end

            default: begin
                pic_state_d = Pixel;
            end
        endcase
    end

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            hsync_q     <= 1'b0;
            pic_state_q <= Pixel;
            vde_q       <= 1'b0;
            vsync_q     <= 1'b0;
            x_addr_q    <= 0;
            y_addr_q    <= 0;
        end else begin
            hsync_q     <= hsync_d;
            pic_state_q <= pic_state_d;
            vde_q       <= vde_d;
            vsync_q     <= vsync_d;
            x_addr_q    <= x_addr_d;
            y_addr_q    <= y_addr_d;
        end
    end

    assign #ApplDelay hsync_o  = hsync_q;
    assign #ApplDelay vsync_o  = vsync_q;
    assign #ApplDelay vde_o    = vde_q;

endmodule
