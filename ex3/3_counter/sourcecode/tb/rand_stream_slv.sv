/** Randomizing Stream Slave
  */

module rand_stream_slv #(
    parameter type      data_t = logic, // Vivado requires a default value for type parameters.
    /// Minimum number of clock cycles to wait between applying two consecutive values.
    parameter integer   MinWaitCycles,
    /// Maximum number of clock cycles to wait between applying two consecutive values.
    parameter integer   MaxWaitCycles,
    /// Application delay: time delay before ready output changes after an active clock edge.
    parameter time      ApplDelay,
    /// Acquisition delay: time delay before input is read after an active clock edge.
    parameter time      AcqDelay,
    /// Store each input beat in an internal queue.
    parameter bit       Enqueue = 1'b1
) (
    input  logic    clk_i,
    input  logic    rst_ni,

    input  data_t   data_i,
    input  logic    valid_i,
    output logic    ready_o
);

    generate if (Enqueue) begin
        data_t queue[$];
        always @(posedge clk_i, negedge rst_ni) begin
            if (!rst_ni) begin
                queue = {};
            end else begin
                #(AcqDelay);
                if (valid_i && ready_o) begin
                    queue.push_back(data_i);
                end
            end
        end
    end endgenerate

    rand_synch_driver #(
        .T                  (logic),
        .MinWaitCycles      (MinWaitCycles),
        .MaxWaitCycles      (MaxWaitCycles),
        .ApplDelay          (ApplDelay)
    ) i_ready_driver (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),
        .oup_o      (ready_o)
    );

endmodule
