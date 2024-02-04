/*
 * Convolution with a 3x3 kernel
 */
module rgb_conv (
  input logic                  clk_i,
  input logic                  rst_ni,

  input logic [2:0][2:0][7:0]  r_i,
  input logic [2:0][2:0][7:0]  g_i,
  input logic [2:0][2:0][7:0]  b_i,
  input logic [2:0][2:0][11:0] k_i,

  output logic [7:0]           r_o,
  output logic [7:0]           g_o,
  output logic [7:0]           b_o);

  // -----------------------
  // PARAMETERS
  // -----------------------

  localparam KERNEL_WIDTH = 12;
  localparam PIXEL_WIDTH = 8;
  localparam MULTIPLICATION_WIDTH = 20;
  localparam ACCUMULATOR_WIDTH = 24;
  localparam DECIMAL_WIDTH = 4;

  // -----------------------
  // MULTIPLICATIONS
  // -----------------------

  // logic [2:0][2:0][MULTIPLICATION_WIDTH-1:0] mul_r_d, mul_r_q;
  // logic [2:0][2:0][MULTIPLICATION_WIDTH-1:0] mul_g_d, mul_g_q;
  // logic [2:0][2:0][MULTIPLICATION_WIDTH-1:0] mul_b_d, mul_b_q;
  logic [5:0][MULTIPLICATION_WIDTH-1:0] mul_r_d, mul_r_q;
  logic [5:0][MULTIPLICATION_WIDTH-1:0] mul_g_d, mul_g_q;
  logic [5:0][MULTIPLICATION_WIDTH-1:0] mul_b_d, mul_b_q;

  // const logic [MULTIPLICATION_WIDTH-PIXEL_WIDTH-1:0] MUL_PREFIX = '0;
  const logic [MULTIPLICATION_WIDTH-PIXEL_WIDTH-2:0] MUL_PREFIX = '0;
  const logic ADD_PREFIX = 1'b0;

  // always_comb begin
  //   for (int x = 0; x < 3; x++) begin
  //     for (int y = 0; y < 3; y++) begin
  //       mul_r_d[x][y] = $signed(k_i[x][y]) * $signed({MUL_PREFIX, r_i[x][y]});
  //       mul_g_d[x][y] = $signed(k_i[x][y]) * $signed({MUL_PREFIX, g_i[x][y]});
  //       mul_b_d[x][y] = $signed(k_i[x][y]) * $signed({MUL_PREFIX, b_i[x][y]});
  //     end
  //   end
  // end
  // always_comb begin
  //   mul_r_d[0] = $signed(k_i[0][0]) * $signed({MUL_PREFIX, {1'b0, r_i[0][0]} + {1'b0, r_i[2][0]}});
  //   mul_r_d[1] = $signed(k_i[0][1]) * $signed({MUL_PREFIX, {1'b0, r_i[0][1]} + {1'b0, r_i[2][1]}});
  //   mul_r_d[2] = $signed(k_i[0][2]) * $signed({MUL_PREFIX, {1'b0, r_i[0][2]} + {1'b0, r_i[2][2]}});
  //   mul_g_d[0] = $signed(k_i[0][0]) * $signed({MUL_PREFIX, {1'b0, g_i[0][0]} + {1'b0, g_i[2][0]}});
  //   mul_g_d[1] = $signed(k_i[0][1]) * $signed({MUL_PREFIX, {1'b0, g_i[0][1]} + {1'b0, g_i[2][1]}});
  //   mul_g_d[2] = $signed(k_i[0][2]) * $signed({MUL_PREFIX, {1'b0, g_i[0][2]} + {1'b0, g_i[2][2]}});
  //   mul_b_d[0] = $signed(k_i[0][0]) * $signed({MUL_PREFIX, {1'b0, b_i[0][0]} + {1'b0, b_i[2][0]}});
  //   mul_b_d[1] = $signed(k_i[0][1]) * $signed({MUL_PREFIX, {1'b0, b_i[0][1]} + {1'b0, b_i[2][1]}});
  //   mul_b_d[2] = $signed(k_i[0][2]) * $signed({MUL_PREFIX, {1'b0, b_i[0][2]} + {1'b0, b_i[2][2]}});

  //   mul_r_d[3] = $signed(k_i[1][0]) * $signed({MUL_PREFIX, 1'b0, r_i[1][0]});
  //   mul_r_d[4] = $signed(k_i[1][1]) * $signed({MUL_PREFIX, 1'b0, r_i[1][1]});
  //   mul_r_d[5] = $signed(k_i[1][2]) * $signed({MUL_PREFIX, 1'b0, r_i[1][2]});
  //   mul_g_d[3] = $signed(k_i[1][0]) * $signed({MUL_PREFIX, 1'b0, g_i[1][0]});
  //   mul_g_d[4] = $signed(k_i[1][1]) * $signed({MUL_PREFIX, 1'b0, g_i[1][1]});
  //   mul_g_d[5] = $signed(k_i[1][2]) * $signed({MUL_PREFIX, 1'b0, g_i[1][2]});
  //   mul_b_d[3] = $signed(k_i[1][0]) * $signed({MUL_PREFIX, 1'b0, b_i[1][0]});
  //   mul_b_d[4] = $signed(k_i[1][1]) * $signed({MUL_PREFIX, 1'b0, b_i[1][1]});
  //   mul_b_d[5] = $signed(k_i[1][2]) * $signed({MUL_PREFIX, 1'b0, b_i[1][2]});
  // end


  always_comb begin
    // assumes that [0][i] and [2][i] have same weights
    mul_r_d[0] = $signed(k_i[0][0]) * $signed({MUL_PREFIX, {ADD_PREFIX, r_i[0][0]} + {ADD_PREFIX, r_i[2][0]}});
    mul_g_d[0] = $signed(k_i[0][0]) * $signed({MUL_PREFIX, {ADD_PREFIX, g_i[0][0]} + {ADD_PREFIX, g_i[2][0]}});
    mul_b_d[0] = $signed(k_i[0][0]) * $signed({MUL_PREFIX, {ADD_PREFIX, b_i[0][0]} + {ADD_PREFIX, b_i[2][0]}});
    mul_r_d[1] = $signed(k_i[0][1]) * $signed({MUL_PREFIX, {ADD_PREFIX, r_i[0][1]} + {ADD_PREFIX, r_i[2][1]}});
    mul_g_d[1] = $signed(k_i[0][1]) * $signed({MUL_PREFIX, {ADD_PREFIX, g_i[0][1]} + {ADD_PREFIX, g_i[2][1]}});
    mul_b_d[1] = $signed(k_i[0][1]) * $signed({MUL_PREFIX, {ADD_PREFIX, b_i[0][1]} + {ADD_PREFIX, b_i[2][1]}});
    mul_r_d[2] = $signed(k_i[0][2]) * $signed({MUL_PREFIX, {ADD_PREFIX, r_i[0][2]} + {ADD_PREFIX, r_i[2][2]}});
    mul_g_d[2] = $signed(k_i[0][2]) * $signed({MUL_PREFIX, {ADD_PREFIX, g_i[0][2]} + {ADD_PREFIX, g_i[2][2]}});
    mul_b_d[2] = $signed(k_i[0][2]) * $signed({MUL_PREFIX, {ADD_PREFIX, b_i[0][2]} + {ADD_PREFIX, b_i[2][2]}});

    mul_r_d[3] = $signed(k_i[1][0]) * $signed({MUL_PREFIX, ADD_PREFIX, r_i[1][0]});
    mul_g_d[3] = $signed(k_i[1][0]) * $signed({MUL_PREFIX, ADD_PREFIX, g_i[1][0]});
    mul_b_d[3] = $signed(k_i[1][0]) * $signed({MUL_PREFIX, ADD_PREFIX, b_i[1][0]});
    mul_r_d[4] = $signed(k_i[1][1]) * $signed({MUL_PREFIX, ADD_PREFIX, r_i[1][1]});
    mul_g_d[4] = $signed(k_i[1][1]) * $signed({MUL_PREFIX, ADD_PREFIX, g_i[1][1]});
    mul_b_d[4] = $signed(k_i[1][1]) * $signed({MUL_PREFIX, ADD_PREFIX, b_i[1][1]});
    mul_r_d[5] = $signed(k_i[1][2]) * $signed({MUL_PREFIX, ADD_PREFIX, r_i[1][2]});
    mul_g_d[5] = $signed(k_i[1][2]) * $signed({MUL_PREFIX, ADD_PREFIX, g_i[1][2]});
    mul_b_d[5] = $signed(k_i[1][2]) * $signed({MUL_PREFIX, ADD_PREFIX, b_i[1][2]});
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if(~rst_ni) begin
      mul_r_q <= 'd0;
      mul_g_q <= 'd0;
      mul_b_q <= 'd0;
    end
    else begin
      mul_r_q <= mul_r_d;
      mul_g_q <= mul_g_d;
      mul_b_q <= mul_b_d;
    end
  end

  // -----------------------
  // ACCUMULATION
  // -----------------------

  logic [ACCUMULATOR_WIDTH-1:0] acc_r_q, acc_r_d;
  logic [ACCUMULATOR_WIDTH-1:0] acc_g_q, acc_g_d;
  logic [ACCUMULATOR_WIDTH-1:0] acc_b_q, acc_b_d;

  // always_comb begin
  //   acc_r_d  = (($signed(mul_r_q[0][0]) + $signed(mul_r_q[0][1])) +
  //              ($signed(mul_r_q[0][2]) + $signed(mul_r_q[1][0]))) +
  //              (($signed(mul_r_q[1][1]) + $signed(mul_r_q[1][2])) +
  //              ($signed(mul_r_q[2][0]) + $signed(mul_r_q[2][1]))) +
  //              $signed(mul_r_q[2][2]);

  //   acc_g_d  = (($signed(mul_g_q[0][0]) + $signed(mul_g_q[0][1])) +
  //              ($signed(mul_g_q[0][2]) + $signed(mul_g_q[1][0]))) +
  //              (($signed(mul_g_q[1][1]) + $signed(mul_g_q[1][2])) +
  //              ($signed(mul_g_q[2][0]) + $signed(mul_g_q[2][1]))) +
  //              $signed(mul_g_q[2][2]);

  //   acc_b_d  = (($signed(mul_b_q[0][0]) + $signed(mul_b_q[0][1])) +
  //              ($signed(mul_b_q[0][2]) + $signed(mul_b_q[1][0]))) +
  //              (($signed(mul_b_q[1][1]) + $signed(mul_b_q[1][2])) +
  //              ($signed(mul_b_q[2][0]) + $signed(mul_b_q[2][1]))) +
  //              $signed(mul_b_q[2][2]);
  // end
  always_comb begin
    acc_r_d = ($signed(mul_r_q[0]) + $signed(mul_r_q[1])) + 
              ($signed(mul_r_q[2]) + $signed(mul_r_q[3])) +
              ($signed(mul_r_q[4]) + $signed(mul_r_q[5]));

    acc_g_d = ($signed(mul_g_q[0]) + $signed(mul_g_q[1])) + 
              ($signed(mul_g_q[2]) + $signed(mul_g_q[3])) +
              ($signed(mul_g_q[4]) + $signed(mul_g_q[5]));

    acc_b_d = ($signed(mul_b_q[0]) + $signed(mul_b_q[1])) + 
              ($signed(mul_b_q[2]) + $signed(mul_b_q[3])) +
              ($signed(mul_b_q[4]) + $signed(mul_b_q[5]));
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      acc_r_q <= '0;
      acc_g_q <= '0;
      acc_b_q <= '0;
    end else begin
      acc_r_q <= acc_r_d;
      acc_g_q <= acc_g_d;
      acc_b_q <= acc_b_d;
    end
  end

  // -----------------------
  // OUTPUT
  // -----------------------

  // Only output integer part of accumulator as the output pixel
  // Right shift to cut-off decimal part
  logic [ACCUMULATOR_WIDTH-DECIMAL_WIDTH-1:0] int_round_r;
  logic [ACCUMULATOR_WIDTH-DECIMAL_WIDTH-1:0] int_round_g;
  logic [ACCUMULATOR_WIDTH-DECIMAL_WIDTH-1:0] int_round_b;

  always_comb begin
    int_round_r = acc_r_q >> DECIMAL_WIDTH;
    int_round_g = acc_g_q >> DECIMAL_WIDTH;
    int_round_b = acc_b_q >> DECIMAL_WIDTH;
  end

  always_comb begin

    if ($signed(int_round_r) < 0)
      r_o = 0;
    else
      r_o = (int_round_r > 255) ? 255 : int_round_r;

    if ($signed(int_round_g) < 0)
      g_o = 0;
    else
      g_o = (int_round_g > 255) ? 255 : int_round_g;

    if ($signed(int_round_b) < 0)
      b_o = 0;
    else
      b_o = (int_round_b > 255) ? 255 : int_round_b;
   
  end

endmodule // rgb_conv
