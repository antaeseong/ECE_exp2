`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/15 14:19:14
// Design Name: 
// Module Name: LED_control
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
module counter8(clk, rst, cnt);
input clk, rst;
output reg [7:0] cnt;

always @(posedge clk or posedge rst) begin
if(rst) begin
cnt <= 8'b0000_0000;
end
else cnt <= cnt + 8'd1;
end
endmodule

module seg7_controller(clk, rst, bin, seg_data, seg_sel);
input clk, rst;
input [7:0] bin;

wire [11:0] bcd;
reg [3:0] display_bcd;

output reg [7:0] seg_data;
output reg [7:0] seg_sel;

bin2bcd b1(clk, rst, bin, bcd);

always @(posedge clk or posedge rst) begin
if(rst)seg_sel <= 8'b11111110;
else begin
seg_sel <= {seg_sel[6:0], seg_sel[7]};
end
end

always @(*) begin
case (display_bcd[3:0])
0 : seg_data = 8'b11111100;
1 : seg_data = 8'b01100000;
2 : seg_data = 8'b11011010;
3 : seg_data = 8'b11110010;
4 : seg_data = 8'b01100110;
5 : seg_data = 8'b10110110;
6 : seg_data = 8'b10111110;
7 : seg_data = 8'b11100000;
8 : seg_data = 8'b11111110;
9 : seg_data = 8'b11110110;
default : seg_data = 8'b00000000;
endcase
end
always @(*) begin
case(seg_sel)
8'b11111110 : display_bcd = bcd[3:0];
8'b11111101 : display_bcd = bcd[7:4];
8'b11111011 : display_bcd = bcd[11:8];
8'b11110111 : display_bcd = 4'b0000;
8'b11101111 : display_bcd = 4'b0000;
8'b11011111 : display_bcd = 4'b0000;
8'b10111111 : display_bcd = 4'b0000;
8'b01111111 : display_bcd = 4'b0000;
default : display_bcd = 4'b0000;
endcase
end
endmodule

module bin2bcd(clk, rst, bin, bcd_out);
input clk, rst;
input [7:0] bin;
reg [11:0] bcd;
output reg [11:0] bcd_out;

reg [2:0] i;

always @(posedge rst or posedge clk) begin
if(rst) begin
bcd <= {4'd0, 4'd0, 4'd0};
i <= 0;
end
else begin
if(i==0) begin
bcd[11:1] <= 11'b0000_0000_000;
bcd[0] <= bin[7];
end
else begin
bcd[11:9] <= (bcd[11:8] >=3'd5) ? bcd[11:8]+2'd3 : bcd[11:8];
bcd[8:5] <= (bcd[7:4] >=3'd5) ? bcd[7:4]+2'd3 : bcd[7:4];
bcd[4:1] <= (bcd[3:0] >=3'd5) ? bcd[3:0]+2'd3 : bcd[3:0];
bcd[0] <= bin[7-i];
end
i <= i+1;
end
end
always @(posedge rst or posedge clk) begin
if(rst) bcd_out <= {4'd0, 4'd0, 4'd0};
else if(i==0) bcd_out <= bcd;
end
endmodule



module LED_control(clk, rst, bin, seg_data, seg_sel, led_signal);

input clk, rst;
input [7:0] bin;

wire [7:0] cnt;

output [7:0] seg_data;
output [7:0] seg_sel;
output reg led_signal;

counter8 c1(clk, rst, cnt);
seg7_controller s1(clk, rst, bin, seg_data, seg_sel);

always @(posedge clk or posedge rst) begin
if(rst) led_signal <=0;
else begin
if(cnt<=bin) led_signal <= 1;
else if(cnt>bin) led_signal <= 0;
end
end

endmodule
