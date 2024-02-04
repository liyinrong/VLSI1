/*
 * Top level for the filter
 */
module rgb_filter (
  input  logic                 clk_i,
  input  logic                 rst_ni,

  input  logic [2:0]           switch_i,

  input  logic [2:0][2:0][7:0] r_i,
  input  logic [2:0][2:0][7:0] g_i,
  input  logic [2:0][2:0][7:0] b_i,
  input  logic                 hsync_i,
  input  logic                 vsync_i,
  input  logic                 vde_i,
  input  logic                 valid_i,
  output logic                 ready_o,

  output logic [7:0]           r_o,
  output logic [7:0]           g_o,
  output logic [7:0]           b_o,
  output logic                 hsync_o,
  output logic                 vsync_o,
  output logic                 vde_o,
  output logic                 valid_o,
  input  logic                 ready_i);

  // Convolution weights
  logic [2:0][2:0][11:0]       k;

  localparam KERNEL_IDENTITY = 2'b00;
  localparam KERNEL_GAUSSIAN = 2'b01;
  localparam KERNEL_SHARP    = 2'b10;
  localparam KERNEL_SOBEL    = 2'b11;

  // Input multiplexer
  always_comb begin
    // Default value
    k = '0;

    case (switch_i[2:1])
      KERNEL_IDENTITY: begin
        // Identity kernel
        k[0] = {12'd0,  12'd0, 12'd0};
        k[1] = {12'd0, 12'd16, 12'd0};
        k[2] = {12'd0,  12'd0, 12'd0};
      end

      KERNEL_GAUSSIAN: begin
        // Gaussian kernel
        k[0] = {12'd1, 12'd2, 12'd1};
        k[1] = {12'd2, 12'd4, 12'd2};
        k[2] = {12'd1, 12'd2, 12'd1};
      end

      // TODO
      KERNEL_SHARP: begin
        k[0] = {12'd0,    -12'd16,  12'd0};
        k[1] = {-12'd16,  12'd80,   -12'd16};
        k[2] = {12'd0,    -12'd16,  12'd0};
      end

      KERNEL_SOBEL: begin
        k[0] = {12'd16, 12'd0, -12'd16};
        k[1] = {12'd32, 12'd0, -12'd32};
        k[2] = {12'd16, 12'd0, -12'd16};
      end
    endcase // case (switch_i[2:1])
  end

  // Convolution block
  logic [7:0] conv_r;
  logic [7:0] conv_g;
  logic [7:0] conv_b;

  rgb_conv i_rgb_conv (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    .r_i     (r_i),
    .g_i     (g_i),
    .b_i     (b_i),
    .k_i     (k),

    .r_o     (conv_r),
    .g_o     (conv_g),
    .b_o     (conv_b)
  );

  // Output multiplexer
  always_comb begin
    if (switch_i[0] == 1'b1) begin
      r_o = conv_r;
      g_o = conv_g;
      b_o = conv_b;
    end else begin
      r_o = r_i[1][1];
      g_o = g_i[1][1];
      b_o = b_i[1][1];
    end
  end

  // -----------------------
  // CONTROL SIGNALS
  // -----------------------

  assign hsync_o = hsync_i;
  assign vsync_o = vsync_i;
  assign vde_o   = vde_i;
  assign valid_o = valid_i;
  assign ready_o = ready_i;

endmodule // rgb_filter
