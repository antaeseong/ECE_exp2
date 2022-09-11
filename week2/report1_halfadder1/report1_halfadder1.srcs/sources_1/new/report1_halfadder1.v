`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/11 07:30:47
// Design Name: 
// Module Name: report1_halfadder1
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


module report1_halfadder1(a, b, s, c);
input a, b;
output s, c;
wire s, c;

assign s = a ^ b;
assign c = a & b;

endmodule
