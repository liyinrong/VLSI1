
module filt_fsm (
    input  logic        clk_i,
    input  logic        rst_ni,

    input  logic        hop_i,
    input  logic        toggle_i,

    output logic [3:0]  enable_o
);

    // TODO : Edge detector for p_hop and p_toggle
    logic hop_d, hop_q, p_hop;
    logic toggle_d, toggle_q, p_toggle;

    assign hop_d = hop_i;
    assign toggle_d = toggle_i;

    always_ff @(posedge clk_i) begin
        if(~rst_ni) begin
            hop_q <= 1'b0;
            toggle_q <= 1'b0;
        end
        else begin
            hop_q <= hop_d;
            toggle_q <= toggle_d;
        end
    end

    assign p_hop = hop_d & ~hop_q;
    assign p_toggle = toggle_d & ~toggle_q;

    // TODO : Declare the states of your FSM
    typedef enum logic [1:0] {Pos0, Pos1, Pos2, Pos3} state_t;

    // TODO : Instantiate the state register
    state_t pos_state_d, pos_state_q;
    logic [3:0] en_state_d, en_state_q;

    always_ff @(posedge clk_i) begin
        if(~rst_ni) begin
            pos_state_q <= Pos0;
            en_state_q <= 4'b0;
        end
        else begin
            pos_state_q <= pos_state_d;
            en_state_q <= en_state_d;
        end
    end

    // TODO : Combinational logic determining the next state
    always_comb begin
        pos_state_d = pos_state_q;
        en_state_d = en_state_q;
        case (pos_state_q)
            Pos0: begin
                if(p_hop) begin
                    pos_state_d = Pos1;
                end
                if(p_toggle) begin
                    en_state_d = en_state_q ^ 4'b0001;
                end 
            end
            Pos1: begin
                if(p_hop) begin
                    pos_state_d = Pos2;
                end
                if(p_toggle) begin
                    en_state_d = en_state_q ^ 4'b0010;
                end 
            end
            Pos2: begin
                if(p_hop) begin
                    pos_state_d = Pos3;
                end
                if(p_toggle) begin
                    en_state_d = en_state_q ^ 4'b0100;
                end 
            end
            Pos3: begin
                if(p_hop) begin
                    pos_state_d = Pos0;
                end
                if(p_toggle) begin
                    en_state_d = en_state_q ^ 4'b1000;
                end 
            end
        endcase
    end

    // TODO : Enable logic based on the current state
    assign enable_o = en_state_q;

endmodule
