`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/13 18:52:29
// Design Name: 
// Module Name: DAC_3
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
input clk, rst;
input[WIDTH-1:0] btn;
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

module DAC_3 (clk, rst, btn, add_sel, dac_csn, dac_ldacn, dac_wrn, dac_a_b, dac_d, led_out, LCD_E, LCD_RS, LCD_RW, LCD_DATA);
input clk, rst;
input[8:0] btn;
input add_sel;
output reg dac_csn, dac_ldacn, dac_wrn, dac_a_b;
output reg [7:0] dac_d;
output reg [7:0] led_out;
output reg [7:0] LCD_DATA;
output LCD_E, LCD_RS, LCD_RW;
wire LCD_E;
reg LCD_RS, LCD_RW;

reg [7:0] dac_d_temp;
reg [7:0] cnt;
wire [8:0] btn_t;

reg [1:0] state;

parameter DELAY1   = 2'b00,
          SET_WRN = 2'b01,
          UP_DATA = 2'b10;
 
reg [2:0] state2;
parameter DELAY=3'b000,
FUNCTION_SET = 3'b001,
ENTRY_MODE = 3'b010,
DISP_ONOFF = 3'b011,
LINE1 = 3'b100,
LINE2 = 3'b101,
DELAY_T = 3'b110,
CLEAR_DISP = 3'b111;

integer cnt1;

          
oneshot_universal #(.WIDTH(9)) O1(clk, rst, {btn[8:0]}, {btn_t[8:0]});


always @(posedge clk or negedge rst)
begin
if(!rst)
state = DELAY;
else
begin
case(state2)
DELAY : begin

if(cnt1 == 70) state2 = FUNCTION_SET;
end
FUNCTION_SET : begin

if(cnt1 == 30) state2 = DISP_ONOFF;
end
DISP_ONOFF : begin

if(cnt1 == 30) state2 = ENTRY_MODE;
end
ENTRY_MODE : begin

if(cnt1 == 30) state2 = LINE1;
end
LINE1 : begin

if(cnt1 == 20) state2 = LINE2;
end
LINE2 : begin

if(cnt1 == 20) state = DELAY_T;
end
DELAY_T : begin

if(cnt1 == 5) state2 = CLEAR_DISP;
end
CLEAR_DISP : begin

if(cnt1 == 5) state2 = LINE1;
end
default : state2 = DELAY;
endcase
end
end

always @(posedge clk or negedge rst)
begin
if(!rst)
cnt1=0;
else begin
case(state2)
DELAY :
if(cnt1 >= 70) cnt1=0;
else cnt1 = cnt1 + 1;
FUNCTION_SET :
if(cnt1 >= 30) cnt1 = 0;
else cnt1 = cnt1 + 1;
DISP_ONOFF :
if(cnt1 >= 30) cnt1 = 0;
else cnt1 = cnt1 + 1;
ENTRY_MODE : 
if(cnt1 >= 30) cnt1 = 0;
else cnt1 = cnt1 + 1;
LINE1 :
if(cnt1 >= 20) cnt1 = 0;
else cnt1 = cnt1 + 1;
LINE2 :
if(cnt1 >= 20) cnt1 = 0;
else cnt1 = cnt1 + 1;
DELAY_T :
if(cnt1 >= 5) cnt1 = 0;
else cnt1= cnt1 + 1;
CLEAR_DISP :
if(cnt1 >= 5) cnt1 = 0;
else cnt1= cnt1 + 1;
default : state2 = DELAY;
endcase
end
end

always @(posedge clk or negedge rst)
begin
if(!rst)
{LCD_RS, LCD_RW, LCD_DATA} = 10'b1_1_00000000;
else begin
case(state)
FUNCTION_SET : 
{LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0011_1000;
DISP_ONOFF : 
{LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_1100;
ENTRY_MODE : 
{LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0111;     
LINE1 :
begin
case(cnt)
00 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_1000_1111;
01 : if(dac_d_temp[0]==1)
{LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0001;
else
{LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000;

02 : if(dac_d_temp[0]==1)
{LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0001;
else
{LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000;
03 : if(dac_d_temp[0]==1)
{LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0001;
else
{LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000;
04 : if(dac_d_temp[0]==1)
{LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0001;
else
{LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000;
05 : if(dac_d_temp[0]==1)
{LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0001;
else
{LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000;
06 : if(dac_d_temp[0]==1)
{LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0001;
else
{LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000;
07 : if(dac_d_temp[0]==1)
{LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0001;
else
{LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000;
08 : if(dac_d_temp[0]==1)
{LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0001;
else
{LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000;
09 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1100;
10 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1100;
11 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1100;
12 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1100;
13 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1100;
14 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1100;
15 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1100;
16 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1100;
default : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000;
endcase
end
DELAY_T :
{LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0010;
CLEAR_DISP :
{LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0001;
default :
{LCD_RS, LCD_RW, LCD_DATA} = 10'b1_1_0000_0000;
endcase
end
end
assign LCD_E = clk;

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        state <= DELAY1;
    end
    else begin
        case(state)
            DELAY1   : if(cnt == 200) state <= SET_WRN;
            SET_WRN : if(cnt == 50) state <= UP_DATA;
            UP_DATA : if(cnt == 30) state <= DELAY;
        endcase
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst)
        cnt <= 8'b0000_0000;
    else begin
        case(state)
            DELAY1 :
            if(cnt >= 200) cnt <= 0;
            else cnt <= cnt + 1;
        SET_WRN :
            if(cnt >= 50) cnt <= 0;
            else cnt <= cnt + 1;
        UP_DATA :
            if(cnt >= 30) cnt <= 0;
            else cnt <= cnt + 1;
        endcase
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        dac_wrn <= 1;
    end
    else begin
        case(state)
          DELAY1   :
           dac_wrn <= 1;
           SET_WRN :
           dac_wrn <= 0;
           UP_DATA :
          dac_d <= dac_d_temp;
        endcase
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        dac_d_temp <= 8'b0000_0000;
        led_out <= 8'b0101_0101;
    end
    else begin
        if(btn_t == 9'b100000000) dac_d_temp <= dac_d_temp - 8'b0000_0001;
        else if(btn_t == 9'b010000000) dac_d_temp <= dac_d_temp;
        else if(btn_t == 9'b001000000) dac_d_temp <= dac_d_temp + 8'b0000_0001;
        else if(btn_t == 9'b000100000) dac_d_temp <= dac_d_temp - 8'b0000_0010;
        else if(btn_t == 9'b000010000) dac_d_temp <= dac_d_temp;
        else if(btn_t == 9'b000001000) dac_d_temp <= dac_d_temp + 8'b0000_0010;
        else if(btn_t == 9'b000000100) dac_d_temp <= dac_d_temp - 8'b0000_1000;
        else if(btn_t == 9'b000000010) dac_d_temp <= dac_d_temp;
        else if(btn_t == 9'b000000001) dac_d_temp <= dac_d_temp + 8'b0000_1000;
        led_out <= dac_d_temp;
    end
end

always @(posedge clk) begin
    dac_csn <= 0;
    dac_ldacn <= 0;
    dac_a_b <= add_sel;
end
endmodule


