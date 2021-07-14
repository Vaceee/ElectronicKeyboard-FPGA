`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/01/06 07:04:43
// Design Name: 
// Module Name: Display7_tb
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


module Display7_tb;
	reg[31:0]data;
	reg clk;
	wire[6:0]seg_data;
	wire[7:0]seg_sel;
	wire dp;
	
	initial clk=1;
	always #2 clk=~clk;
	
	initial data=32'hABCD;
	always #10 data={data[30:0],data[31]};
	
	Display7 Display7_inst(data,clk,seg_data,seg_sel,dp);
endmodule
