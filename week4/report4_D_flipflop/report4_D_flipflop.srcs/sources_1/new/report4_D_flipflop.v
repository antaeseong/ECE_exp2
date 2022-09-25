`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/24 16:38:30
// Design Name: 
// Module Name: report4_D_flipflop
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


module report4_D_flipflop(clk, D, Q);
input D, clk;
output reg Q;

always @(posedge clk)
begin Q <=D;
end
endmodule
