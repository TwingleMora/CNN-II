module systolic_array_extract_tb;

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



logic                       a1_valid_in;
logic                       a2_valid_in;
logic                       b1_valid_in;
logic                       b2_valid_in;

logic                       done;

/////////////////////////////////////////
localparam ROWS = 2;
localparam COLS = 2;

logic                             shift_enable;
logic                             parallel_sum;
logic                             sync_rst;

logic   [ROWS*WIDTH-1:0]          a_in;
logic   [COLS*WIDTH-1:0]          b_in;

logic   [ROWS-1:0]                a_valid_in;
logic   [COLS-1:0]                b_valid_in;

logic   [ROWS-1:0]                a_ready_out;
logic   [COLS-1:0]                b_ready_out;

logic                             wait_input;

logic   [(WIDTH)-1:0]             sys_d_out; 
logic                             sys_v_out;
logic                             extract_done;  


systolic_array_extract #(
    .PARAM_WIDTH(8),
    .WIDTH(8),
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
    /* input   logic                     */         .shift_enable(shift_enable),
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

    /* output  logic   [(WIDTH)-1:0]     */         .sys_d_out(sys_d_out), 
    /* output  logic                     */         .sys_v_out(sys_v_out),
    /* output  logic                     */         .extract_done(extract_done)
                                                    

);



assign a_in[0+:WIDTH] = a1_in;
assign a_in[1*WIDTH+:WIDTH] = a2_in;

assign b_in[0+:WIDTH] = b1_in;
assign b_in[1*WIDTH+:WIDTH] = b2_in;

assign a_valid_in[0] = a1_valid_in;
assign a_valid_in[1] = a2_valid_in;
assign b_valid_in[0] = b1_valid_in;
assign b_valid_in[1] = b2_valid_in;

assign p1_ready_out = a_ready_out[0] & b_ready_out[0];
assign p2_ready_out = b_ready_out[1]; 
assign p3_ready_out = a_ready_out[1]; 


logic [7:0] q_a1_in [$];
logic [7:0] q_a2_in [$];
logic [7:0] q_b1_in [$];
logic [7:0] q_b2_in [$];

task init;

max_rows    <=  3;
max_cols    <=  3;
max_common  <=  5;
en  <= 0;
shift_enable <= 0;
parallel_sum <= 0;

a1_valid_in <= 0;
a2_valid_in <= 0;
b1_valid_in <= 0;
b2_valid_in <= 0;

endtask
task load();
q_a1_in = {1,2,3};
q_a2_in = {4,5,6};

q_b1_in = {1,2,3};
q_b2_in = {4,5,6};

// q_a1_in = {1,2};
// q_a2_in = {3,4};

// q_b1_in = {1,2};
// q_b2_in = {1,2};


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
    
    en<=1;

    while(!done)
    begin
        push();
        @(posedge clk);
        if(wait_input)
        begin
            q_a1_in = {0};
            q_a2_in = {0};
            q_b1_in = {0};
            q_b2_in = {0};
        end
    end
    en <= 0;
    // sync_rst <= 1;
    // load();
    @(posedge clk);
    sync_rst <= 0;
    shift_enable <= 1;
    repeat(10)
    begin
        @(posedge clk);
    end
    shift_enable <= 0;
    @(posedge clk);
    /* en <= 1;
    while(!done)
    begin
        push();
        @(posedge clk);
    end
    @(posedge clk);
    en <= 0;
    
    @(posedge clk); */
    @(posedge clk);
    $stop;


end

endmodule