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


module report2_8_to_1_mux(in1, in2, S0, S1, S2, V);
output reg V;
input [3:0] in1;
input [3:0] in2;
input S0, S1, S2;


always @(*) begin
case({S0, S1, S2})
3'b000 : V = in2[0];
3'b001 : V = in2[1];
3'b010 : V = in2[2];
3'b011 : V = in2[3];
3'b100 : V = in1[0];
3'b101 : V = in1[1];
3'b110 : V = in1[2];
3'b111 : V = in1[3];
endcase
end

endmodule
