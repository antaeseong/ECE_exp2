`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/15 15:33:32
// Design Name: 
// Module Name: LED_control_tb
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


module LED_control_tb();
reg clk, rst;
reg [7:0] bin;
wire [7:0] cnt;
 wire [7:0] seg_data;
 wire[7:0] seg_sel;
 wire led_signal;
 
LED_control U1(clk, rst, bin, seg_data, seg_sel, led_signal);
initial begin
clk<=0;
rst<=0;
bin<=8'b00000000;
#1 rst<=1;
#1 rst<=0;
#1e+6; bin <= 8'b01000000;
#1e+6; bin <= 8'b10000010;
#1e+6; bin <= 8'b11000010;
#1e+6; bin <= 8'b11111111;
end

always begin
#0.5 clk <=~clk;

end
 
endmodule
