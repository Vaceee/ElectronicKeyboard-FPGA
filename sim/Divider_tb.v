`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/01/06 06:44:34
// Design Name: 
// Module Name: Divider_tb
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


module Divider_tb;
    reg I_CLK;
    wire O_CLK;
    initial I_CLK=0;
    always #2 I_CLK=~I_CLK;
    Divider#(.N(10)) Divider_inst(I_CLK,O_CLK);
endmodule
