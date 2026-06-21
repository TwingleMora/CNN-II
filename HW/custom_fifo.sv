module custom_fifo #(parameter DEPTH = 5, WIDTH = 8, localparam TRACKER_WIDTH = $clog2(DEPTH+1)) //custom valid signals for systolic array buffers
(



    input   logic                   clk,
    input   logic                   rst,

    input   logic                   sync_rst,

    input   logic   [WIDTH-1:0]     wr_data,
    input   logic                   wr_en,

    input   logic                   rd_en,
    output  logic   [WIDTH-1:0]     rd_data,

    output  logic                   full,
    output  logic                   empty,


    output  logic   [TRACKER_WIDTH-1:0]   o_counter,
    output  logic   [(DEPTH*WIDTH)-1:0]   o_data
);



fifo #(.DEPTH(DEPTH), .WIDTH(WIDTH)) fifo_core
(
    /* input   logic               */     .clk(clk),
    /* input   logic               */     .rst(rst),
    /* input   logic               */     .sync_rst(sync_rst),
    /* input   logic   [WIDTH-1:0] */     .wr_data(wr_data),
    /* input   logic               */     .wr_en(wr_en),
    /* input   logic               */     .rd_en(rd_en),
    /* output  logic   [WIDTH-1:0] */     .rd_data(rd_data),
    /* output  logic               */     .full(full),
    /* output  logic               */     .empty(empty),
                                          .o_counter(o_counter),
                                          .o_data(o_data)
);




endmodule