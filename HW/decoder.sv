module decoder #(parameter IN_NO = 3, localparam OUTPUT_NO = (2 << (IN_NO-1)) )
(
    input   logic                       en,
    input   logic   [IN_NO-1:0]         in,
    output  logic   [OUTPUT_NO-1:0]     out

);

integer i;
always@(*)
begin
 out = en? 1 << in : 0;
end


endmodule