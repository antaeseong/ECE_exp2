`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/11 10:46:03
// Design Name: 
// Module Name: report1_fulladder
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


module report1_fulladder(s, co, a, b, ci);
output s, co;
input a, b, ci;

assign s=a^b^ci;
assign co=(a&b)|(a&ci)|(b&ci);
endmodule
