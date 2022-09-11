`timescale 10ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/11 11:08:10
// Design Name: 
// Module Name: report1_fulladder_tb
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


module report1_fulladder_tb();
reg a;
reg b;
reg ci;
wire s;
wire co;

report1_fulladder u1(.s(s), .co(co), .a(a), .b(b), .ci(ci));
initial begin
a=1'b0; b=1'b0; ci=1'b0;
#10 b=2'b1;
#10 a=2'b1; b=2'b0;
#10 a=2'b1; b=2'b1;
#10 a=1'b1; b=1'b0; ci=1'b0;
#10 b=2'b1;
#10 a=2'b1; b=2'b0;
#10 a=2'b1; b=2'b1;
end
endmodule
