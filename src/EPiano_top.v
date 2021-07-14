`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/01/04 17:12:58
// Design Name: 
// Module Name: EPiano_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module EPiano_top(
    input clk, rst,
    /*Keyboard*/
    input PS2_clk,
    input PS2_data,
    output UART_TXD,
    /*Buzzer*/
    input mode, track,
    output beep,
    output music,
    /*7-segment*/
    output [6:0]seg_data,
    output [7:0]seg_sel,
    output DP,
    /*MP3 Drive*/
    input DREQ, //数据请求
    output XRSET,//硬件复位
    output XCS, //片选输入_低电平有效
    output XDCS,//数据片选_字节同步
    output SI,  //串行数据输入
    output SCLK,//SPI时钟
    /*MP3 Control*/
    input init,
    input up_vol,
    input down_vol,
    input prev,
    input next,
    /*VGA*/
    output [3:0] R,G,B,
    output h_sync,
    output v_sync
    );

    wire clk_1, clk_25, clk_50; //1MHZ,25MHz,50MHz clock
    Divider#(.N(100)) clk_mp3(clk,clk_1);
    Divider#(.N(4)) clk_vga(clk,clk_25);
    Divider#(.N(2)) clk_keyboard(clk,clk_50);

    wire[15:0] adjust_vol;  //调节音量
    wire[3:0] vol_class;    //音量等级
    wire[1:0] select;
    wire[31:0] keycode;
    wire[17:0] tune;
    wire[9:0] x_counter;
    wire[9:0] y_counter;

    MP3_Driver mp3_spi(
        .DREQ_p(DREQ),.XRSET_p(XRSET),.XCS_p(XCS),.XDCS_p(XDCS),.SI_p(SI),.SCLK_p(SCLK),
        .clk(clk),.clk_1(clk_1),.init(rst&init),.select(select),.adjust_vol(adjust_vol)
    );

    MP3_Adjust_Vol adjvol(
        .clk(clk_1),.up_vol(up_vol),.down_vol(down_vol),.vol(adjust_vol),.vol_class(vol_class)
    );

    
    MP3_Switch_Music swch_music(
        .clk(clk_1),.prev(prev),.next(next),.select(select)
    );

    Keyboard_PS2 PS2(
        .clk(clk_50),.rst(rst),.k_clk(PS2_clk),.k_data(PS2_data),.keycode(keycode)
    );

    Display7 nix_display(
        .clk(clk),.rst(rst),.init(init),.data1(tune),.data2(vol_class),.data3(select+1),.seg_data(seg_data),.seg_sel(seg_sel),.DP(DP)
    );
    
    Beep play_music(
        .clk(clk),.rst(rst),.mode(mode),.track(track),.keycode(keycode[15:0]),.beep(beep),.music_out(music),.tune(tune)
    );

    VGA_Driver hvsync_generator(
        .clk(clk_25),.rst(rst),.h_sync(h_sync),.v_sync(v_sync),.x_counter(x_counter),.y_counter(y_counter)
    );

    VGA_RGB vga_rgb(
        .clk(clk_25),.x_counter(x_counter),.y_counter(y_counter),.select(tune),.R(R),.G(G),.B(B)
    );



endmodule
