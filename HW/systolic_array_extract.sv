module systolic_array_extract #(
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

    input   logic                             shift_enable,
    input   logic                             parallel_sum,

    input   logic   [ROWS*WIDTH-1:0]          a_in,
    input   logic   [ROWS-1:0]                a_valid_in,
    output  logic   [ROWS-1:0]                a_ready_out,
    
    input   logic   [COLS*WIDTH-1:0]          b_in,
    input   logic   [COLS-1:0]                b_valid_in,
    output  logic   [COLS-1:0]                b_ready_out,

    // output  logic   [(ROWS*COLS*WIDTH)-1:0]   d_out,        

    input   logic                             en,
    output  logic                             wait_input,
    output  logic   [(WIDTH)-1:0]             sys_d_out, 
    output  logic                             sys_v_out,
    output  logic                             extract_done,   
    output  logic                             done



);

localparam SEL_WIRES_NO = $clog2(ROWS);
logic   [(ROWS*WIDTH)-1:0]        d_row_out;
logic   [(ROWS)-1:0]              v_row_out;

logic   [ROWS-1:0]                shift_en;

logic [PARAM_WIDTH-1:0] col_count;
logic [PARAM_WIDTH-1:0] row_count;



wire logic  row_counter_en   = col_count == COLS-1;
assign      extract_done     = (row_count == max_rows-1) & row_counter_en;

counter #(.WIDTH(PARAM_WIDTH)) row_counter (
    .clk(clk),
    .rst(rst),
    .i_sync_rst(sync_rst || extract_done),
    .i_load(1'b0),
    .i_enable(row_counter_en),
    .i_load_data('b0),
    .o_count(row_count)
);


counter #(.WIDTH(PARAM_WIDTH)) column_counter (
    .clk(clk),
    .rst(rst),
    .i_sync_rst(sync_rst || row_counter_en),
    .i_load(1'b0),
    .i_enable(shift_enable),
    .i_load_data('b0),
    .o_count(col_count)
);


mux #(.IN_SEL_NO(SEL_WIRES_NO), .WIDTH(WIDTH)) systolic_mux_data 
(
    .sel(row_count),
    .in(d_row_out),
    .out(sys_d_out)
);

mux #(.IN_SEL_NO(SEL_WIRES_NO), .WIDTH(1)) systolic_mux_valid 
(
    .sel(row_count),
    .in(v_row_out),
    .out(sys_v_out)
);

decoder #(.IN_NO(ROWS)) systolic_dec //$clog2(ROWS)   3 : 2, 4:2, 5:3 
(
    .en(shift_enable),
    .in(row_count),
    .out(shift_en) //3
);



systolic_array_auto #(
    .PARAM_WIDTH(PARAM_WIDTH),
    .WIDTH(WIDTH),
    .ROWS(ROWS),
    .COLS(COLS)
) DUT
(
    /* input   logic                     */         .clk(clk),
    /* input   logic                     */         .rst(rst),
    /* input   logic                     */         .sync_rst(sync_rst),
    /* input   logic   [PARAM_WIDTH-1:0] */         .max_rows(max_rows),
    /* input   logic   [PARAM_WIDTH-1:0] */         .max_cols(max_cols),
    /* input   logic   [PARAM_WIDTH-1:0] */         .max_common(max_common),


    /* input   logic                     */         .shift_en(shift_en),
    /* input   logic                     */         .parallel_sum(parallel_sum),

    /* input   logic   [ROWS*WIDTH-1:0]  */         .a_in(a_in),
    /* input   logic   [COLS*WIDTH-1:0]  */         .b_in(b_in),

    /* input   logic   [ROWS-1:0]        */         .a_valid_in(a_valid_in),
    /* input   logic   [COLS-1:0]        */         .b_valid_in(b_valid_in),

    /* input   logic   [ROWS-1:0]        */         .a_ready_out(a_ready_out),
    /* input   logic   [COLS-1:0]        */         .b_ready_out(b_ready_out),
    /* input   logic                     */         .en(en),
    /* output  logic                     */         .done(done),
                                                    .wait_input(wait_input),
    /* output  logic   [(ROWS*WIDTH)-1:0] */        .d_row_out(d_row_out), 
    /* output  logic   [WIDTH-1:0]        */        .v_row_out(v_row_out)

);





endmodule