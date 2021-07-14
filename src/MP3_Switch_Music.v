module MP3_Switch_Music(
    input clk,
    input prev,
    input next,
    output reg[1:0] select=0
    );
    localparam SONG_NUM=4;
    integer clk_count=400000; //0.4MHz
    always@(posedge clk)
    begin
        if(clk_count>=400000)
            begin
            clk_count<=0;
            if(prev)
                select<=(select==2'b00)? SONG_NUM-1: select-2'b01;
            else if(next)
                select<=(select==SONG_NUM-1)? 2'b000: select+2'b01;
            end
        else
            clk_count<=clk_count+1;
    end
endmodule
