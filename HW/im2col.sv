module im2col #(parameter DEPTH = 5, WIDTH = 8)
(
    input  logic        clk,
    input  logic        rst,
    input  logic        i_start,
//  input  logic        i_en,
    input  logic  [7:0] base_address,
    input  logic  [4:0] max_windows,

    input  logic  [7:0] w_i,  
    input  logic  [7:0] h_i,  
    input  logic  [7:0] w_f,  
    input  logic  [7:0] h_f,  

    output logic  [DEPTH-1:0]    o_valid,
    output logic                 o_done,
    output logic  [7:0]          o_addr1,
    output logic  [7:0]          o_addr2,
    output logic  [7:0]          o_addr3,
    output logic  [7:0]          o_addr4,
    output logic  [7:0]          o_addr5
);
localparam TRACKER_WIDTH = $clog2(DEPTH+1);

logic [7:0]                 o_window_addr;
logic                       o_window_valid;
logic                       o_window_done;
logic                       i_window_en;

logic [7:0]                 o_window_size;


logic                       fifo_wr_en;
logic                       fifo_rd_en;
logic                       fifo_sync_rst;
logic [7:0]                 fifo_wr_data;
logic                       fifo_full;
logic                       fifo_empty;

logic [TRACKER_WIDTH-1:0]   o_fifo_counter;
logic [(DEPTH*WIDTH)-1:0]   o_fifo_data;


logic                       i_elem_start;
logic                       i_elem_en;
logic [7:0]                 o_elem_offset;
logic                       o_elem_valid;
logic                       o_elem_done;


assign      i_window_en     =   !fifo_full;

assign      fifo_rd_en      =   0;

assign      fifo_wr_en      =   o_window_valid;
assign      fifo_wr_data    =   o_window_addr;
assign      fifo_sync_rst   =   o_elem_done;

assign      i_elem_start    =   fifo_full || o_window_done;
assign      i_elem_en       =   1;

assign      o_done          =   o_window_done && o_elem_done;




addr_generator #(.MODE(0)) window_addr_generator
(
    .clk(clk),
    .rst(rst),
    .i_start(i_start),
    .i_en(i_window_en),
    .base_address(base_address),
    .max_windows(max_windows),
    .w_i(w_i),  
    .h_i(h_i),  
    .w_f(w_f),  
    .h_f(h_f),  
    .o_addr (o_window_addr),
    .o_valid(o_window_valid),
    .o_done (o_window_done),
    .o_size (o_window_size)
);

custom_fifo #(.WIDTH(8), .DEPTH(DEPTH)) window_buffer
(
    /* input   logic               */     .clk(clk),
    /* input   logic               */     .rst(rst),

    /* input   logic               */     .sync_rst(fifo_sync_rst),
    /* input   logic   [WIDTH-1:0] */     .wr_data(fifo_wr_data),
    /* input   logic               */     .wr_en(fifo_wr_en),
    /* input   logic               */     .rd_en(fifo_rd_en),
    /* output  logic   [WIDTH-1:0] */     .rd_data(rd_data),
    /* output  logic               */     .full(fifo_full),
    /* output  logic               */     .empty(fifo_empty),
                                          .o_counter(o_fifo_counter),
                                          .o_data(o_fifo_data)

);

addr_generator #(.MODE(1)) element_addr_generator
(
    .clk(clk),
    .rst(rst),
    .i_start(i_elem_start),
    .i_en(i_elem_en),
    .base_address(base_address),
    .max_windows(max_windows),
    .w_i(w_i),  
    .h_i(h_i),  
    .w_f(w_f),  
    .h_f(h_f),  
    .o_addr(o_elem_offset),
    .o_valid(o_elem_valid),
    .o_done(o_elem_done)
);

always@(*)
begin
    for (int x = 0; x<DEPTH; x++)//0 1 2 3 4
    begin
        o_valid[x] = x<=(o_fifo_counter-1)? o_elem_valid : 1'b0 ;
        $display("x: %d, (o_fifo_counter-1): %d", x, (o_fifo_counter-1));
    end
end

always@(*)
begin
    o_addr1 = o_fifo_data[(8*0)+:8] + o_elem_offset;
    o_addr2 = o_fifo_data[(8*1)+:8] + o_elem_offset;
    o_addr3 = o_fifo_data[(8*2)+:8] + o_elem_offset;
    o_addr4 = o_fifo_data[(8*3)+:8] + o_elem_offset;
    o_addr5 = o_fifo_data[(8*4)+:8] + o_elem_offset;
end

endmodule