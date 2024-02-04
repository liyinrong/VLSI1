module panel_mux_prim #(
    parameter  NumPanelsX       = 4,
    parameter  NumPanelsY       = 4,
    localparam NumPanels        = NumPanelsX*NumPanelsY,
    localparam NumPanelsWidth   = $clog2(NumPanels)
)(

    input logic [NumPanels-1:0][3:0]    fenable_arr_i , // fenable from filt_fsms
    input logic [NumPanelsWidth-1:0]    psel_i,         // panel select signal
    output logic [3:0]                  fenable_o       // filt_enable of the currently selected panel

);


    always_comb begin
        fenable_o = 4'b0;
        case(psel_i)
            3'd0: begin
                fenable_o = fenable_arr_i[0];
            end
            3'd1: begin
                fenable_o = fenable_arr_i[1];
            end
            3'd2: begin
                fenable_o = fenable_arr_i[2];
            end
            3'd3: begin
                fenable_o = fenable_arr_i[3];
            end
            3'd4: begin
                fenable_o = fenable_arr_i[4];
            end
            3'd5: begin
                fenable_o = fenable_arr_i[5];
            end
        endcase
    end



endmodule
