// Copyright (c) 2022 Integrated Systems Laboratory, ETH Zurich
// Used for the VLSI 1 course
// 
// Author: Michael Rogenmoser <michaero@iis.ee.ethz.ch>

module fsm_counter (
  input  logic       clk_i,
  input  logic       rst_ni,

  input  logic       init_i,
  input  logic       hold_i,
  input  logic       direction_i,
  output logic [3:0] count_o
);

  // typedef enum logic[3:0] { 
  //   State0, State1, State2, State3, State4, State5, State6, State7, State8,
  //   State9, State10, State11, State12, State13, State14, State15
  // } states_e;

  // states_e state_d, state_q;
  logic [3:0] state_d, state_q;

  always_comb begin : count_FSM
    state_d = state_q;

    if (init_i) begin
      state_d = 4'b0000;
    end
    else if (~hold_i) begin
      if (direction_i) begin
        state_d = state_q - 1;
      end
      else begin
        state_d = state_q + 1;
      end
    end
    // case (state_q)
    //   State0: begin
    //     count_o = 4'b0000;
    //     state_d = State1;
    //   end

    //   State1: begin
    //     count_o = 4'b0001;
    //     state_d = State2;
    //   end

    //   State2: begin
    //     count_o = 4'b0010;
    //     state_d = State3;
    //   end

    //   State3: begin
    //     count_o = 4'b0011;
    //     state_d = State4;
    //   end

    //   State4: begin
    //     count_o = 4'b0100;
    //     state_d = State5;
    //   end

    //   State5: begin
    //     count_o = 4'b0101;
    //     state_d = State6;
    //   end

    //   State6: begin
    //     count_o = 4'b0110;
    //     state_d = State7;
    //   end

    //   State7: begin
    //     count_o = 4'b0111;
    //     state_d = State8;
    //   end

    //   State8: begin
    //     count_o = 4'b1000;
    //     state_d = State9;
    //   end

    //   State9: begin
    //     count_o = 4'b1001;
    //     state_d = State10;
    //   end

    //   State10: begin
    //     count_o = 4'b1010;
    //     state_d = State11;
    //   end

    //   State11: begin
    //     count_o = 4'b1011;
    //     state_d = State12;
    //   end

    //   State12: begin
    //     count_o = 4'b1100;
    //     state_d = State13;
    //   end

    //   State13: begin
    //     count_o = 4'b1101;
    //     state_d = State14;
    //   end

    //   State14: begin
    //     count_o = 4'b1110;
    //     state_d = State15;
    //   end

    //   State15: begin
    //     count_o = 4'b1111;
    //     state_d = State0;
    //   end
    // endcase
  end

  assign count_o = state_q;

  always_ff @(posedge clk_i or negedge rst_ni) begin : state_update
    if (!rst_ni) begin
      // state_q <= State0;
      state_q <= 4'b0000;
    end else begin
      state_q <= state_d;
    end
  end

endmodule
