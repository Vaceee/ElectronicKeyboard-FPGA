module MP3_Driver(
    input DREQ_p, //数据请求
    output XRSET_p,//硬件复位
    output XCS_p, //片选输入_低电平有效
    output XDCS_p,//数据片选_字节同步
    output SI_p,  //串行数据输入
    output SCLK_p,//SPI时钟
    /*MP3控制*/
    input clk,  //系统时钟
    input clk_1,//MP3时钟
    input init,
    input [1:0]select,
    input [15:0]adjust_vol
    );
    localparam CMD_START=0; //开始写指令
    localparam WRITE_CMD=1; //指令写入结束
    localparam DATA_START=2;//开始写数据
    localparam WRITE_DATA=3;//数据写入结束
    localparam DELAY=4;     //延时
    localparam VOL_CMD_START=5; //开始调节音量指令
    localparam SEND_VOL_CMD=6;  //调节指令发送结束

    reg DREQ,XRSET,XCS,XDCS,SI,SCLK;
    assign DREQ_p=DREQ;
    assign XRSET_p=XRSET;
    assign XCS_p=XCS;
    assign XDCS_p=XDCS;
    assign SI_p=SI;
    assign SCLK_p=SCLK;

    reg[95:0] cmd={32'h02000804/*reg MODE reset*/,32'h020B0000/*reg VOL reset*/,32'hffffffff};
    reg[31:0] volcmd;      //音量指令
    reg[12:0] addr;
    wire[15:0] Data;
    reg [15:0] _Data;
    reg[2:0] pre=0;
    integer status=CMD_START;
    integer count=0,cmd_count=0;

    blk_mem_gen_music readmusic(.clka(clk),.ena(1),.addra({select,addr}),.douta(Data));

    always@(posedge clk_1)
    begin
    pre<=select;
    if(~init || pre!=select)
        begin
        XCS<=1;
        XDCS<=1;
        XRSET<=0;
        cmd_count<=0;
        status<=DELAY;
        SCLK<=0;
        count<=0;
        addr<=0;
        end
    else
        begin
        case(status)
        CMD_START:begin
            SCLK<=0;
            if(cmd_count>=3)
                status<=DATA_START;
            else if(DREQ)
                begin
                XCS<=0;
                status<=WRITE_CMD;
                SI<=cmd[95];
                cmd<={cmd[94:0],cmd[95]}; //implement serial input
                count<=1;
                end
            end
        WRITE_CMD:begin
            if(DREQ)
                begin
                if(SCLK)
                    begin
                    if(count>=32)
                        begin
                        XCS<=1;
                        count<=0;
                        cmd_count<=cmd_count+1;
                        status<=CMD_START;
                        end
                    else
                        begin
                        SI<=cmd[95];
                        cmd<={cmd[94:0],cmd[95]};
                        count<=count+1;
                        end
                    end
                SCLK<=~SCLK;
                end
            end
        DATA_START:begin
            if(adjust_vol[15:0]!=cmd[47:32]) //volume changed
                begin
                count<=0;
                volcmd<={16'h020B,adjust_vol}; //02:write command  0B:addr of reg VOL
                status<=VOL_CMD_START;    
                end
            else if(DREQ)
                begin
                XDCS<=0;
                SCLK<=0;
                SI<=Data[15];
                _Data<={Data[14:0],Data[15]};
                count<=1;
                status<=WRITE_DATA;
                end
            cmd[47:32]<=adjust_vol;
            end
        WRITE_DATA:begin
            if(SCLK)
                begin
                if(count>=16)
                    begin
                    XDCS<=1;
                    addr<=addr+1;
                    status<=DATA_START;
                    end
                else
                    begin
                    count<=count+1;
                    _Data<={_Data[14:0],_Data[15]};
                    SI<=_Data[15];
                    end
                end
            SCLK<=~SCLK;
            end
        DELAY:begin
            if(count<1000)
                count<=count+1;
            else
                begin
                count<=0;
                status<=CMD_START;
                XRSET<=1;
                end
            end
        VOL_CMD_START:begin
            if(DREQ)
                begin
                XCS<=0;
                status<=SEND_VOL_CMD;
                SI<=volcmd[31];
                volcmd<={volcmd[30:0],volcmd[31]};
                count<=1;
                end
            end
        SEND_VOL_CMD:begin
            if(DREQ)
                begin
                if(SCLK)
                    begin
                    if(count<32)
                        begin
                        SI<=volcmd[31];
                        volcmd<={volcmd[30:0],volcmd[31]};
                        count<=count+1;
                        end
                    else
                        begin
                        XCS<=1;
                        count<=0;
                        status<=DATA_START;
                        end
                    end
                SCLK<=~SCLK;
                end
            end
        default:;
        endcase
        end
    end
endmodule
