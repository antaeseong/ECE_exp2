`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/08 10:38:37
// Design Name: 
// Module Name: seg_array
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

module oneshot_universal(clk, rst, btn, btn_trig);
parameter WIDTH = 1;
input clk, rst, btn;
reg [WIDTH-1:0] btn_reg;
output reg [WIDTH-1:0] btn_trig;

always @(negedge rst or posedge clk) begin
if(!rst) begin
btn_reg <= {WIDTH{1'b0}};
btn_trig <= {WIDTH{1'b0}};
end
else begin
btn_reg <= btn;
btn_trig <= btn & ~btn_reg;
end
end
endmodule

module bin2bcd(clk, rst, bin, bcd);
input clk, rst;
input [3:0] bin;
output reg [7:0] bcd;

always @(negedge rst or posedge clk) begin
if(!rst) begin
bcd<={4'd0, 4'd0};
end
else begin
case (bin)
0 : bcd <= {4'd0, 4'd0};
1 : bcd <= {4'd0, 4'd1};
2 : bcd <= {4'd0, 4'd2};
3 : bcd <= {4'd0, 4'd3};
4 : bcd <= {4'd0, 4'd4};
5 : bcd <= {4'd0, 4'd5};
6 : bcd <= {4'd0, 4'd6};
7 : bcd <= {4'd0, 4'd7};
8 : bcd <= {4'd0, 4'd8};
9 : bcd <= {4'd0, 4'd9};
10 : bcd <= {4'd1, 4'd0};
11 : bcd <= {4'd1, 4'd1};
12 : bcd <= {4'd1, 4'd2};
13 : bcd <= {4'd1, 4'd3};
14 : bcd <= {4'd1, 4'd4};
15 : bcd <= {4'd1, 4'd5};
default : bcd <= {4'd0, 4'd0};
endcase
end
end
endmodule

module seg_array(clk, rst, btn, seg_data, seg_sel);
input clk, rst;
input btn;
wire btn_trig;
reg[3:0] state_bin;
wire [7:0] state_bcd;
output reg [7:0] seg_data;
output reg [7:0] seg_sel;
reg[3:0] bcd;

oneshot_universal #(.WIDTH(1)) O1(clk, rst, btn, btn_trig);
bin2bcd B1(clk, rst, state_bin[3:0], state_bcd[7:0]);

always @(posedge clk or negedge rst) begin
if(!rst) state_bin <= 4'b0000;
else if(state_bin == 4'b1111 && btn_trig == 1) state_bin <= 4'b0000;
else if(btn_trig == 1) state_bin <= state_bin + 1;
end

always @(posedge clk or negedge rst) begin
if(!rst) seg_sel <= 8'b11111110;
else begin 
seg_sel <= {seg_sel[6:0], seg_sel[7]};
end
end

always @(*) begin
case (bcd[3:0])
0 : seg_data =8'b11111100;
1 : seg_data =8'b01100000;
2 : seg_data =8'b11011010;
3 : seg_data =8'b11110010;
4 : seg_data =8'b01100110;
5 : seg_data =8'b10110110;
6 : seg_data =8'b10111110;
7 : seg_data =8'b11100000;
8 : seg_data =8'b11111110;
9 : seg_data =8'b11110110;
default : seg_data = 8'b00000000;
endcase
end

always @(*) begin
case(seg_sel)
8'b11111110 : bcd = state_bcd[3:0];
8'b11111101 : bcd = state_bcd[7:4];
8'b11111011 : bcd = 4'b0000;
8'b11110111 : bcd = 4'b0000;
8'b11101111 : bcd = 4'b0000;
8'b11011111 : bcd = 4'b0000;
8'b10111111 : bcd = 4'b0000;
8'b01111111 : bcd = 4'b0000;
default : bcd = 4'b0000;
endcase
end

endmodule
