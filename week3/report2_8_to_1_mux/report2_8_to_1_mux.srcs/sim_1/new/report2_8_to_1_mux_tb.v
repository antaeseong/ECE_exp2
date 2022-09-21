`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/17 22:31:03
// Design Name: 
// Module Name: report2_8_to_1_mux_tb
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


module report2_8_to_1_mux_tb();
wire [3:0]V;
reg [3:0] in1;
reg [3:0] in2;
reg [3:0] in3;
reg [3:0] in4;
reg [3:0] in5;
reg [3:0] in6;
reg [3:0] in7;
reg [3:0] in8;
reg S0, S1, S2;

report2_8_to_1_mux U1(.V(V), .in1(in1), .in2(in2), .in3(in3), .in4(in4), .in5(in5), .in6(in6), .in7(in7), .in8(in8), .S0(S0), .S1(S1), .S2(S2));
initial begin
in1=4'b1010;
in2=4'b1100;
in3=4'b0000;
in4=4'b1001;
in5=4'b1111;
in6=4'b0100;
in7=4'b1110;
in8=4'b0110;
{S0, S1,S2} = 3'b000;
#10;
{S0, S1,S2} = 3'b001;
#10;
{S0, S1,S2} = 3'b010;
#10;
{S0, S1,S2} = 3'b011;
#10;
{S0, S1,S2} = 3'b100;
#10;
{S0, S1,S2} = 3'b101;
#10;
{S0, S1,S2} = 3'b110;
#10;
{S0, S1,S2} = 3'b111;
#10;
end
endmodule
