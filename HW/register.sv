module register #(parameter WIDTH = 8, parameter SYNC_RST = 0)
(
    input   logic               clk,
    input   logic               rst,
    input   logic               sync_rst,
    input   logic               en,
    input   logic   [WIDTH-1:0] D,
    output  logic   [WIDTH-1:0] Q

);

    always@(posedge clk or negedge rst)
    begin
        if(!rst)
        begin
            Q <= 0;
        end
        else if(SYNC_RST && sync_rst)
        begin
            Q <= 0;
        end
        else if(en)
        begin
            Q <= D;
        end

    end

endmodule