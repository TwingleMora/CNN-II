module systolic_array #(
    parameter WIDTH = 8,
    parameter ROWS = 2,
    parameter COLS = 2
) (
    input   logic                       clk,
    input   logic                       rst,
    input   logic                       sync_rst,

    input   logic   [WIDTH-1:0]         max_rows,
    input   logic   [WIDTH-1:0]         max_cols,
    input   logic   [WIDTH-1:0]         max_common,

    input   logic                       parallel_sum,
    input   logic   [WIDTH-1:0]         d1_in,
    input   logic   [WIDTH-1:0]         d2_in,
    input   logic   [WIDTH-1:0]         d3_in,
    input   logic   [WIDTH-1:0]         d4_in,
    output  logic                       p1_ready_out,
    output  logic                       p2_ready_out,
    output  logic                       p3_ready_out,
    input   logic                       a1_valid_in,
    input   logic                       a2_valid_in,
    input   logic                       b1_valid_in,
    input   logic                       b2_valid_in,

    input   logic   [WIDTH-1:0]         a1_in,
    input   logic   [WIDTH-1:0]         a2_in,
    input   logic   [WIDTH-1:0]         b1_in,
    input   logic   [WIDTH-1:0]         b2_in,
    input   logic                       en,


    output  logic                       done


);


    logic   [WIDTH-1:0]         d1_out;
    logic   [WIDTH-1:0]         d2_out;
    logic   [WIDTH-1:0]         d3_out;
    logic   [WIDTH-1:0]         d4_out;

    logic                       pe0_valid_out;
    logic                       pe1_valid_out;
    logic                       pe2_valid_out;
    logic                       pe3_valid_out;


    logic   [WIDTH-1:0]         a12_out;
    
    logic   [WIDTH-1:0]         b13_out;

    logic   [WIDTH-1:0]         b24_out;
    logic   [WIDTH-1:0]         a34_out;


assign p1_ready_out = en;

assign p2_ready_out = pe0_valid_out;

assign p3_ready_out = pe0_valid_out;



wire logic [7:0]  max_mat = max_cols + max_rows;
wire logic [7:0]  max_main_cycles = max_common > max_mat? max_mat+(max_common-max_mat) : max_mat;
logic [7:0] no_main_cycles;
logic       sec_done;

wire logic main_counter_en = !(a1_valid_in && b1_valid_in) && sec_done && en || (a1_valid_in && b1_valid_in) && !sec_done && en;

counter #(.WIDTH(8)) main_counter (
    .clk(clk),
    .rst(rst),
    .i_sync_rst(sync_rst),
    .i_load(1'b0),
    .i_enable(main_counter_en),

    .i_load_data('b0),
    .o_count(no_main_cycles)
);

logic [7:0] no_sec_cycles;
counter #(.WIDTH(8)) secondary_counter (
    .clk(clk),
    .rst(rst),
    .i_sync_rst(sync_rst),
    .i_load(1'b0),
    .i_enable(a1_valid_in && b1_valid_in && en),

    .i_load_data('b0),
    .o_count(no_sec_cycles)
);


assign done = (no_main_cycles == max_main_cycles);

assign sec_done = (no_sec_cycles == max_common);


process_element #(.WIDTH(8), .VALID_REG(1)) pe1
(
    /* input   logic               */  .clk(clk),
    /* input   logic               */  .rst(rst),
    /* input   logic               */  .sync_rst(sync_rst),
    /* input   logic               */  .parallel_sum(parallel_sum),
    /* input   logic   [WIDTH-1:0] */  .a_in(a1_in),
    /* input   logic   [WIDTH-1:0] */  .b_in(b1_in),
    
                                       .shift_en('b0),
                                       .shift_in('b0),
    /* input   logic               */  .valid_a(a1_valid_in),
    /* input   logic               */  .valid_b(b1_valid_in),
    /* input   logic               */  .valid_in('b0),
    
    /* output  logic               */  .valid_out(pe0_valid_out),
    /* input   logic            */     .en(en),
    /* output  logic   [WIDTH-1:0] */  .a_out(a12_out),
    /* output  logic   [WIDTH-1:0] */  .b_out(b13_out),
    /* output  logic   [WIDTH-1:0] */  .d_out(d1_out)
);

process_element #(.WIDTH(8), .VALID_REG(1)) pe2
(
    /* input   logic               */  .clk(clk),
    /* input   logic               */  .rst(rst),
    /* input   logic               */  .sync_rst(sync_rst),
    /* input   logic               */  .parallel_sum(parallel_sum),
    /* input   logic   [WIDTH-1:0] */  .a_in(a12_out),
    /* input   logic   [WIDTH-1:0] */  .b_in(b2_in),

                                       .shift_en('b0),
                                       .shift_in('b0),
    /* input   logic               */  .valid_a(pe0_valid_out),
    /* input   logic               */  .valid_b(b2_valid_in),
    /* input   logic               */  .valid_in('b0),


    /* output  logic               */  .valid_out(pe1_valid_out),
    /* input   logic               */  .en(en),
    /* output  logic   [WIDTH-1:0] */  .a_out(),
    /* output  logic   [WIDTH-1:0] */  .b_out(b24_out),
    /* output  logic   [WIDTH-1:0] */  .d_out(d2_out)
);


process_element #(.WIDTH(8), .VALID_REG(1)) pe3
(
    /* input   logic               */  .clk(clk),
    /* input   logic               */  .rst(rst),
    /* input   logic               */  .sync_rst(sync_rst),
    /* input   logic               */  .parallel_sum(parallel_sum),
    /* input   logic   [WIDTH-1:0] */  .a_in(a2_in),
    /* input   logic   [WIDTH-1:0] */  .b_in(b13_out),

                                       .shift_en('b0),
                                       .shift_in('b0),
    /* input   logic               */  .valid_a(a2_valid_in),
    /* input   logic               */  .valid_b(pe0_valid_out),
    /* input   logic               */  .valid_in('b0),
    
    /* output  logic               */  .valid_out(pe2_valid_out),
    /* input   logic               */  .en(en),
    /* output  logic   [WIDTH-1:0] */  .a_out(a34_out),
    /* output  logic   [WIDTH-1:0] */  .b_out(),
    /* output  logic   [WIDTH-1:0] */  .d_out(d3_out)
);


process_element #(.WIDTH(8)) pe4
(
    /* input   logic               */  .clk(clk),
    /* input   logic               */  .rst(rst),
    /* input   logic               */  .sync_rst(sync_rst),
    /* input   logic               */  .parallel_sum(parallel_sum),
    /* input   logic   [WIDTH-1:0] */  .a_in(a34_out),
    /* input   logic   [WIDTH-1:0] */  .b_in(b24_out),

                                       .shift_en('b0),
                                       .shift_in('b0),
    /* input   logic               */  .valid_a(pe1_valid_out),
    /* input   logic               */  .valid_b(pe2_valid_out),
    /* input   logic               */  .valid_in('b0),
                                       .valid_out(pe3_valid_out),
    /* input   logic               */  .en(en),

    /* output  logic   [WIDTH-1:0] */  .a_out(),
    /* output  logic   [WIDTH-1:0] */  .b_out(),
    /* output  logic   [WIDTH-1:0] */  .d_out(d4_out)
);
    
endmodule