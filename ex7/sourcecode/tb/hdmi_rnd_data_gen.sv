module hdmi_rnd_data_gen #(
    parameter integer XResolution  = 1920,
    parameter integer YResolution  = 1080,
    parameter time    ApplDelay    = 2,
    parameter time    AcqDelay     = 2
) (
    input  logic            clk_i,
    input  logic            rst_ni,
    output logic            valid_o,
    input  logic            ready_i,
    output logic  [23:0]    data_o,
    output logic            vsync_o,
    output logic            hsync_o,
    output logic            vde_o
);

    localparam integer HdmiHFront = 88;
    localparam integer HdmiHSync  = 44;
    localparam integer HdmiHBack  = 148;
    localparam integer HdmiVFront = 4;
    localparam integer HdmiVSync  = 5;
    localparam integer HdmiVBack  = 36;

    localparam integer CycleXFront = XResolution;
    localparam integer CycleXSync  = CycleXFront + HdmiHFront;
    localparam integer CycleXBack  = CycleXSync  + HdmiHSync;
    localparam integer CycleXMax   = CycleXBack  + HdmiHBack;

    localparam integer CycleYFront = YResolution;
    localparam integer CycleYSync  = CycleYFront + HdmiVFront;
    localparam integer CycleYBack  = CycleYSync  + HdmiVSync;
    localparam integer CycleYMax   = CycleYBack  + HdmiVBack;

    typedef enum {Pixel, Hblank, Vblank} pic_state_t;

    pic_state_t pic_state_d,    pic_state_q;

    integer     x_addr_d,       x_addr_q,
                y_addr_d,       y_addr_q;

    logic [23:0]     rgb_gen;

    assign data_o = rgb_gen;

    // Randomizing Video Input Master
    rand_stream_mst #(
        .data_t         (logic[23:0]),
        .MinWaitCycles  (0),
        .MaxWaitCycles  (3),
        .ApplDelay      (ApplDelay),
        .AcqDelay       (AcqDelay)
    ) i_inp_mst (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),

        .data_o     ({rgb_gen}),
        .valid_o    (valid_o),
        .ready_i    (ready_i)
    );

    // Pixel coordinate counter.
    always_comb begin
        x_addr_d = x_addr_q;
        y_addr_d = y_addr_q;
        if (valid_o && ready_i) begin
            if (x_addr_q == CycleXMax-1) begin
                x_addr_d = 0;
                if (y_addr_q == CycleYMax-1) begin
                    y_addr_d = 0;
                end else begin
                    y_addr_d = y_addr_q + 1;
                end
            end else begin
                x_addr_d = x_addr_q + 1;
            end
        end
    end

    // Generate the control signals.
    assign vde_o = (x_addr_q < CycleXFront && y_addr_q < CycleYFront);
    assign hsync_o = (x_addr_q >= CycleXSync && x_addr_q < CycleXBack);
    assign vsync_o = (y_addr_q >= CycleYSync && y_addr_q < CycleYBack);

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            x_addr_q <= CycleXFront - XResolution/2;
            y_addr_q <= CycleYFront - YResolution/20;
        end else begin
            x_addr_q <= x_addr_d;
            y_addr_q <= y_addr_d;
        end
    end

endmodule
