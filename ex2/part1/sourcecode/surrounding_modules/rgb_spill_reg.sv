module rgb_spill_reg #(
    parameter integer Width
) (
    input  logic                clk_i,
    input  logic                rst_ni,

    input  logic [Width-1:0]    rgb_i,
    input  logic                hsync_i,
    input  logic                vsync_i,
    input  logic                vde_i,
    input  logic                valid_i,
    output logic                ready_o,

    output logic [Width-1:0]    rgb_o,
    output logic                hsync_o,
    output logic                vsync_o,
    output logic                vde_o,
    output logic                valid_o,
    input  logic                ready_i
);

    typedef logic [Width+3-1:0]   reg_data_t;

    reg_data_t  reg_inp,
                reg_oup;

    assign reg_inp  = {rgb_i, hsync_i, vsync_i, vde_i};
    assign rgb_o    = reg_oup[Width+3-1:3];
    assign hsync_o  = reg_oup[2];
    assign vsync_o  = reg_oup[1];
    assign vde_o    = reg_oup[0];

    spill_register #(
        .T  (reg_data_t)
    ) i_spill_register (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),
        .valid_i    (valid_i),
        .ready_o    (ready_o),
        .data_i     (reg_inp),
        .valid_o    (valid_o),
        .ready_i    (ready_i),
        .data_o     (reg_oup)
    );

endmodule
