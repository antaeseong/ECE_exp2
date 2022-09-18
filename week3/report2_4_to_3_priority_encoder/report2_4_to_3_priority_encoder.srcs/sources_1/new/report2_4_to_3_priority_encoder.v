`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/17 18:55:17
// Design Name: 
// Module Name: report2_4_to_3_priority_encoder
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


module report2_4_to_3_priority_encoder(a, b, c, d, x, y, V);
input a,b,c,d;
output x, y, V;

assign x = a | b;
assign y = a | ((~b)& c);
assign V = a | b | c | d;

endmodule
