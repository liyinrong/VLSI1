/// Stream multiplexer
///
/// Connects the output to one of `N_INP` data streams with valid-ready handshaking.

module stream_mux #(
    parameter type DATA_T = logic,  // Vivado requires a default value for type parameters.
    parameter integer N_INP,
    /// Dependent parameters, DO NOT OVERRIDE!
    localparam integer LOG_N_INP = $clog2(N_INP)
) (
    input  DATA_T [N_INP-1:0]       inp_data_i,
    input  logic  [N_INP-1:0]       inp_valid_i,
    output logic  [N_INP-1:0]       inp_ready_o,

    input  logic  [LOG_N_INP-1:0]   inp_sel_i,

    output DATA_T                   oup_data_o,
    output logic                    oup_valid_o,
    input  logic                    oup_ready_i
);

    always_comb begin
        inp_ready_o = '0;
        inp_ready_o[inp_sel_i] = oup_ready_i;
    end
    assign oup_data_o = inp_data_i[inp_sel_i];
    assign oup_valid_o = inp_valid_i[inp_sel_i];

endmodule
