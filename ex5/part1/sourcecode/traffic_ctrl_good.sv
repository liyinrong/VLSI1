// Copyright (c) 2022 Integrated Systems Laboratory, ETH Zurich
// Used for the VLSI 1 course
//
// Author: Michael Rogenmoser <michaero@iis.ee.ethz.ch>

// Traffic Light controller (good version)
module traffic_ctrl_good (
  input  logic       clk_i,
  input  logic       rst_ni,

  output logic [2:0] lights_o, // 3 bit lights
                               //  2: Red
                               //  1: Orange
                               //  0: Green
  input  logic       timer_i,
  input  logic       button_i
);

  // Definition of states
  typedef enum logic [2:0] {
    Red,              // only red light
    OrangeGo,         // transition between red and green, both red and orange
    Green,            // only green light
    OrangeStop,       // transition between green and red, only orange
    Blank,            // no lights
    OrangeWarn        // warning light, only orange
  } light_state_e;

  light_state_e state_d, state_q;

  // Separate signals for readability
  logic red_light, orange_light, green_light;
  assign lights_o[0] = green_light;
  assign lights_o[1] = orange_light;
  assign lights_o[2] = red_light;

  always_comb begin : proc_next_state

    // set default values
    state_d      = state_q;                   // keep the same state
    red_light    = 1'b0;                      // red light off
    orange_light = 1'b0;                      // orange light off
    green_light  = 1'b0;                      // green light off

    case (state_q)
      OrangeGo : begin
        state_d = Green;                      // unconditional move to other state

        orange_light = 1'b1;                  // Both orange and red
        red_light    = 1'b1;
      end

      OrangeStop : begin
        state_d = Red;                        // unconditional move to other state

        orange_light = 1'b1;                  // Only orange
      end

      OrangeWarn : begin
        state_d = Blank;                      // unconditional move to other state

        red_light = 1'b1;
        orange_light = 1'b1;                  // Only orange
        green_light = 1'b1;
      end

      Blank : begin
        if (button_i == 1'b0) begin           // Is button still pressed?
          state_d = Red;                      // No: go back to state 'Red'
        end else begin
          state_d = OrangeWarn;               // Yes: go to state 'OrangeWarn'
        end
      end

      Red : begin
        if (button_i == 1'b1) begin           // Is button pressed?
          state_d = Blank;                    // Go to 'Blank' state
        end else if (timer_i == 1'b1) begin   // Timer has expired
          // state_d = OrangeGo;                 // Go to 'OrangeGo' state
          state_d = Green;
        end else begin                        // Timer still counting
          state_d = Red;                      // Stay in 'Red' state
        end

        red_light = 1'b1;                     // Only red
      end

      Green : begin
        if (timer_i == 1'b1) begin            // Has timer expired
          state_d = OrangeStop;               // Go to 'OrangeStop' state
        end

        green_light = 1'b1;                   // Only green
      end

      // default :                            // Default: do nothing, defaults already set at top
    endcase
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin : proc_state_ff
    if (!rst_ni) begin                        // Asynchronous reset (active low)
      state_q <= Red;                         // Default state is 'Red'
    end else begin
      state_q <= state_d;                     // Next state copied to present state
    end
  end

endmodule
