// Copyright (c) 2022 Integrated Systems Laboratory, ETH Zurich
// Used for the VLSI 1 course
// 
// Author: Marco Bertuletti <mbertuletti@iis.ee.ethz.ch>

module simpler_fsm (
  input  logic clk_i,
  input  logic rst_ni,
  input  logic[15:0] in_i,
  output logic[15:0] out_o
);

  logic[15:0] cnst;
  logic[15:0] add_cnst;
  logic[15:0] add_sub;
  logic[15:0] accu_q, accu_d;
  logic[15:0] count_q, count_d;

  logic add;
  logic cnst_sel;
  logic clr_count;
  logic clr_accu;

  // Definition of states
  typedef enum logic [2:0] {
    One,
    Two,
    Three,
    Four
  } fsm_state_e;
  fsm_state_e state_q, state_d;

  assign cnst = (cnst_sel == 0) ? {15'b0, 1'b1} : {16{1'b1}};
  assign add_cnst = in_i + cnst;
  assign add_sub = (add == 1'b1) ? (add_cnst + accu_q) : (add_cnst - accu_q);
  assign accu_d = clr_accu ? 16'b0 : add_sub;

  always_comb begin
    count_d = count_q;
    if (clr_count == 1'b1) begin
      count_d = 5'd0;
    end else if (count_q == 5'd15) begin
      count_d = 5'd0;
    end else begin
      count_d = count_q + 1;
    end
  end

  always_comb begin : proc_next_state
    add = 1'b0;
    cnst_sel = 1'b0;
    clr_count = 1'b0;
    clr_accu = 1'b0;
    state_d = state_q;

    case (state_q)
      One : begin
        state_d = Two;               // directly move to state Two
        cnst_sel = 1'b1;             // select constant -1
        clr_count = 1'b1;            // reset the counter
        clr_accu = 1'b1;
      end

      Two : begin
        cnst_sel = 1'b1;             // select constant -1
        if (count_q > 5'd4)             // after count reaches at least 5
          state_d = Three;           // move to state Three
      end

      Three : begin
        add = 1'b1;                  // Start adding
        if (count_q > 5'd9)             // after count reaches at least 9
          state_d = Four;          // move to state Four
      end

      Four : begin
        add = 1'b1;                  // Continue adding
        if (add_cnst == 16'b0) begin
          state_d = Two;
        end
        else begin
          state_d = One;              // Move to state One directly
        end
      end

      // default :                   // Default: do nothing
    endcase
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin : proc_state_ff
    if(~rst_ni) begin                        // Asynchronous reset (active low)
      state_q <= One;                        // Default state is 'One'
      accu_q <= 16'b0;
      count_q <= 5'd0;
    end else begin
      accu_q <= accu_d;
      count_q <= count_d;
      state_q <= state_d;                    // Next state copied to present state
    end
  end

  assign out_o = accu_q;

endmodule
