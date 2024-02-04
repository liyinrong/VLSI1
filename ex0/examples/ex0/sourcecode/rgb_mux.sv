module rgb_mux #(
  parameter integer WIDTH,
  parameter integer N_INP,
  /// Dependent parameters, DO NOT OVERRIDE!
  localparam integer LOG_N_INP = $clog2(N_INP)
) (
  input  logic    [N_INP-1:0][WIDTH-1:0]  rgb_i,
  input  logic    [N_INP-1:0]             hsync_i,
  input  logic    [N_INP-1:0]             vsync_i,
  input  logic    [N_INP-1:0]             vde_i,
  input  logic    [N_INP-1:0]             valid_i,
  output logic    [N_INP-1:0]             ready_o,

  input  logic    [LOG_N_INP-1:0]         inp_sel_i,

  output logic    [WIDTH-1:0]             rgb_o,
  output logic                            hsync_o,
  output logic                            vsync_o,
  output logic                            vde_o,
  output logic                            valid_o,
  input  logic                            ready_i
);

  typedef struct packed {
    logic [WIDTH-1:0]   rgb;
    logic               hsync, vsync, vde;
  } pixel_t;

  pixel_t [N_INP-1:0] inps;
  pixel_t             oup;

  for (genvar i = 0; i < N_INP; ++i) begin
    assign inps[i] = '{
      rgb: rgb_i[i],
      hsync: hsync_i[i],
      vsync: vsync_i[i],
      vde: vde_i[i]
    };
  end

  stream_mux #(
    .DATA_T (pixel_t),
    .N_INP  (N_INP)
  ) i_stream_mux (
    .inp_data_i   ( inps      ),
    .inp_valid_i  ( valid_i   ),
    .inp_ready_o  ( ready_o   ),
    .inp_sel_i    ( inp_sel_i ),
    .oup_data_o   ( oup       ),
    .oup_valid_o  ( valid_o   ),
    .oup_ready_i  ( ready_i   )
  );

    assign rgb_o    = oup.rgb;
    assign hsync_o  = oup.hsync;
    assign vsync_o  = oup.vsync;
    assign vde_o    = oup.vde;

  endmodule
