module MP3_Adjust_Vol(
    input clk,
    input up_vol,
    input down_vol,
    output reg[15:0] vol=16'h0000,
    output reg[3:0] vol_class=4'd4
    );
    /*16位寄存器vol 高8位和低8位分别控制MP3左右声道的音量
    范围为0~254 每增加1表示音量降低0.5db
    即vol范围为0x0000~0xFEFE 0x0000时音量最大*/
    wire [15:0] adjust_vol;
    assign adjust_vol=vol;
    integer clk_count=500000; //0.5MHz

    always@(posedge clk)
    begin
        if(clk_count==500000)
            begin
            if(up_vol)
                begin
                    clk_count<=0;
                    vol<=(vol==16'h0000)?16'h0000:(vol-16'h2222);
                end
            else if(down_vol)
                begin
                clk_count<=0;
                vol<=(vol==16'h8888)?16'h8888:(vol+16'h2222);
                end
            end
        else
            clk_count<=clk_count+1;
    end

    always@(posedge clk)
    begin
    if(adjust_vol>=16'h8888)
        vol_class<=4'd0;
    else if(adjust_vol<16'h8888 && adjust_vol>=16'h6666)
        vol_class<=4'd1;
    else if(adjust_vol<16'h6666 && adjust_vol>=16'h4444)
        vol_class=4'd2;
    else if(adjust_vol<16'h4444 && adjust_vol>=16'h2222)
        vol_class=4'd3;
    else if(adjust_vol<16'h2222 && adjust_vol>=16'h0000)
        vol_class=4'd4;
    end

endmodule
