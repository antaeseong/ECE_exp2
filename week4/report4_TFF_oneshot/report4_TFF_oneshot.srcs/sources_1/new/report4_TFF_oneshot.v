`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/24 21:45:50
// Design Name: 
// Module Name: report4_TFF_oneshot
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


module report4_TFF_oneshot(clk, rst, T, Q);
input T;
input clk, rst;
reg T_reg, T_trig;
output reg Q;

always @(posedge clk or negedge rst) begin
if(!rst) begin
Q<=1'b0;
T_reg<=1'b0;
T_trig<=1'b0;
end
else if(T_trig)begin
Q<=~Q;
end
else begin
T_reg<=T;
T_trig<=T&~T_reg;
end
end

endmodule

