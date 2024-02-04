module tb ();

    timeunit 1ns;
    timeprecision 1ps;

    logic       active_d,   active_q1,  active_q2,  active_q3,  active_q4,
                clk;

    logic       btn;

    logic       i_dat,
                led3_actual, led3_expected;

    logic [3:0] led;

    int         rand_delay;

    logic       queue[$];

    zybo_top #(
        .ClkDiv            (20),
        .DebounceCycles    (5)
    ) uut (
        .clk_i  (clk),
        .btn_i  (btn),
        .led_o  (led)
    );

    assign btn          = i_dat;
    assign led3_actual = led[3];

    initial begin
        clk     = 0;
        i_dat   = 0;
        #100;
        forever begin
            // long term variation
            rand_delay = $urandom_range(4, 7);
            repeat(rand_delay) begin
                @(posedge uut.slow_clk);
            end
            //debounce
            rand_delay = 3;
            repeat(rand_delay) begin
                @(posedge clk);
                i_dat <= ~i_dat;
            end
        end
    end

    initial begin
        active_d    <= 1'b0;
        active_q1   <= 1'b0;
        active_q2   <= 1'b0;
        active_q3   <= 1'b0;
        active_q4   <= 1'b0;
        @(posedge uut.slow_clk);
        active_d    <= 1'b1;
    end

    always @(posedge uut.slow_clk) begin
        active_q1 <= active_d;
        active_q2 <= active_q1;
        active_q3 <= active_q2;
        active_q4 <= active_q3;
    end

    always @(posedge uut.slow_clk) begin
        if (active_d) begin
            queue.push_front(uut.w_d);
        end
    end

    always @(posedge uut.slow_clk) begin
        if (active_q4) begin
            led3_expected = queue.pop_back;
            if (led3_expected == led3_actual) begin
                $display("Output correct.");
            end else begin
                $display("Output mismatch!");
                $stop();
            end
        end
    end

     initial begin
         #3000ns;
         $display("simulation done");
         $stop;
     end

    // Toggle clock.
    always begin
        clk = #2 ~clk;
    end

endmodule
