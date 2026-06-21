module im2col_tb;

localparam DEPTH = 5;
localparam WIDTH = 8;

bit clk;
bit rst;

always #5 clk <= ~clk;

    logic                 i_start;
    logic  [7:0]          base_address;
    logic  [4:0]          max_windows;
    logic  [7:0]          w_i;  
    logic  [7:0]          h_i;  
    logic  [7:0]          w_f;  
    logic  [7:0]          h_f;  
    logic  [DEPTH-1:0]    o_valid;
    logic                 o_done;
    logic  [7:0]          o_addr1;
    logic  [7:0]          o_addr2;
    logic  [7:0]          o_addr3;
    logic  [7:0]          o_addr4;
    logic  [7:0]          o_addr5;

//DUT
im2col #(.DEPTH(DEPTH), .WIDTH(WIDTH)) dut
(
    /* input  logic              */   .clk(clk),
    /* input  logic              */   .rst(rst),
    /* input  logic              */   .i_start(i_start),
    /* input  logic  [7:0]       */   .base_address(base_address),
    /* input  logic  [4:0]       */   .max_windows(max_windows),
    /* input  logic  [7:0]       */   .w_i(w_i),  
    /* input  logic  [7:0]       */   .h_i(h_i),  
    /* input  logic  [7:0]       */   .w_f(w_f),  
    /* input  logic  [7:0]       */   .h_f(h_f),  
    /* output logic  [DEPTH-1:0] */   .o_valid(o_valid),
    /* output logic              */   .o_done(o_done),
    /* output logic  [7:0]       */   .o_addr1(o_addr1),
    /* output logic  [7:0]       */   .o_addr2(o_addr2),
    /* output logic  [7:0]       */   .o_addr3(o_addr3),
    /* output logic  [7:0]       */   .o_addr4(o_addr4),
    /* output logic  [7:0]       */   .o_addr5(o_addr5)
);


initial
begin
    rst <= 0;
    @(posedge clk);
    rst <= 1;
    w_i <= 4;
    h_i <= 4;

    w_f <= 3;
    h_f <= 3;

    i_start <= 1;
    @(posedge clk);
    i_start <= 0;

    repeat(30)
    @(posedge clk);

    $stop;

end

initial 
begin
// wait(o_window_done)

end

endmodule