// Copyright (c) 2022 Integrated Systems Laboratory, ETH Zurich
// Used for the VLSI 1 course
// 
// Author: Marco Bertuletti <mbertuletti@iis.ee.ethz.ch>

module fsm (
  input   logic clk_i,
  input   logic rst_ni,
  output  logic add_o,
  output  logic cnst_sel_o,
  output  logic clr_count_o,
  output  logic clr_accu_o,
  input   logic [4:0] count_i,
  input   logic [15:0] add_cnst_i);

  // Definition of states
  typedef enum logic [2:0] {
    One,
    Two,
    Three,
    Four
  } fsm_state_e;
  fsm_state_e state_q, state_d;


  always_comb begin : proc_next_state
    add_o = 1'b0;
    cnst_sel_o = 1'b0;
    clr_count_o = 1'b0;
    clr_accu_o = 1'b0;
    state_d = state_q;

    case (state_q)
      One : begin
        state_d = Two;                 // directly move to state two
        cnst_sel_o = 1'b1;             // select constant -1
        clr_count_o = 1'b1;            // reset the counter
        clr_accu_o = 1'b1;
      end

      Two : begin
        cnst_sel_o = 1'b1;             // select constant -1
        if (count_i > 5'd4)               // after count reaches at least 5
          state_d = Three;             // move to state three
      end

      Three : begin
        add_o = 1'b1;                  // Start adding
        if (count_i > 5'd9)               // after count reaches at least 10
          state_d = Four;            // move to state four
      end

      Four : begin
        add_o = 1'b1;                  // Continue adding
        if (add_cnst_i == 16'b0) begin
          state_d = Two;
        end
        else begin
          state_d = One;                // Move to state one directly
        end
      end

      // default :                     // Default: do nothing
    endcase
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin : proc_state_ff
    if(~rst_ni) begin                        // Asynchronous reset (active low)
      state_q <= One;                        // Default state is 'one'
    end else begin
      state_q <= state_d;                    // Next state copied to present state
    end
  end

endmodule
