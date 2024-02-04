/// Stream demultiplexer
///
/// Connects the input stream (valid-ready) handshake to one of `NumOup` output stream handshakes.
/// The data does not need to be demultiplexed (because the data of the input stream can just be
/// applied at all output streams), so this module has no data ports.

module stream_demux #(
    parameter integer NumOup,
    /// Dependent parameters, DO NOT OVERRIDE!
    localparam integer LogNumOup = $clog2(NumOup)
) (
    input  logic                    inp_valid_i,
    output logic                    inp_ready_o,

    input  logic  [LogNumOup-1:0]   oup_sel_i,

    output logic  [NumOup-1:0]      oup_valid_o,
    input  logic  [NumOup-1:0]      oup_ready_i
);

    always_comb begin
        oup_valid_o = '0;
        oup_valid_o[oup_sel_i] = inp_valid_i;
    end
    assign inp_ready_o = oup_ready_i[oup_sel_i];

endmodule
