// Write a CVS file line by line based on a given field width.
class csv_writer #(
    int DATA_WIDTH,
    int FIELD_WIDTH
);

    int fid;

    function new(string file_path);
        fid = $fopen(file_path, "w");
        if (!fid) begin
            $display("%m could not open '%s'!", file_path);
            $stop;
        end
    endfunction

    task write_line(input logic [DATA_WIDTH-1:0] line_i);
        string line_str;
        string field_str;
        line_str = "";
        // Concatenate input.
        for (int i = (DATA_WIDTH/FIELD_WIDTH) - 1; i >= 0; i = i - 1) begin
            field_str.itoa(line_i[FIELD_WIDTH * i +: FIELD_WIDTH]);
            line_str = {field_str, line_str};
            if (i != 0) begin
                line_str = {",", line_str};
            end
        end
        $fdisplay(fid, "%s", line_str);
    endtask

endclass
