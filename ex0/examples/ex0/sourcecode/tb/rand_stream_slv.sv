/** Randomizing Stream Slave
  */

module rand_stream_slv #(
    parameter type      data_t = logic, // Vivado requires a default value for type parameters.
    /// Minimum number of clock cycles to wait between applying two consecutive values.
    parameter integer   MIN_WAIT_CYCLES,
    /// Maximum number of clock cycles to wait between applying two consecutive values.
    parameter integer   MAX_WAIT_CYCLES,
    /// Application delay: time delay before ready output changes after an active clock edge.
    parameter time      APPL_DELAY,
    /// Acquisition delay: time delay before input is read after an active clock edge.
    parameter time      ACQ_DELAY,
    /// Store each input beat in an internal queue.
    parameter bit       ENQUEUE = 1'b1
) (
    input  logic    clk_i,
    input  logic    rst_ni,

    input  data_t   data_i,
    input  logic    valid_i,
    output logic    ready_o
);

    generate if (ENQUEUE) begin
        data_t queue[$];
        always @(posedge clk_i, negedge rst_ni) begin
            if (!rst_ni) begin
                queue = {};
            end else begin
                #(ACQ_DELAY);
                if (valid_i && ready_o) begin
                    queue.push_back(data_i);
                end
            end
        end
    end endgenerate

    rand_synch_driver #(
        .T                  (logic),
        .MIN_WAIT_CYCLES    (MIN_WAIT_CYCLES),
        .MAX_WAIT_CYCLES    (MAX_WAIT_CYCLES),
        .APPL_DELAY         (APPL_DELAY)
    ) i_ready_driver (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),
        .oup_o      (ready_o)
    );

endmodule
