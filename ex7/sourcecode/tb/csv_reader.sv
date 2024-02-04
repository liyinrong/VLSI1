// Read a CSV file line by line and generates a line-wise concatenated output signal.
class csv_reader #(
    int DATA_WIDTH,
    int FIELD_WIDTH
);

    int fid;

    function new(string file_path);
        fid = $fopen(file_path,"rb");
        if (!fid) begin
            $display("%m could not open file '%s'!", file_path);
            $stop;
        end
    endfunction

    function automatic void parse (
        output string out[],
        input string in,
        input byte separator = ","
    );
        // Split the input string into a queue of strings based on the separator.
        automatic int index [$];
        foreach (in[i]) begin
            if (in[i] == separator) begin
                index.push_back(i-1);
                index.push_back(i+1);
            end
        end
        index.push_front(0);
        index.push_back(in.len()-1);

        out = new[index.size()/2];
        foreach (out[i]) begin
            out[i] = in.substr(index[2*i], index[2*i+1]);
        end
    endfunction

    task try_read_line(output logic [DATA_WIDTH-1:0] line_o, output logic eof_o);
        int r_stat;
        string line;
        string field[$];
        int field_cnt;
        field_cnt = 0;
        r_stat = $fgets(line, fid);
        if (r_stat) begin
            parse(field, line, ",");
            field_cnt = field.size();
            assert(field_cnt <= (DATA_WIDTH/FIELD_WIDTH));
            // Concatenate input.
            for (int i = 0; i < field_cnt; i = i + 1) begin
                line_o[FIELD_WIDTH*(i)+:FIELD_WIDTH] = field[i].atoi();
            end
            eof_o = 0;
        end else begin
            eof_o = 1;
        end
    endtask

    task read_line(output logic [DATA_WIDTH-1:0] line_o);
        logic eof;
        try_read_line(line_o, eof);
        if (eof) begin
            $display("Simulation finished: end of file %m");
            $stop;
        end
    endtask

endclass
