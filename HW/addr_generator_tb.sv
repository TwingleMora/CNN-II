module addr_generator_tb;


bit clk;
bit rst;

always #5 clk <= ~clk;

logic i_start;
logic i_en;
logic [7:0] base_address;

logic [4:0] max_windows;
assign max_windows = 2;


logic [7:0] o_addr;
logic       o_valid;
logic       o_done;


logic [7:0] w_i;
logic [7:0] h_i;

logic [7:0] w_f;
logic [7:0] h_f;


logic       sync_rst;
logic [7:0] wr_data;
logic       wr_en;
logic       rd_en;
logic       full;

logic proc_reset;

assign wr_en    =   o_valid;
assign rd_en    =   1'b0;
assign wr_data  =   o_addr;
assign i_en     =   !full;  

assign sync_rst =   o_done || proc_reset;

//DUT
addr_generator DUT
(
    .clk(clk),
    .rst(rst),
    .i_start(i_start),
    .i_en(i_en),
    .base_address(base_address),
    .max_windows(max_windows),
    .w_i(w_i),  
    .h_i(h_i),  
    .w_f(w_f),  
    .h_f(h_f),  
    .o_addr(o_addr),
    .o_valid(o_valid),
    .o_done(o_done)
);

fifo #(.WIDTH(8), .DEPTH(2)) window_buffer
(
    /* input   logic               */     .clk(clk),
    /* input   logic               */     .rst(rst),
    /* input   logic               */     .sync_rst(sync_rst),
    /* input   logic   [WIDTH-1:0] */     .wr_data(wr_data),
    /* input   logic               */     .wr_en(wr_en),
    /* input   logic               */     .rd_en(rd_en),
    /* output  logic   [WIDTH-1:0] */     .rd_data(rd_data),
    /* output  logic               */     .full(full),
    /* output  logic               */     .empty(empty)
);


initial begin
    proc_reset = 0;
    rst <= 0;
    @(posedge clk)
    rst <= 1;

    w_i <= 4;
    h_i <= 4;

    w_f <= 3;
    h_f <= 3;

    i_start <= 1;
    // i_en = 1;
    
    repeat(10)
    @(posedge clk);

    proc_reset = 1;
    @(posedge clk)
    proc_reset = 0;
    
    repeat(10)
    @(posedge clk);
    

    $stop;
end


endmodule