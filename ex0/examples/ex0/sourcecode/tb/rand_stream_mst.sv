/** Randomizing Stream Master
  */
module rand_stream_mst #(
    parameter type      data_t = logic, // Vivado requires a default value for type parameters.
    /// Minimum number of clock cycles to wait between applying two consecutive values.
    parameter integer   MIN_WAIT_CYCLES,
    /// Maximum number of clock cycles to wait between applying two consecutive values.
    parameter integer   MAX_WAIT_CYCLES,
    /// Application delay: time delay before output changes after an active clock edge.
    parameter time      APPL_DELAY,
    /// Acquisition delay: time delay before ready input is read after an active clock edge.
    parameter time      ACQ_DELAY
) (
    input  logic    clk_i,
    input  logic    rst_ni,

    output data_t   data_o,
    output logic    valid_o,
    input  logic    ready_i
);

    timeunit 1ns;
    timeprecision 10ps;

    if (MAX_WAIT_CYCLES < MIN_WAIT_CYCLES) begin: check_param_wait_cycles
        $error("MAX_WAIT_CYCLES must be >= MIN_WAIT_CYCLES!");
    end

    if (APPL_DELAY > ACQ_DELAY) begin: check_param_delay
        $error("APPL_DELAY must be <= ACQ_DELAY!");
    end

    int unsigned rand_wait_cycles;

    function static void randomize_wait_cycles();
        int unsigned rand_success;
        rand_success = std::randomize(rand_wait_cycles) with {
            rand_wait_cycles >= MIN_WAIT_CYCLES;
            rand_wait_cycles <= MAX_WAIT_CYCLES;
        };
        assert(rand_success) else $error("Failed to randomize wait cycles!");
    endfunction

    initial begin
        data_o  = '0;
        valid_o = 1'b0;
        wait (rst_ni);
        // Initially pick a random number of cycles to wait until we offer the first valid data.
        randomize_wait_cycles();
        @(posedge clk_i);
        forever begin
            // Wait for the picked number of clock cycles.
            repeat(rand_wait_cycles) begin
                @(posedge clk_i);
            end
            // Delay application of data and valid output.
            #(APPL_DELAY);
            // Randomize data output and set valid output.
            void'(std::randomize(data_o));
            valid_o = 1'b1;
            // Delay acquisition of ready signal.  ACQ_DELAY is relative to the clock edge, and we
            // have already waited for APPL_DELAY in this edge, so we need to subtract APPL_DELAY.
            #(ACQ_DELAY-APPL_DELAY);
            // Sample the ready input.  While the slave is not ready, wait a clock cycle plus the
            // acquisition delay and resample the ready input.
            while (!ready_i) begin
                @(posedge clk_i);
                #(ACQ_DELAY);
            end
            // The slave is ready to acquire data on the next rising edge, so we pick a new number
            // of cycles to wait until we offer the next valid data.
            randomize_wait_cycles();
            if (rand_wait_cycles == 0) begin
                // If we have to wait 0 cycles, we apply new data directly after next clock edge
                // plus the application delay.
                @(posedge clk_i);
            end else begin
                // If we have to wait more than 0 cycles, we unset the valid output and randomize
                // the data output after the next clock edge plus the application delay.
                @(posedge clk_i);
                #(APPL_DELAY);
                valid_o = 1'b0;
                void'(std::randomize(data_o));
            end
        end
    end

endmodule
