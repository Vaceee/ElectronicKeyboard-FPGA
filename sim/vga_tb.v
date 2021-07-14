`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/28 19:27:48
// Design Name: 
// Module Name: vga_tb
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


module vga_tb;
    reg clk,rst;
    wire[3:0] R,G,B;
    wire h_sync;
    wire v_sync;
    
    initial
    begin
    clk=1;
    rst=1;
    end
    always #1 clk=~clk;
    
    VGA_demo vga_demo_inst(
    .clk(clk),.rst(rst),.R(R),.G(G),.B(B),.h_sync(h_sync),.v_sync(v_sync)
    );
endmodule
