module fifo #(parameter DEPTH = 5, WIDTH = 8, localparam TRACKER_WIDTH = $clog2(DEPTH+1))
(
    input   logic                       clk,
    input   logic                       rst,

    input   logic                       sync_rst,

    input   logic   [WIDTH-1:0]         wr_data,
    input   logic                       wr_en,

    input   logic                       rd_en,
    output  logic   [WIDTH-1:0]         rd_data,

    output  logic                       full,
    output  logic                       empty,

    output  logic   [TRACKER_WIDTH-1:0] o_counter,

    output  logic   [(DEPTH*WIDTH)-1:0]   o_data
);

//localparam TRACKER_WIDTH = $clog2(DEPTH+1);//1 -> DEPTH, 0 -> DEPTH - 1

logic   [TRACKER_WIDTH-1:0] counter;

logic   [TRACKER_WIDTH-1:0] wr_ptr;
logic   [TRACKER_WIDTH-1:0] rd_ptr;

logic   [WIDTH-1:0]         mem [DEPTH];

always@(*)
begin
    for(int x = 0; x<DEPTH; x++)
    begin
        o_data[(x*8)+:8] = mem[x];
    end
end

assign  o_counter   =   counter;

assign  full        =   counter == DEPTH;
assign  empty       =   counter ==  0;

logic   write;
logic   read;

assign  write = wr_en && !full;
assign  read  = rd_en && !empty;

always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        for (int i = 0; i<DEPTH; i++)
        begin
            mem[i] <= 'd0;
        end
    end
    else
    begin
        if(wr_en && !full)
        begin
            mem[wr_ptr] <= wr_data;
        end
    end
end


always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        wr_ptr <= 0;
    end
    else
    begin
        if(sync_rst)
        begin
            wr_ptr <= 0;
        end
        else if(wr_en && !full)
        begin
            wr_ptr <= wr_ptr + 1;
        end
    end
end

always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        rd_ptr <= 0;
    end
    else
    begin
        if(sync_rst)
        begin
            rd_ptr <= 0;
        end
        else if(rd_en && !empty)
        begin
            rd_ptr <= rd_ptr + 1;
        end
    end
end

always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        counter <= 0;
    end
    else
    begin
        if(sync_rst)
        begin
            counter <= 0;
        end
        else if(write && read)
        begin
            counter <= counter;
        end
        else if(write)
        begin
            counter <= counter + 1;
        end
        else if(read)
        begin
            counter <= counter - 1;
        end

    end


end



endmodule