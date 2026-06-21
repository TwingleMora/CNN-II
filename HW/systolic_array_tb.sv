module systolic_array_tb;

localparam WIDTH = 8;

bit clk;
bit rst;

always #5 clk <= ~clk;

logic [7:0] a1_in;
logic [7:0] a2_in;

logic [7:0] b1_in;
logic [7:0] b2_in;

logic       en;


logic   [WIDTH-1:0]         max_rows;
logic   [WIDTH-1:0]         max_cols;
logic   [WIDTH-1:0]         max_common; 

logic   [WIDTH-1:0]         d1_in;
logic   [WIDTH-1:0]         d2_in;
logic   [WIDTH-1:0]         d3_in;
logic   [WIDTH-1:0]         d4_in;



logic                       p1_ready_out;
logic                       p2_ready_out;
logic                       p3_ready_out;

logic                       sync_rst;
logic                       parallel_sum;
logic                       a1_valid_in;
logic                       a2_valid_in;
logic                       b1_valid_in;
logic                       b2_valid_in;

logic                       done;

systolic_array #(
    .WIDTH(8)
) DUT (
    .clk(clk),
    .rst(rst),
    /* input   logic               */         .sync_rst(sync_rst),

    /* input   logic   [WIDTH-1:0] */         .max_rows(max_rows),
    /* input   logic   [WIDTH-1:0] */         .max_cols(max_cols),
    /* input   logic   [WIDTH-1:0] */         .max_common(max_common),

    /* input   logic               */         .parallel_sum(parallel_sum),
    /* input   logic   [WIDTH-1:0] */         .d1_in(d1_in),
    /* input   logic   [WIDTH-1:0] */         .d2_in(d2_in),
    /* input   logic   [WIDTH-1:0] */         .d3_in(d3_in),
    /* input   logic   [WIDTH-1:0] */         .d4_in(d4_in),
    /* output  logic               */         .p1_ready_out(p1_ready_out),
    /* output  logic               */         .p2_ready_out(p2_ready_out),
    /* output  logic               */         .p3_ready_out(p3_ready_out),
    /* input   logic               */         .a1_valid_in(a1_valid_in),
    /* input   logic               */         .a2_valid_in(a2_valid_in),
    /* input   logic               */         .b1_valid_in(b1_valid_in),
    /* input   logic               */         .b2_valid_in(b2_valid_in),

    .a1_in(a1_in),
    .a2_in(a2_in),
    .b1_in(b1_in),
    .b2_in(b2_in),
    .en(en),

    .done(done)
);

logic [7:0] q_a1_in [$];
logic [7:0] q_a2_in [$];
logic [7:0] q_b1_in [$];
logic [7:0] q_b2_in [$];

task init;
max_rows    <=  2;
max_cols    <=  2;
max_common  <=  2;
en  <= 0;


endtask
task load();
q_a1_in = {1,2};
q_a2_in = {3,4};

q_b1_in = {1,2};
q_b2_in = {1,2};


a1_in <= q_a1_in.pop_front();
b1_in <= q_b1_in.pop_front();
a2_in <= q_a2_in.pop_front();
b2_in <= q_b2_in.pop_front();

a1_valid_in <= 1;
a2_valid_in <= 1;
b1_valid_in <= 1;
b2_valid_in <= 1;


endtask

task valid_in();
a1_valid_in <= q_a1_in.size()!=0;
a2_valid_in <= q_a2_in.size()!=0;
b1_valid_in <= q_b1_in.size()!=0;
b2_valid_in <= q_b2_in.size()!=0;
endtask

task push();
    
    valid_in();
    if(p1_ready_out)
    begin
        a1_in <= q_a1_in.pop_front();
        b1_in <= q_b1_in.pop_front();
    end
    else
    begin
        // a1_in <= 0;
        // b1_in <= 0;
    end
    if(p2_ready_out)
        a2_in <= q_a2_in.pop_front();
    else
    begin
        // a2_in <= 0;
    end
    if(p3_ready_out)
        b2_in <= q_b2_in.pop_front();
    else
    begin
        // b2_in <= 0;
    end
    

endtask

initial
begin
    init();
    load();
    rst <= 0;
    @(posedge clk);
    rst <= 1;
    sync_rst <= 0;
    parallel_sum <= 0;
    en<=1;

    repeat(4)
    begin
        push();
        @(posedge clk);
    end
    // en <= 0;
    sync_rst <= 1;
    load();
    @(posedge clk);
    sync_rst <= 0;
    @(posedge clk);
    en <= 1;
        repeat(4)
    begin
        push();
        @(posedge clk);
    end
    @(posedge clk);
    en <= 0;
    @(posedge clk);
    $stop;


end

endmodule