// Copyright (c) 2022 Integrated Systems Laboratory, ETH Zurich
// Used for the VLSI 1 course
// 
// Author: Michael Rogenmoser <michaero@iis.ee.ethz.ch>

// Traffic Light controller (bad version)
module traffic_ctrl_bad (
  clk_i, rst_ni, lights_o, timer_i, button_i
);

input clk_i, rst_ni;

output [2:0] lights_o;
input timer_i;
input button_i;

  logic [2:0] p;
  logic lO, l1, l2;
  logic [1:0] bt;

  assign bt = '{timer_i, button_i};
  assign lights_o = '{lO, l1, l2};

  always_comb begin
    if (p == 3'b100)
      assign l2 = 1'b1;
    else if (p[2] == 1'b0)
      assign l2 = p[2];
    else if (p[1] == 1'b0)
      assign l2 = 1'b0;
    else if (p[0] == 1'b1)
      assign l2 = 1'b0;
    else
      assign l2 = 1'b0;
  end

  assign lO = (((p[0] | p[2] || p[1]) == '0) | ((~p[0] & p[2] && p[1]) == 1'b1)) ? 1'b1 : 1'b0;

  always_comb begin
    case (p)
      3'b000 : l1 = 1'b0;
      3'b111 : l1 = 1'b0;
      3'b100 : l1 = 1'b0;
      default : l1 = 1'b1;
    endcase
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if(~rst_ni) begin
      p <= '0;
    end else begin
      if ( p[2] == 1'b0) begin
        if (p[0] == 1'b1)
          p <= 3'b111;
        else begin
          if (bt == 2'b11)
            p <= ~p;
          else if (bt == 2'b10)
            p <= 3'b110;
          else if (timer_i == 1'b0) begin
            if (button_i == 1'b1) 
              p <= 3'b111;
          end
        end
      end else begin
        case (p[1:0])
          2'b01 : p <= 3'b000;
          2'b00 : begin
            if (timer_i == 1'b1)
              p <= 3'b101;
          end
          2'b11 : begin
            if (button_i)
              p <= 3'b001;
            else
              p <= !p;
          end
          2'b10 : p <= 3'b100;
        endcase
      end
    end
  end

endmodule
