module rgb_proc_tester #(
    parameter time ACQ_DELAY    // Response acquisition delay
) (
    input  logic        clk_i,

    input  logic [3:0]  filt_enable_i,

    input  logic [7:0]  r_inp_i,
    input  logic [7:0]  g_inp_i,
    input  logic [7:0]  b_inp_i,

    input  logic        hsync_inp_i,
    input  logic        vsync_inp_i,
    input  logic        vde_inp_i,

    input  logic [7:0]  r_oup_i,
    input  logic [7:0]  g_oup_i,
    input  logic [7:0]  b_oup_i,

    input  logic        hsync_oup_i,
    input  logic        vsync_oup_i,
    input  logic        vde_oup_i,

    input  logic        p0valid_i,
    input  logic        p0ready_i,

    input  logic        p1valid_i,
    input  logic        p1ready_i,

    input  logic        p2valid_i,
    input  logic        p2ready_i,

    input  logic        p3valid_i,
    input  logic        p3ready_i,

    input  logic        p4valid_i,
    input  logic        p4ready_i
);

    logic [7:0] exp_gray,
                exp_gray_r,
                exp_gray_g,
                exp_gray_b,
                exp_sat_r,
                exp_sat_g,
                exp_sat_b,
                exp_inv_r,
                exp_inv_g,
                exp_inv_b,
                exp_ca_r,
                exp_ca_g,
                exp_ca_b;

    logic       exp_hsync_p0,
                exp_vsync_p0,
                exp_vde_p0,
                exp_hsync_p1,
                exp_vsync_p1,
                exp_vde_p1,
                exp_hsync_p2,
                exp_vsync_p2,
                exp_vde_p2,
                exp_hsync_p3,
                exp_vsync_p3,
                exp_vde_p3;

    logic [7:0] r_ref,
                g_ref,
                b_ref;

    logic       hsync_ref,
                vsync_ref,
                vde_ref;

    logic [8*3+3-1:0]   i_dat_processed,
                        o_dat_ref,
                        o_dat_actual,
                        queue[$];

    assign {r_ref, g_ref, b_ref, hsync_ref, vsync_ref, vde_ref} = o_dat_ref;
    assign o_dat_actual = {r_oup_i, g_oup_i, b_oup_i, hsync_oup_i, vsync_oup_i, vde_oup_i};
    assign i_dat_processed = {exp_ca_r, exp_ca_g, exp_ca_b, exp_hsync_p3, exp_vsync_p3, exp_vde_p3};

    // Check the output of the grayscaler.
    function logic[7:0] grayscale;
        input logic[7:0] r_i, g_i, b_i;
        real r, g, b, gray;
    begin
        r = $itor(r_i);
        g = $itor(g_i);
        b = $itor(b_i);
        gray = 0.28906 * r + 0.5664 * g + 0.14063 * b;
        grayscale = $rtoi($floor(gray)) ;
    end endfunction

    always @(posedge clk_i) begin
        #(ACQ_DELAY);
        if (p0valid_i && p0ready_i) begin
            exp_hsync_p0    <= hsync_inp_i;
            exp_vsync_p0    <= vsync_inp_i;
            exp_vde_p0      <= vde_inp_i;
            exp_gray_r      <= r_inp_i;
            exp_gray_g      <= g_inp_i;
            exp_gray_b      <= b_inp_i;
            if (filt_enable_i[0]) begin
                exp_gray <= grayscale(r_inp_i, g_inp_i, b_inp_i);
            end else begin
                exp_gray <= 8'd128;
            end
        end
    end

    // Check the output of the saturator.
    function logic[7:0] saturate;
        input logic[7:0] inp, gray;
        localparam real SCALE = $itor(3);
        real tmp;
    begin
        tmp = ($itor(inp) - $itor(gray)) * SCALE + $itor(gray);
        if (tmp < 0.0) begin
            tmp = 0.0;
        end else if (tmp > 255.0) begin
            tmp = 255.0;
        end
        saturate = $rtoi(tmp);
    end endfunction

    function int abs;
        input [7:0] a, b;
    begin
        if (a > b) begin
            abs = a - b;
        end else begin
            abs = b - a;
        end
    end endfunction

    always @(posedge clk_i) begin
        #(ACQ_DELAY);
        if (p1valid_i && p1ready_i) begin
            exp_hsync_p1    <= exp_hsync_p0;
            exp_vsync_p1    <= exp_vsync_p0;
            exp_vde_p1      <= exp_vde_p0;
            if (filt_enable_i[1]) begin
                exp_sat_r <= saturate(exp_gray_r, exp_gray);
                exp_sat_g <= saturate(exp_gray_g, exp_gray);
                exp_sat_b <= saturate(exp_gray_b, exp_gray);
            end else begin
                exp_sat_r <= exp_gray_r;
                exp_sat_g <= exp_gray_g;
                exp_sat_b <= exp_gray_b;
            end
        end
    end

    // Check the output of the inverter.
    function logic[7:0] invert;
        input logic[7:0] c;
    begin
        invert = 255 - c;
    end endfunction

    always @(posedge clk_i) begin
        #(ACQ_DELAY);
        if (p2valid_i && p2ready_i) begin
            exp_hsync_p2    <= exp_hsync_p1;
            exp_vsync_p2    <= exp_vsync_p1;
            exp_vde_p2      <= exp_vde_p1;
            if (filt_enable_i[2]) begin
                exp_inv_r <= invert(exp_sat_r);
                exp_inv_g <= invert(exp_sat_g);
                exp_inv_b <= invert(exp_sat_b);
            end else begin
                exp_inv_r <= exp_sat_r;
                exp_inv_g <= exp_sat_g;
                exp_inv_b <= exp_sat_b;
            end
        end
    end

    // Check the output of the contrast adjuster.
    function logic[7:0] adj_contrast;
        input logic[7:0] c;
        real gray;
        localparam integer SCALE    = 1;
        localparam integer RANGE1   = 255 / 3;
        localparam integer RANGE2   = 255 * 2 / 3;
        localparam integer LEVEL1   = RANGE1 >> SCALE;
        localparam integer LEVEL2   = 255 - ((255 / 3) >> SCALE);
        localparam integer MID_GRAD = (LEVEL2 - LEVEL1) / (RANGE2 - RANGE1);
    begin
        if (c < RANGE1) begin
            adj_contrast = c >> SCALE;
        end else if (c < RANGE2) begin
            adj_contrast = LEVEL1 + (c - RANGE1) * MID_GRAD;
        end else begin
            adj_contrast = LEVEL2 + ((c - RANGE2) >> SCALE);
        end
    end endfunction

    always @(posedge clk_i) begin
        #(ACQ_DELAY);
        if (p3valid_i && p3ready_i) begin
            exp_hsync_p3    <= exp_hsync_p2;
            exp_vsync_p3    <= exp_vsync_p2;
            exp_vde_p3      <= exp_vde_p2;
            if (filt_enable_i[3]) begin
                exp_ca_r <= adj_contrast(exp_inv_r);
                exp_ca_g <= adj_contrast(exp_inv_g);
                exp_ca_b <= adj_contrast(exp_inv_b);
            end else begin
                exp_ca_r <= exp_inv_r;
                exp_ca_g <= exp_inv_g;
                exp_ca_b <= exp_inv_b;
            end
            #0.001; //queue update after a delta cycle
            queue.push_front(i_dat_processed);
        end
    end

    // pop the values when pipeline output is ready
    always @(posedge clk_i) begin
        #(ACQ_DELAY);
        if (p4valid_i && p4ready_i) begin
            o_dat_ref = queue.pop_back;
            #0;
            if (o_dat_ref == o_dat_actual) begin
                $display("output correct");
            end else begin
                if ((vde_ref != vde_oup_i) || (vsync_ref != vsync_oup_i) ||
                    (hsync_ref != hsync_oup_i) || (abs(r_ref,r_oup_i) > 3) ||
                    (abs(g_ref,g_oup_i) > 3) || (abs(b_ref,b_oup_i) >3)
                ) begin
                    $display("output mismatch received at time %d: actual %x ref %x",
                            $time, o_dat_actual, o_dat_ref);
                    $stop();
                end else begin
                    $display("output within margin at time %d: actual %x ref %x",
                            $time, o_dat_actual, o_dat_ref);
                    $stop();
                end
            end
        end
    end

endmodule
