`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/11 08:06:22
// Design Name: 
// Module Name: report1_halfadder2
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


module report1_halfadder2(a, b, s, c);
input a, b;
output s, c;
wire s, c;

reg s, c;

always @(*) begin
case({a,b})
2'b00 : {s, c} = 2'b00;
2'b01 : {s, c} = 2'b10;
2'b10 : {s, c} = 2'b10;
2'b11 : {s, c} = 2'b11;
endcase
end

endmodule
