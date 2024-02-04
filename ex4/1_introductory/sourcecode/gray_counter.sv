/** Gray counter
  *
  * Adapted for the VLSI 1 exercises from the VHDL example design at
  * https://www.intel.com/content/www/us/en/programmable/support/support-resources/design-examples/design-software/vhdl/vhd-gray-counter.html
  *
  * (c) 2010 Altera Corporation.
  *
  * Absolutely restricted to internal use as part of the VLSI 1 exercises.
  */
module gray_counter (
    input  logic        clk_i,
    input  logic        rst_ni,
    output logic [7:0]  gray_count_o
);

    /** Implementation:
      *
      * There's an imaginary bit in the counter, at gray_cnt_img, that resets to 1 (unlike the rest
      * of the bits of the counter) and flips every clock cycle.  The decision of whether to flip
      * any non-imaginary bit in the counter depends solely on the bits below it, down to the
      * imaginary bit.  It flips only if all these bits, taken together, match the pattern 10* (a one
      * followed by any number of zeros).
      *
      * Almost every non-imaginary bit has a submodule instance that sets the bit based on the
      * values of the lower-order bits, as described above.  The rules have to differ slightly for
      * the most significant bit or else the counter would saturate at it's highest value, 1000...0.
      */

    // gray_cnt is the counter plus the imaginary bit.
    logic  [7:0] gray_cnt_q, gray_cnt_d;
    logic        gray_cnt_img_q, gray_cnt_img_d;

    // no_ones_below[x] = 1 iff there is no '1' in gray_cnt_q[x-1:-1].
    logic  [6:0] no_ones_below;

    // msb_mod is a modification to make the msb logic work
    logic msb_mod;

    assign msb_mod = gray_cnt_q[7] | gray_cnt_q[6];

    // sequential logic
    always_ff @(posedge clk_i, negedge rst_ni) begin
        if (~rst_ni) begin
            gray_cnt_q <= 8'b00000000;
            // The imaginary bit is '1' at reset.
            gray_cnt_img_q <= 1'b1;
        end else begin
            gray_cnt_q <= gray_cnt_d;
            gray_cnt_img_q <= gray_cnt_img_d;
        end
    end

    // Determine the next state of the gray counter.
    always_comb begin
        gray_cnt_d = gray_cnt_q;
        // Toggle the imaginary bit.
        gray_cnt_img_d = ~gray_cnt_img_q;

        gray_cnt_d[0] = gray_cnt_img_q ? ~gray_cnt_q[0] : gray_cnt_q[0];
        for (int i = 1; i < 7; i = i + 1) begin
            // Flip gray_cnt_q[i] iff bits below are a one followed by zeroes.
            gray_cnt_d[i] = (gray_cnt_q[i-1] & no_ones_below[i-1]) ? ~gray_cnt_q[i] : gray_cnt_q[i];
        end
        gray_cnt_d[7] = gray_cnt_q[4] ^ (msb_mod & no_ones_below[6]);
    end

    // Determine `no_ones_below`.
    always_comb begin
        // There are never any ones below the LSB of the counter.
        no_ones_below[0] = ~gray_cnt_img_q;
        for (int i = 1; i < 7; i = i + 1) begin
            no_ones_below[i] = no_ones_below[i-1] & ~gray_cnt_q[i-1];
        end
    end

    // Assign output.
    assign gray_count_o = gray_cnt_q;

    assert property (@(posedge clk_i) disable iff (~rst_ni) $onehot(gray_cnt_q ^ gray_cnt_d))
    else begin
        $warning("Multiple bits changed at %t ns.", $time);
    end

endmodule
