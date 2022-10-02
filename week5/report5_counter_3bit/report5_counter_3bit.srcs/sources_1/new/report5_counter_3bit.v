`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/02 10:35:57
// Design Name: 
// Module Name: report5_counter_3bit
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


module report5_counter_3bit(clk, rst, x, y, state);
input clk, rst;
input x;
input y;
reg x_reg, x_trig;
output reg[2:0]state;


always @(negedge rst or posedge clk) begin
if(!rst) begin
{x_reg, x_trig}<=2'b00;
end
else begin
x_reg<=x;
x_trig<=x&~x_reg;
end
end

always @(negedge rst or posedge clk) begin
if(!rst)
state<=3'b000;
else if(y) begin
case(state)
3'b000:state<=x_trig?3'b001:3'b000;
3'b001:state<=x_trig?3'b010:3'b001;
3'b010:state<=x_trig?3'b011:3'b010;
3'b011:state<=x_trig?3'b100:3'b011;
3'b100:state<=x_trig?3'b101:3'b100;
3'b101:state<=x_trig?3'b110:3'b101;
3'b110:state<=x_trig?3'b111:3'b110;
endcase
end
else if(!y) begin
case(state)
3'b111:state<=x_trig?3'b110:3'b111;
3'b110:state<=x_trig?3'b101:3'b110;
3'b101:state<=x_trig?3'b100:3'b101;
3'b100:state<=x_trig?3'b011:3'b100;
3'b011:state<=x_trig?3'b010:3'b011;
3'b010:state<=x_trig?3'b001:3'b010;
3'b001:state<=x_trig?3'b000:3'b001;
endcase
end
end

endmodule
