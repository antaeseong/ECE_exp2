`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/28 11:38:27
// Design Name: 
// Module Name: project_traffic_light_tb
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

project_traffic_light_tb;
reg rst, clk;
wire LCD_E;
wire LCD_RS, LCD_RW;
wire [7:0] LCD_DATA;
wire [7:0] LED_out;
reg [9:0] number_btn;
reg [1:0] control_btn;

project_traffic_light U1(clk, rst, LCD_DATA,LCD_RS,LCD_RW,LED_out,clk,rst,Hu,Stop, LCD_E);
initial begin
clk<=0;
rst<=0;
number_btn<=0;
control_btn<=0;
#0.1 rst<=0;
#0.1 rst<=1;


end
always begin
#0.5 clk <= ~clk;
end
endmodule

