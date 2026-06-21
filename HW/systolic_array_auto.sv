
module systolic_array_auto #(
    parameter PARAM_WIDTH = 8,
    parameter WIDTH = 8,
    parameter ROWS = 2,
    parameter COLS = 2
)
(
    input   logic                             clk,
    input   logic                             rst,
    input   logic                             sync_rst,
    input   logic   [PARAM_WIDTH-1:0]         max_rows,
    input   logic   [PARAM_WIDTH-1:0]         max_cols,
    input   logic   [PARAM_WIDTH-1:0]         max_common,
    

    input   logic   [ROWS-1:0]                shift_en,
    input   logic                             parallel_sum,

    input   logic   [ROWS*WIDTH-1:0]          a_in,
    input   logic   [COLS*WIDTH-1:0]          b_in,

    input   logic   [ROWS-1:0]                a_valid_in,
    input   logic   [COLS-1:0]                b_valid_in,
    
    output  logic   [ROWS-1:0]                a_ready_out,
    output  logic   [COLS-1:0]                b_ready_out,
    input   logic                             en,
    output  logic                             done,
    output  logic                             wait_input,

    output  logic   [ROWS-1:0]                v_row_out,
    output  logic   [(ROWS*WIDTH)-1:0]        d_row_out       




);


localparam NO_INPUTS = ROWS + COLS - 1;




logic   [(WIDTH*ROWS*COLS)-1:0]   d_out;

logic   [(WIDTH)-1:0]   sys_d_out [ROWS*COLS];
logic   [(WIDTH)-1:0]   sys_d_row_out [ROWS];




wire [(WIDTH*ROWS)-1:0] a_out_most_right;
wire [(WIDTH*COLS)-1:0] b_out_most_down;
wire [(WIDTH*COLS*ROWS)-1:0] a_out_right;
wire [(WIDTH*COLS*ROWS)-1:0] b_out_down;


wire [(ROWS*COLS)-1:0] a_valid_most_right;
wire [(ROWS*COLS)-1:0] b_valid_most_down;
wire [(ROWS*COLS)-1:0] pe_valid_out;



wire logic [7:0]  all_mult_count;
wire logic [7:0]  pe0_mult_count;

wire logic        pe0_done;
wire logic [7:0]  min_mult_count  = max_cols + max_rows;//physical
//                                        2    <  4 => 4
//                                        3    <  6 => 6
wire logic [7:0]  real_mult_count = min_mult_count + (max_common-2);//max_common > min_mult_count? min_mult_count + (max_common-min_mult_count) : min_mult_count;
wire logic        pe0_valid_in  = (a_valid_in[0] && b_valid_in[0]);

wire logic main_counter_en = (!pe0_valid_in && pe0_done && en) || (pe0_valid_in && !pe0_done && en);

wire logic pause = (!pe0_valid_in && !pe0_done);

