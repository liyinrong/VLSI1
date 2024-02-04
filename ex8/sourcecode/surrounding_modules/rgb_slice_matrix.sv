/*
 * This block outputs a 3x3 matrix of the input image
 */
module rgb_slice_matrix #(
  parameter int unsigned H_WIDTH = 1920) (
  input logic                  clk_i,
  input logic                  rst_ni,

  input logic [7:0]            r_i,
  input logic [7:0]            g_i,
  input logic [7:0]            b_i,
  input logic                  hsync_i,
  input logic                  vsync_i,
  input logic                  vde_i,
  input logic                  valid_i,
  output logic                 ready_o,

  output logic [2:0][2:0][7:0] r_o,
  output logic [2:0][2:0][7:0] g_o,
  output logic [2:0][2:0][7:0] b_o,
  output logic                 hsync_o,
  output logic                 vsync_o,
  output logic                 vde_o,
  output logic                 valid_o,
  input logic                  ready_i);

  // ----------------
  // INTERNAL SIGNALS
  // ----------------

  struct packed {
    logic [2:0][2:0][7:0]      r;
    logic [2:0][2:0][7:0]      g;
    logic [2:0][2:0][7:0]      b;
  } slice_d, slice_q;
  assign {r_o, g_o, b_o} = slice_q;
  assign hsync_o = hsync_i;
  assign vsync_o = vsync_i;
  assign vde_o   = vde_i;
  assign valid_o = valid_i;
  assign ready_o = ready_i;

  logic [$clog2(H_WIDTH):0]    line_addr_d, line_addr_q;

  // ----------------
  // RAMS
  // ----------------

  logic [$clog2(H_WIDTH):0]    bram_raddr_a, bram_raddr_b;
  logic [23:0]                 bram_rdata_a, bram_rdata_b;
  logic [$clog2(H_WIDTH):0]    bram_waddr_a, bram_waddr_b;
  logic [23:0]                 bram_wdata_a, bram_wdata_b;
  logic                        bram_wen_a,   bram_wen_b;

  bram i_ram_a (
    .clka   (clk_i),
    .wea    (bram_wen_a),
    .addra  (bram_waddr_a),
    .dina   (bram_wdata_a),

    .clkb   (clk_i),
    .addrb  (bram_raddr_a),
    .doutb  (bram_rdata_a)
    );

  bram i_ram_b (
    .clka   (clk_i),
    .wea    (bram_wen_b),
    .addra  (bram_waddr_b),
    .dina   (bram_wdata_b),

    .clkb   (clk_i),
    .addrb  (bram_raddr_b),
    .doutb  (bram_rdata_b)
    );

  // ----------------
  // LOGIC
  // ----------------

  always_comb begin
    // Maintain state
    slice_d      = slice_q;
    line_addr_d  = line_addr_q;

    // RAM control
    bram_raddr_a = '0;
    bram_waddr_a = '0;
    bram_wen_a   = '0;
    bram_wdata_a = '0;

    bram_raddr_b = '0;
    bram_waddr_b = '0;
    bram_wen_b   = '0;
    bram_wdata_b = '0;

    // Jump to next pixel
    if (hsync_i)
      line_addr_d = line_addr_q + 1;

    // Next line
    if (vsync_i)
      line_addr_d = 2;

    // BRAM write
    if (vde_i) begin
      bram_wen_a    = 1'b1;
      bram_raddr_a  = line_addr_d;
      bram_waddr_a  = line_addr_d;
      bram_wdata_a  = bram_rdata_b;

      bram_wen_b    = 1'b1;
      bram_raddr_b  = line_addr_d;
      bram_waddr_b  = line_addr_d;
      bram_wdata_b  = {r_i, g_i, b_i};
    end // if (vde_i)

    // Output slice
    if (valid_i) begin
      slice_d.r = {slice_q.r[2][1], slice_q.r[2][0], bram_rdata_a[23:16], slice_q.r[1][1], slice_q.r[1][0], bram_rdata_b[23:16], slice_q.r[0][1], slice_q.r[0][0], r_i};
      slice_d.g = {slice_q.g[2][1], slice_q.g[2][0], bram_rdata_a[15: 8], slice_q.g[1][1], slice_q.g[1][0], bram_rdata_b[15: 8], slice_q.g[0][1], slice_q.g[0][0], g_i};
      slice_d.b = {slice_q.b[2][1], slice_q.b[2][0], bram_rdata_a[ 7: 0], slice_q.b[1][1], slice_q.b[1][0], bram_rdata_b[ 7: 0], slice_q.b[0][1], slice_q.b[0][0], b_i};
    end
  end

  // ----------------
  // REGISTERS
  // ----------------

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      slice_q     <= '0;
      line_addr_q <= '0;
    end else begin
      if (ready_i) begin
        slice_q     <= slice_d;
        line_addr_q <= line_addr_d;
      end
    end
  end

endmodule // rgb_slice_matrix
