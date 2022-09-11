`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/10 20:19:54
// Design Name: 
// Module Name: report1_logic_gate1
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


module report1_logic_gate1(a, b, q, w, x, y, z);
input a, b;
output q, w, x, y, z;
wire q, w, x, y, z;

assign q = a & b;
assign w = a | b;
assign x = a ^ b;
assign y = ~ (a | b);
assign z = ~ (a & b);
endmodule
