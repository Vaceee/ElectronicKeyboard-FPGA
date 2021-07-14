module Keyboard_PS2(
    input clk, rst,
    input k_clk,
    input k_data,
    output reg[31:0]keycode
    );
    wire k_clk_f, k_data_f;
    reg[7:0] data_cur, data_prev, data_tmp;
    reg[3:0] count;
    reg flag;

    Keyboard_Debouncer debouncer(
        .clk(clk),.iclk(k_clk),.idata(k_data),.oclk(k_clk_f),.odata(k_data_f)
    );

    initial
    begin
        keycode<=0'h00000000;
        count<=4'b0000;
        flag<=1'b0;
    end

    always@(negedge k_clk_f)
    begin
        case(count)
            0:;  //start
            1: data_cur[0]<=k_data_f;
            2: data_cur[1]<=k_data_f;
            3: data_cur[2]<=k_data_f;
            4: data_cur[3]<=k_data_f;
            5: data_cur[4]<=k_data_f;
            6: data_cur[5]<=k_data_f;
            7: data_cur[6]<=k_data_f;
            8: data_cur[7]<=k_data_f;
            9: flag<=1'b1;
            10:flag<=1'b0;   //stop
        endcase
        if(count<=9) count<=count+1;
        else if(count==10) count<=0;
    end

    always@(posedge flag, negedge rst)
    begin
    if(~rst)
        keycode<=32'h00000000;
    else
        begin
        keycode<={keycode[23:8],data_prev,data_cur}; //recycle record
        data_prev<=data_cur;
        end
    end

endmodule
