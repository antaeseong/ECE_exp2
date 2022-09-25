`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/24 19:30:45
// Design Name: 
// Module Name: report4_JK_flipflop
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


module report4_JK_flipflop(rst, J, K, clk, Q);
input rst, J, K, clk;
output reg Q;
always @(posedge clk)
begin
if(!rst)
Q<=0;
else if(K==0&&J==0)
Q<=Q;
else if(K==1&&J==0)
Q<=0;
else if(K==0&&J==1)
Q<=1;
else
Q<=~Q;
end

endmodule
