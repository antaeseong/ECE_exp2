`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/17 00:45:42
// Design Name: 
// Module Name: report_4_bit_comparator
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

module report2_4_bit_comparator(a, b, x, y, z);
input [3:0] a, b;
output x, y, z;
wire x, y, z;

assign x = (a > b) ? 1'b1 : 1'b0;
assign y = (a == b) ? 1'b1 : 1'b0;
assign z = (a < b) ? 1'b1 : 1'b0;

endmodule

