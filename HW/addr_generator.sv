module addr_generator #(parameter MODE = 0)//0 -> windows positions, 1 -> elements positions
(
    input  logic clk,
    input  logic rst,

    input  logic        i_start,
    input  logic        i_en,

    input  logic  [7:0] base_address,
    input  logic  [4:0] max_windows,

    input  logic  [7:0] w_i,  
    input  logic  [7:0] h_i,  
    input  logic  [7:0] w_f,  
    input  logic  [7:0] h_f,  

    output logic  [7:0] o_addr,
    output logic        o_valid,
    output logic        o_done,
    output logic  [7:0] o_size
);

    // typedef enum logic [1:0] {IDLE, RUN, PAUSE, FINISH} state;
    wire  [7:0] col_max;
    wire  [7:0] row_max;
    generate
    if(MODE == 0)
    begin
    assign  col_max = w_i - w_f;
    assign  row_max = h_i - h_f;
    end    
    else
    begin
    assign  col_max = w_f-1;
    assign  row_max = h_f-1;
    end
    endgenerate
    
    
    logic [7:0] r_base_address;
    logic [7:0] r_row_start;

    logic [7:0] r_window_counter;
    logic [7:0] r_row_counter;
    logic [7:0] r_col_counter;
    logic [7:0] r_addr;
    logic       r_valid;
    logic       r_done;

    // assign  o_size = r_col_counter + r_row_counter;


    localparam IDLE = 0, INITIAL = 1, RUN = 2, PAUSE = 3, FINISH = 4;
    logic [2:0]       current_fsm;
    logic [2:0]       next_fsm;




    logic [7:0] comb_row_start;
    logic [7:0] comb_addr;
    logic       comb_valid;
    logic       comb_done;

    assign      o_addr  =   r_addr;   
    assign      o_valid =   r_valid;  
    assign      o_done  =   r_done; 

    //FSM
    logic   fsm_reg_en;
    assign  fsm_reg_en = 1;
    register#(.WIDTH(3)) fsm_state_register(
        .clk(clk),
        .rst(rst),
        .en(fsm_reg_en),
        .D(next_fsm),
        .Q(current_fsm)
    );



    //row_start register
    logic row_start_reg_en;
    assign row_start_reg_en = 1;
    register row_start_register(
        .clk(clk),
        .rst(rst),
        .en(row_start_reg_en),
        .D(comb_row_start),
        .Q(r_row_start)
    );

    //address register
    logic addr_reg_en;
    assign addr_reg_en = 1;
    register #(.WIDTH(8)) addr_register(
        .clk(clk),
        .rst(rst),
        .en(addr_reg_en),
        .D(comb_addr),
        .Q(r_addr)
    );

    //valid register
    logic valid_reg_en;
    assign valid_reg_en = 1;
    register #(.WIDTH(1)) valid_register(
        .clk(clk),
        .rst(rst),
        .en(valid_reg_en),
        .D(comb_valid),
        .Q(r_valid)
    );

    //done register
    logic done_reg_en;
    assign done_reg_en = 1;
    register #(.WIDTH(1)) done_register(
        .clk(clk),
        .rst(rst),
        .en(done_reg_en),
        .D(comb_done),
        .Q(r_done)
    );


    //window_counter
    logic window_counter_reset;
    // assign window_counter_reset = 1'b0;
    logic window_counter_en;
    counter window_counter_module (    
    .clk(clk),
    .rst(rst),
    .i_sync_rst(window_counter_reset),
    .i_load(1'b0),
    .i_load_data('b0),
    .i_enable(window_counter_en),
    .o_count(r_window_counter)
    );    

    //row_counter
    logic row_counter_reset;
    // assign row_counter_reset = 1'b0;
    logic row_counter_en;
    assign row_counter_en = (r_col_counter == col_max);
    counter row_counter_module (    
    .clk(clk),
    .rst(rst),
    .i_sync_rst(row_counter_reset),
    .i_load(1'b0),
    .i_load_data('b0),
    .i_enable(row_counter_en),
    .o_count(r_row_counter)
    );

    //col_counter
    logic col_counter_reset;
    assign col_counter_reset = (r_col_counter == col_max);;
    logic col_counter_en;
    
    counter col_counter_module (    
    .clk(clk),
    .rst(rst),
    .i_sync_rst(col_counter_reset),
    .i_load(1'b0),
    .i_load_data('b0),
    .i_enable(col_counter_en),
    .o_count(r_col_counter)
    );

    //col_counter
    always@(*)
    begin
        col_counter_en = 0;
        case(next_fsm)
        RUN:
        begin
            col_counter_en = 1;
        end
        endcase
    end
    //row_counter
    always@(*)
    begin
        row_counter_reset = 0;
        case(next_fsm)
        FINISH, IDLE:
        begin
            row_counter_reset = 1;
        end
        endcase
    end

    //window_counter
    always@(*)
    begin
        window_counter_en = 0;
        window_counter_reset = 0;
        case(next_fsm)
        RUN:
        begin
            window_counter_reset = 0;
            window_counter_en = 1;
        end
        IDLE, PAUSE, FINISH:
        begin
            window_counter_reset = 1;
        end
        endcase
    end

    //row_start_register
    always@(*)
    begin
        comb_row_start = r_row_start;
        case(next_fsm)
        IDLE:
        begin
            comb_row_start = 0;
        end
        RUN:
        begin
            if(r_col_counter == col_max)
            comb_row_start = r_row_start + w_i;
        end
        PAUSE:
        begin

        end
        FINISH:
        begin
            comb_row_start = 0;
        end
        endcase
    end

    //addr_register
    always@(*)
    begin
        comb_addr = r_addr;
        case(next_fsm)
        IDLE:
        begin
            comb_addr = r_row_start;
        end
        INITIAL:
        begin
            comb_addr = 0;
        end
        RUN:
        begin
            if(r_col_counter == col_max)
            comb_addr = r_row_start + w_i;
            else
            comb_addr = r_addr + 1;
        end
        PAUSE:
        begin

        end
        FINISH:
        begin
            comb_addr = 0;
        end
        endcase
    end


    //valid_register
    always@(*)
    begin
        comb_valid = 0;
        case(next_fsm)
        INITIAL, RUN, PAUSE:
        begin
                comb_valid = 1;
        end
        endcase
    end

    //done_register
    always@(*)
    begin
        comb_done = 0;
        case(next_fsm)
        FINISH:
        begin
            comb_done = 1;
        end
        endcase
    end

    //FSM
    always@(*)
    begin
        next_fsm = current_fsm;
        case(current_fsm)
        IDLE:
        begin
            if(i_start)
            next_fsm = INITIAL;
        end
        INITIAL:
        begin
            if((r_col_counter == col_max) && (r_row_counter == row_max))
               next_fsm = FINISH; 
            else if (i_en)//(r_window_counter == max_windows-1)
                next_fsm = RUN;
            else
                next_fsm = PAUSE;
        end
        RUN:
        begin
            if((r_col_counter == col_max) && (r_row_counter == row_max))
               next_fsm = FINISH; 
            else if (i_en)//(r_window_counter == max_windows-1)
                next_fsm = RUN;
            else
                next_fsm = PAUSE;
        end
        PAUSE:
        begin
            if(i_en)
                next_fsm = RUN;
            else
                next_fsm = PAUSE;
        end
        FINISH:
        begin
            next_fsm = IDLE;
        end
        endcase
    end

    







endmodule