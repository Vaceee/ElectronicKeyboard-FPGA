`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/01/06 07:16:51
// Design Name: 
// Module Name: Beep_tb
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


module Beep_tb;
	reg clk,rst,mode,track;
	reg [15:0]keycode;
	wire beep,music;
	wire[17:0]tune;
	
	initial
	begin
	clk=1;
	rst=1;
	mode=1;//auto play
	track=1;
	keycode=16'h00;
	end
	always #1 clk=~clk;
	
	Beep Beep_inst(clk,rst,mode,track,keycode,beep,music,tune);
	
endmodule
