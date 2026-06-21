module counter #(parameter WIDTH = 8) (
    input logic clk,
    input logic rst,
    input logic i_sync_rst,
    input logic i_load,
    input logic i_enable,

    input logic [WIDTH-1:0] i_load_data,
    output logic [WIDTH-1:0] o_count
    );


    logic [4:0] r_count;
    
    assign o_count = r_count;
    always@(posedge clk or negedge rst)
    begin
        if(!rst)
        begin
            r_count <= 0;
        end
        else if(i_sync_rst)
        begin
            r_count <= 0;
        end
        else if(i_load)
        begin
            r_count <= i_load_data;
        end
        else if(i_enable)
        begin
            r_count<=r_count+1;
        end

    end


    endmodule