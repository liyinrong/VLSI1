/// Stream multiplexer
///
/// Connects the output to one of `NumInp` data streams with valid-ready handshaking.

module stream_mux #(
    parameter type data_t = logic,  // Vivado requires a default value for type parameters.
    parameter integer NumInp,
    /// Dependent parameters, DO NOT OVERRIDE!
    localparam integer LogNumInp = $clog2(NumInp)
) (
    input  data_t [NumInp-1:0]       inp_data_i,
    input  logic  [NumInp-1:0]       inp_valid_i,
    output logic  [NumInp-1:0]       inp_ready_o,

    input  logic  [LogNumInp-1:0]   inp_sel_i,

    output data_t                   oup_data_o,
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
