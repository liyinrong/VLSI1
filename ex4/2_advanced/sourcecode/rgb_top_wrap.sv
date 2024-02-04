module rgb_top_wrap (
    input  logic        clk_i,
    input  logic        rst_ni,
    input  logic        en_i,
    // Input signals and handshaking
    input  logic [7:0]  r_i,
    input  logic [7:0]  g_i,
    input  logic [7:0]  b_i,
    input  logic        valid_i,
    output logic        ready_o,
    // Output signals and handshaking
    output logic [7:0]  r_o,
    output logic [7:0]  g_o,
    output logic [7:0]  b_o,
    input  logic        ready_i,
    output logic        valid_o
);

    // Declaration of internal signals
    typedef struct packed {
        logic [7:0] r,g,b;
    } rgb_t;

    rgb_t   inp_d, inp_q, // Input stage register
            oup_d, oup_q, // Output stage register
            sat;

    logic   inp_full_d, inp_full_q, // Input register state
            oup_full_d, oup_full_q, // Output register state
            valid,      ready,      // Internal handshaking
            en_d,       en_q;       // Register for filter enable

    logic [7:0] gray;

    rgb_grayscaler i_rgb_gray (
        .en_i   ( en_q    ),
        .r_i    ( inp_q.r ),
        .g_i    ( inp_q.g ),
        .b_i    ( inp_q.b ),
        .gray_o ( gray    )
    );

    rgb_saturator i_rgb_sat (
        .en_i   ( en_q    ),
        .r_i    ( inp_q.r ),
        .g_i    ( inp_q.g ),
        .b_i    ( inp_q.b ),
        .gy_i   ( gray    ),
        .r_o    ( sat.r   ),
        .g_o    ( sat.g   ),
        .b_o    ( sat.b   )
    );

    // Input Register
    // =================
    //             ______
    //   valid_i  |      |  valid
    // ---------->|      |-------->
    //            |      |
    //   ready_o  |      |  ready
    // <----------|      |<--------
    //            |__/\__|

    // Register is valid if it contains data
    assign valid = inp_full_q;

    always_comb begin
        // Keep register value by default
        inp_d      = inp_q;
        en_d       = en_q;
        inp_full_d = inp_full_q;
        // Be ready to accept new data by default
        ready_o    = 1'b1;

        if (inp_full_q) begin
            // Register holds data
            // --> ready if simultaneously drained by next stage
            ready_o = ready;
            if (ready) begin
                // Register is drained
                // --> Check if simultaneously filled
                if (valid_i) begin
                    // And simultaneously filled
                    inp_d = {r_i, g_i, b_i};
                    en_d  = en_i;
                end else begin
                    // Register is drained but not filled --> empty
                    inp_full_d = 1'b0;
                end
            end
        end else begin
            // Register is empty --> We can accept new data if the input is valid
            ready_o    = 1'b1;
            if (valid_i) begin
                inp_d      = {r_i, g_i, b_i};
                en_d       = en_i;
                inp_full_d = 1'b1;
            end
        end
    end


    // Output Register
    // =================
    //           ______
    //   valid  |      |  valid_o
    // -------->|      |---------->
    //          |      |
    //   ready  |      |  ready_i
    // <--------|      |<----------
    //          |__/\__|

    // Unpack the output of the register
    assign {r_o, g_o, b_o} = oup_q;
    // Register is valid if it contains data
    assign valid_o         = oup_full_q;

    always_comb begin
        // Keep register value by default
        oup_d      = oup_q;
        oup_full_d = oup_full_q;
        // Be ready to accept new data by default
        ready      = 1'b1;

        if (oup_full_q) begin
            // Register holds data
            // --> ready if simultaneously drained by next stage
            ready = ready_i;
            if (ready_i) begin
                // Register is drained
                // --> Check if simultaneously filled
                if (valid) begin
                    // And simultaneously filled
                    oup_d = sat;
                end else begin
                    // Register is drained but not filled --> empty
                    oup_full_d = 1'b0;
                end
            end
        end else begin
            // Register is empty --> We can accept new data if the previous stage is valid
            ready = 1'b1;
            if (valid) begin
                oup_d = sat;
                oup_full_d = 1'b1;
            end
        end
    end

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if(~rst_ni) begin
            inp_q      <= '0;
            en_q       <= '0;
            oup_q      <= '0;
            inp_full_q <= '0;
            oup_full_q <= '0;
        end else begin
            inp_q      <= inp_d;
            en_q       <= en_d;
            oup_q      <= oup_d;
            inp_full_q <= inp_full_d;
            oup_full_q <= oup_full_d;
        end
    end

    // Assertions
    // TODO: Add concurrent assertions
    property inp_handshake;
        @(posedge clk_i) disable iff (~rst_ni)
        valid_i && !ready_o |=> $stable({r_i, g_i, b_i});
    endproperty
    property int_handshake;
        @(posedge clk_i) disable iff (~rst_ni)
        valid && !ready |=> $stable(inp_q);
    endproperty
    property oup_handshake;
        @(posedge clk_i) disable iff (~rst_ni)
        valid_o && !ready_i |=> $stable({r_o, g_o, b_o});
    endproperty

    assert property(inp_handshake)
    else begin
        $error("r_i, g_i, b_i not stable while ready_o is 0.");
    end
    assert property(int_handshake)
    else begin
        $error("inp_q not stable while ready is 0.");
    end
    assert property(oup_handshake)
    else begin
        $error("r_o, g_o, b_o not stable while ready_i is 0.");
    end
    // TODO: Add coverage assertions
    cover property(@(posedge clk_i) &{valid_i, ready_o, valid, ready, valid_o, ready_i});
    cover property(@(posedge clk_i) &{valid_i, ready_o, valid, ready, valid_o, ready_i} [*3:$]);

endmodule
