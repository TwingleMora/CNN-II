module process_element #(parameter WIDTH = 8, VALID_REG = 0)
(
    input   logic                       clk,
    input   logic                       rst,
    input   logic                       sync_rst,
    input   logic                       parallel_sum,
    input   logic                       shift_en,
    input   logic   [WIDTH-1:0]         shift_in,
    input   logic   [WIDTH-1:0]         d_in,
    input   logic   [WIDTH-1:0]         a_in,
    input   logic   [WIDTH-1:0]         b_in,
    input   logic                       en,
    input   logic                       valid_a,
    input   logic                       valid_b,
    
    input   logic                       valid_in,
    output  logic                       valid_out,

    output  logic   [WIDTH-1:0]         a_out,
    output  logic   [WIDTH-1:0]         b_out,

    output  logic   [WIDTH-1:0]         d_out
);

wire operand_reg_en = valid_out||(valid_a & valid_b & en);

wire w_valid = shift_en? valid_in : valid_out||(valid_a & valid_b & en); //|| !VALID_REG;

wire accum_reg_en = shift_en? 1'b1 : valid_out||(valid_a & valid_b & en);

wire w_valid_reg_en = shift_en? 1'b1 : !valid_out;
// generate
    // if(VALID_REG)
    // begin
        register#(.WIDTH(1), .SYNC_RST(1)) valid_reg
        (
            /* input   logic               */ .clk(clk),
            /* input   logic               */ .rst(rst),
                                              .sync_rst(sync_rst),
            /* input   logic               */ .en(w_valid_reg_en),
            /* input   logic   [WIDTH-1:0] */ .D(w_valid),
            /* output  logic   [WIDTH-1:0] */ .Q(valid_out)
        );

    // end
    // else
    // begin
        // assign valid_out = 1'b1;
    // end

// endgenerate
register#(.WIDTH(WIDTH), .SYNC_RST(1)) a_reg
(
    /* input   logic               */ .clk(clk),
    /* input   logic               */ .rst(rst),
                                      .sync_rst(sync_rst),
    /* input   logic               */ .en(operand_reg_en),
    /* input   logic   [WIDTH-1:0] */ .D(a_in),
    /* output  logic   [WIDTH-1:0] */ .Q(a_out)

);


register#(.WIDTH(WIDTH),.SYNC_RST(1)) b_reg
(
    /* input   logic               */ .clk(clk),
    /* input   logic               */ .rst(rst),
                                      .sync_rst(sync_rst),
    /* input   logic               */ .en(operand_reg_en),
    /* input   logic   [WIDTH-1:0] */ .D(b_in),
    /* output  logic   [WIDTH-1:0] */ .Q(b_out)

);


//accum reg
// logic [WIDTH-1:0] accum_reg;

logic [WIDTH-1:0] comb_a_in;
logic [WIDTH-1:0] comb_b_in;
logic [WIDTH-1:0] comb_mult;
logic [WIDTH-1:0] comb_parallel_mux_out;


logic [WIDTH-1:0] comb_accum_reg;


register#(.WIDTH(WIDTH), .SYNC_RST(1)) accum_reg
(
    /* input   logic               */ .clk(clk),
    /* input   logic               */ .rst(rst),
                                      .sync_rst(sync_rst),
    /* input   logic               */ .en(accum_reg_en), //valid_in : shift_en
    /* input   logic   [WIDTH-1:0] */ .D(comb_accum_reg),
    /* output  logic   [WIDTH-1:0] */ .Q(d_out)
);

always@(*)
begin
    comb_a_in = operand_reg_en? a_in : 0;
    comb_b_in = operand_reg_en? b_in : 0;
    comb_mult = comb_a_in * comb_b_in;    
end

always@(*)
begin
    comb_accum_reg = 0;
    case(shift_en)
    1'b0:comb_accum_reg = d_out + comb_parallel_mux_out;
    1'b1:comb_accum_reg = shift_in;
    endcase
end


always@(*)
begin
    comb_parallel_mux_out = 0;
    case(parallel_sum)
    1'b0: comb_parallel_mux_out = comb_mult;
    1'b1: comb_parallel_mux_out = d_in;
    endcase
end











endmodule