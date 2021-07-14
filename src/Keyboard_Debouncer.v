module Keyboard_Debouncer(
    input clk,  //clk_50M
    input iclk, //PS2_clk--10Hz
    input idata,//PS2_data
    output reg oclk, //k_clk_f
    output reg odata //k_data_f
    );

    reg[4:0] count0, count1;
    reg Iv0=0, Iv1=0;
    
    always@(posedge clk)
    begin
    if(iclk==Iv0)
        begin
        if(count0==19)  //wait 20 cycles
            oclk<=iclk;
        else
            count0<=count0+1;
        end
    else
        begin
        count0<="00000";
        Iv0<=iclk;
        end
    if(idata==Iv1)
        begin
        if(count1==19)
            odata<=idata;
        else
            count1<=count1+1;
        end
    else
        begin
        count1<="00000";
        Iv1<=idata;
        end
    end

endmodule