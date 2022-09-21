`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/17 19:11:41
// Design Name: 
// Module Name: report2_8_to_1_mux
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


module report2_8_to_1_mux(in1, in2, in3, in4, in5, in6, in7, in8, S0, S1, S2, V);
output reg [3:0]V;
input [3:0] in1;
input [3:0] in2;
input [3:0] in3;
input [3:0] in4;
input [3:0] in5;
input [3:0] in6;
input [3:0] in7;
input [3:0] in8;
input S0, S1, S2;


always @(*) begin
case({S0, S1, S2})
3'b000 : V = in8[3:0];
3'b001 : V = in7[3:0];
3'b010 : V = in6[3:0];
3'b011 : V = in5[3:0];
3'b100 : V = in4[3:0];
3'b101 : V = in3[3:0];
3'b110 : V = in2[3:0];
3'b111 : V = in1[3:0];
endcase
end

endmodule