wire logic w_en = en; //&& !pause;
assign pe0_done = (pe0_mult_count == max_common);
assign done =     (all_mult_count == real_mult_count);
assign wait_input = pause;
counter #(.WIDTH(8)) multiplication_counter (
    .clk(clk),
    .rst(rst),
    .i_sync_rst(sync_rst),
    .i_load(1'b0),
    .i_enable(main_counter_en),
    .i_load_data('b0),
    .o_count(all_mult_count)
);


counter #(.WIDTH(8)) pe0_multiplication_counter (
    .clk(clk),
    .rst(rst),
    .i_sync_rst(sync_rst),
    .i_load(1'b0),
    .i_enable(pe0_valid_in && en),
    .i_load_data('b0),
    .o_count(pe0_mult_count)
);

logic   [ROWS*WIDTH-1:0]          w_a_in;
logic   [COLS*WIDTH-1:0]          w_b_in;



genvar g_row_out, g_col_out;
generate 
    for (g_row_out = 0; g_row_out < ROWS; g_row_out++)
    begin: ROW_OUT_GEN
        for(g_col_out = 0; g_col_out < COLS; g_col_out++)
        begin: COL_OUT_GEN
        localparam integer INDEX = (g_row_out * ROWS) + g_col_out;
        if(g_col_out == 0)
        begin
            assign v_row_out[g_row_out]     =   pe_valid_out[INDEX];
            assign d_row_out[(g_row_out*WIDTH)+:WIDTH] = d_out[(INDEX*WIDTH)+:WIDTH]; 
            assign sys_d_row_out[g_row_out] = d_out[(INDEX*WIDTH)+:WIDTH];
        end

        end
    end
endgenerate


genvar index_x;
generate
for (index_x = 0; index_x < ROWS*COLS; index_x++)
begin: INDEX_OUT
    assign sys_d_out[index_x] = d_out[index_x*WIDTH+:WIDTH];    
end


endgenerate

genvar g_row_x, g_col_x;
generate 
for (g_row_x = 0; g_row_x < ROWS; g_row_x++)
begin: MATA_IN
    assign w_a_in[g_row_x*WIDTH+:WIDTH] = a_valid_in[g_row_x]? a_in[g_row_x*WIDTH+:WIDTH] : 0;
end
for(g_col_x = 0; g_col_x < COLS; g_col_x++)
begin: MATB_IN
    assign w_b_in[g_col_x*WIDTH+:WIDTH] = b_valid_in[g_col_x]? b_in[g_col_x*WIDTH+:WIDTH] : 0;
end

endgenerate


genvar g_row, g_col;
generate 
for (g_row = 0; g_row < ROWS; g_row++)
begin: ROW_GENERATE
    for(g_col = 0; g_col < COLS; g_col++)
    begin: COL_GENERATE
        localparam integer INDEX = (g_row * ROWS) + g_col;
        localparam integer UP_INDEX = ((g_row-1) * ROWS) + g_col;
        localparam integer LEFT_INDEX = ((g_row) * ROWS) + (g_col -1);
        localparam integer RIGHT_INDEX = ((g_row) * ROWS) + (g_col +1);

        

        //first row with first col and the last col and between
        if(g_row == 0)
        begin
            //       |      |      |     | 
            //      \|/    \|/    \|/   \|/
            // --->  X      X      X     X
            // 
            // 

            if(g_col == 0)
            begin
                // COL:           0      1      2     3
                //                |      |      |     | 
                //               \|/    \|/    \|/   \|/
                // ROW: 0   --->  X                     
                // 
                // 
            assign a_ready_out[0] = w_en;
            assign b_ready_out[0] = w_en;
            process_element #(.WIDTH(WIDTH), .VALID_REG(1)) pe_x // (0)
            (
                .clk(clk),
                .rst(rst),
                .sync_rst(sync_rst),
                .parallel_sum(parallel_sum),
                .shift_en(shift_en[0]),
                .shift_in(d_out[(RIGHT_INDEX*WIDTH)+:WIDTH]),
                .d_in(),
                .a_in(w_a_in[0+:WIDTH]), .b_in(w_b_in[0+:WIDTH]),
                .en(w_en), 
                
                .valid_in(pe_valid_out[RIGHT_INDEX]),
                .valid_a(a_valid_in[0]), .valid_b(b_valid_in[0]),
                .valid_out(pe_valid_out[0]),
                
                .a_out(a_out_right[0+:WIDTH]), .b_out(b_out_down[0+:WIDTH]),
                .d_out(d_out[0+:WIDTH])
            );
            end
            else 
            begin
                if(g_col == COLS - 1)
                begin
                // COL:           0      1      2     3
                //                |      |      |     | 
                //               \|/    \|/    \|/   \|/
                // ROW: 0   --->                      X
                // 
                // 
                assign b_ready_out[g_col] = pe_valid_out[LEFT_INDEX];
                process_element #(.WIDTH(WIDTH), .VALID_REG(1)) pe_x // (1) X
                (
                    .clk(clk),
                    .rst(rst),
                    .sync_rst(sync_rst),
                    .parallel_sum(parallel_sum),
                    .shift_en(shift_en[0]),
                    .shift_in('b0),
                    .d_in(),
                    .a_in(a_out_right[(LEFT_INDEX*WIDTH)+:WIDTH]), .b_in(w_b_in[(g_col*WIDTH)+:WIDTH]),
                    .a_out(a_out_most_right[0+:WIDTH]), .b_out(b_out_down[(INDEX*WIDTH)+:WIDTH]),
                    
                    .en(w_en), 
                    
                    .valid_in(1'b0),
                    .valid_a(pe_valid_out[LEFT_INDEX]), .valid_b(b_valid_in[g_col]),
                    .valid_out(pe_valid_out[INDEX]),
                    
                    .d_out(d_out[(INDEX*WIDTH)+:WIDTH])
                );
                end
                else
                begin
                // COL:  0      1      2     3
                //       |      |      |     | 
                //      \|/    \|/    \|/   \|/
                // --->         X      X       
                // 
                // 
                assign b_ready_out[g_col] = pe_valid_out[LEFT_INDEX];
                process_element #(.WIDTH(WIDTH), .VALID_REG(1)) pe_x // (2)
                (
                    .clk(clk),
                    .rst(rst),
                    .sync_rst(sync_rst),
                    .parallel_sum(parallel_sum),
                    .shift_en(shift_en[0]),
                    .shift_in(d_out[(RIGHT_INDEX*WIDTH)+:WIDTH]),
                    .d_in(),
                    .a_in(a_out_right[(LEFT_INDEX*WIDTH)+:WIDTH]), .b_in(w_b_in[(g_col*WIDTH)+:WIDTH]),
                    .a_out(a_out_right[(INDEX*WIDTH)+:WIDTH]), .b_out(b_out_down[(INDEX*WIDTH)+:WIDTH]),
                    .en(w_en), 
                    
                    .valid_in(pe_valid_out[RIGHT_INDEX]),
                    .valid_a(pe_valid_out[LEFT_INDEX]), .valid_b(b_valid_in[g_col]),
                    .valid_out(pe_valid_out[INDEX]),
                    
                    .d_out(d_out[(INDEX*WIDTH)+:WIDTH])
                ); 
                end               
            end
        end
        //first col with the last row and between first and last rows
        else if(g_col == 0)
        begin
                // COL:             0      1      2     3
                //                  |      |      |     | 
                //                 \|/    \|/    \|/   \|/
                // ROW: FIRST --->  X                   
                // ROW: 1     --->  X  
                // ROW: 2     --->  X  
                // ROW: LAST  --->  X
            if(g_row == ROWS-1)
            begin
                // COL:             0      1      2     3
                //                  |      |      |     | 
                //                 \|/    \|/    \|/   \|/
                // ROW: FIRST --->                     
                // ROW: 1     --->    
                // ROW: 2     --->    
                // ROW: LAST  --->  X
                assign a_ready_out[g_row] = pe_valid_out[UP_INDEX];
                process_element #(.WIDTH(WIDTH), .VALID_REG(1)) pe_x // (3) X
                (
                    .clk(clk),
                    .rst(rst),
                    .sync_rst(sync_rst),
                    .parallel_sum(parallel_sum),
                    .shift_en(shift_en[g_row]),
                    .shift_in(d_out[(RIGHT_INDEX*WIDTH)+:WIDTH]),
                    .d_in(),
                    .a_in(w_a_in[(g_row*WIDTH)+:WIDTH]), .b_in(b_out_down[(UP_INDEX*WIDTH)+:WIDTH]),
                    .a_out(a_out_right[(INDEX*WIDTH)+:WIDTH]), .b_out(b_out_most_down[0+:WIDTH]),
                    .en(w_en), 

                    .valid_in(pe_valid_out[RIGHT_INDEX]),
                    .valid_a(a_valid_in[g_row]), .valid_b(pe_valid_out[UP_INDEX]),
                    .valid_out(pe_valid_out[INDEX]),

                    .d_out(d_out[(INDEX*WIDTH)+:WIDTH])
                ); 
            end
            else
            begin
                // COL:             0      1      2     3
                //                  |      |      |     | 
                //                 \|/    \|/    \|/   \|/
                // ROW: FIRST --->                     
                // ROW: 1     --->  X  
                // ROW: 2     --->  X  
                // ROW: LAST  --->    
                assign a_ready_out[g_row] = pe_valid_out[UP_INDEX];
                process_element #(.WIDTH(WIDTH), .VALID_REG(1)) pe_x // (4) XX
                (
                    .clk(clk),
                    .rst(rst),
                    .sync_rst(sync_rst),
                    .parallel_sum(parallel_sum),
                    .shift_en(shift_en[g_row]),
                    .shift_in(d_out[(RIGHT_INDEX*WIDTH)+:WIDTH]),
                    .d_in(),
                    .a_in(w_a_in[(g_row*WIDTH)+:WIDTH]), .b_in(b_out_down[(UP_INDEX*WIDTH)+:WIDTH]),
                    .a_out(a_out_right[(INDEX*WIDTH)+:WIDTH]), .b_out(b_out_down[(INDEX*WIDTH)+:WIDTH]),
                    .en(w_en), 

                    .valid_in(pe_valid_out[RIGHT_INDEX]),
                    .valid_a(a_valid_in[g_row]), .valid_b(pe_valid_out[UP_INDEX]),
                    .valid_out(pe_valid_out[INDEX]),

                    .d_out(d_out[(INDEX*WIDTH)+:WIDTH])
                ); 
            end   
        end
        //not first row and not first col
        else  
        begin
                    // COL:           FIRST    1      2    LAST
                    //                  |      |      |     | 
                    //                 \|/    \|/    \|/   \|/
                    // ROW: FIRST --->                     
                    // ROW: 1     --->         X      X     X 
                    // ROW: 2     --->         X      X     X
                    // ROW: LAST  --->         X      X     X
            if(g_row == ROWS-1 && g_col == COLS -1)
            begin
                    // COL:           FIRST    1      2    LAST
                    //                  |      |      |     | 
                    //                 \|/    \|/    \|/   \|/
                    // ROW: FIRST --->                     
                    // ROW: 1     --->                        
                    // ROW: 2     --->                       
                    // ROW: LAST  --->                      X
                // wire last_pe_valid;
                // assign a_valid_most_right[g_row] = last_pe_valid;
                // assign b_valid_most_down [g_col] = last_pe_valid;

                process_element #(.WIDTH(WIDTH), .VALID_REG(1)) pe_x // (5)
                    (
                        .clk(clk),
                        .rst(rst),
                        .sync_rst(sync_rst),
                        .parallel_sum(parallel_sum),
                        .shift_en(shift_en[g_row]),
                        .shift_in('b0),
                        .d_in(),
                        .a_in(a_out_right[(LEFT_INDEX*WIDTH)+:WIDTH]), .b_in(b_out_down[(UP_INDEX*WIDTH)+:WIDTH]),
                        .a_out(a_out_most_right[(g_row*WIDTH)+:WIDTH]), .b_out(b_out_most_down[(g_col*WIDTH)+:WIDTH]),
                        .en(w_en), 

                        .valid_in(1'b0),
                        .valid_a(pe_valid_out[LEFT_INDEX]), .valid_b(pe_valid_out[UP_INDEX]),
                        .valid_out(pe_valid_out[INDEX]),

                        .d_out(d_out[(INDEX*WIDTH)+:WIDTH])
                        ); 
                end
                else if(g_row == ROWS -1)
                begin
                        // COL:           FIRST    1      2    LAST
                        //                  |      |      |     | 
                        //                 \|/    \|/    \|/   \|/
                        // ROW: FIRST --->                     
                        // ROW: 1     --->                        
                        // ROW: 2     --->                       
                        // ROW: LAST  --->         X      X       
                    process_element #(.WIDTH(WIDTH), .VALID_REG(1)) pe_x // (6)
                    (
                        .clk(clk),
                        .rst(rst),
                        .sync_rst(sync_rst),
                        .parallel_sum(parallel_sum),
                        .shift_en(shift_en[g_row]),
                        .shift_in(d_out[(RIGHT_INDEX*WIDTH)+:WIDTH]),
                        .d_in(),
                        .a_in(a_out_right[(LEFT_INDEX*WIDTH)+:WIDTH]), .b_in(b_out_down[(UP_INDEX*WIDTH)+:WIDTH]),
                        .a_out(a_out_right[(INDEX*WIDTH)+:WIDTH]), .b_out(b_out_most_down[(g_col*WIDTH)+:WIDTH]),
                        .en(w_en), 

                        .valid_in(pe_valid_out[RIGHT_INDEX]),
                        .valid_a(pe_valid_out[LEFT_INDEX]), .valid_b(pe_valid_out[UP_INDEX]),
                        .valid_out(pe_valid_out[INDEX]),

                        .d_out(d_out[(INDEX*WIDTH)+:WIDTH])
                    ); 
                end
                else if(g_col == COLS -1) 
                begin
                        // COL:           FIRST    1      2    LAST
                        //                  |      |      |     | 
                        //                 \|/    \|/    \|/   \|/
                        // ROW: FIRST --->                        (b_)
                        // ROW: 1     --->                      X 
                        // ROW: 2     --->                      X
                        // ROW: LAST  --->                      
                    process_element #(.WIDTH(WIDTH), .VALID_REG(1)) pe_x // (7)
                    (
                        .clk(clk),
                        .rst(rst),
                        .sync_rst(sync_rst),
                        .parallel_sum(parallel_sum),
                        .shift_en(shift_en[g_row]),
                        .shift_in('b0),
                        .d_in(),
                        .a_in(a_out_right[(LEFT_INDEX*WIDTH)+:WIDTH]), .b_in(b_out_down[(UP_INDEX*WIDTH)+:WIDTH]),
                        .a_out(a_out_most_right[(g_row*WIDTH)+:WIDTH]), .b_out(b_out_down[(INDEX*WIDTH)+:WIDTH]),
                        .en(w_en), 

                        .valid_in(1'b0),
                        .valid_a(pe_valid_out[LEFT_INDEX]), .valid_b(pe_valid_out[UP_INDEX]),
                        .valid_out(pe_valid_out[INDEX]),

                        .d_out(d_out[(INDEX*WIDTH)+:WIDTH])
                    ); 
                end
                else
                begin
                        // COL:           FIRST    1      2    LAST
                        //                  |      |      |     | 
                        //                 \|/    \|/    \|/   \|/
                        // ROW: FIRST --->                     
                        // ROW: 1     --->         X      X         
                        // ROW: 2     --->         X      X       
                        // ROW: LAST  --->        
                    process_element #(.WIDTH(WIDTH), .VALID_REG(1)) pe_x // (8)
                    (
                    .clk(clk),
                    .rst(rst),
                    .sync_rst(sync_rst),
                    .parallel_sum(parallel_sum),
                    .shift_en(shift_en[g_row]),
                    .shift_in(d_out[(RIGHT_INDEX*WIDTH)+:WIDTH]),
                    .d_in(),
                    
                    .a_in(a_out_right[(LEFT_INDEX*WIDTH)+:WIDTH]), .b_in(b_out_down[(UP_INDEX*WIDTH)+:WIDTH]),
                    .a_out(a_out_right[(INDEX*WIDTH)+:WIDTH]), .b_out(b_out_down[(INDEX*WIDTH)+:WIDTH]),
                    
                    .en(w_en), 

                    .valid_in(pe_valid_out[RIGHT_INDEX]),
                    .valid_a(pe_valid_out[LEFT_INDEX]), .valid_b(pe_valid_out[UP_INDEX]),
                    .valid_out(pe_valid_out[INDEX]),

                    .d_out(d_out[(INDEX*WIDTH)+:WIDTH])
                ); 
            end
        end




    end

end
endgenerate
endmodule
