module mux #(parameter IN_SEL_NO = 3, WIDTH = 8, localparam IN_NO = 2<<(IN_SEL_NO-1))
(
    input   logic   [IN_SEL_NO-1:0]       sel,
    input   logic   [IN_NO*WIDTH-1:0]   in,
    output  logic   [WIDTH-1:0]         out
);

integer i;
always@(*)
begin
    out = 0;
    for(i = 0; i<IN_NO; i++)
    begin
        if(sel == i)
        begin
            out = in[(i*WIDTH)+:WIDTH];
        end
    end
end


endmodule