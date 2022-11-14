`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/13 17:35:32
// Design Name: 
// Module Name: DAC_2
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


module DAC_2(clk, rst, btn, add_sel, dac_csn, dac_ldacn, dac_wrn, dac_a_b, dac_d, led_out, seg_data, seg_sel);
input clk, rst;
input[8:0] btn;
input add_sel;
output reg dac_csn, dac_ldacn, dac_wrn, dac_a_b;
output reg [7:0] dac_d;
output reg [7:0] led_out;
output reg [7:0] seg_data;
output reg [7:0] seg_sel;
reg [3:0] bcd;
reg [7:0] dac_d_temp;
reg [7:0] cnt;
wire [8:0] btn_t;

reg [1:0] state;

parameter DELAY   = 2'b00,
          SET_WRN = 2'b01,
          UP_DATA = 2'b10;
          
oneshot_universal #(.WIDTH(9)) O1(clk, rst, {btn[8:0]}, {btn_t[8:0]});

always @(posedge clk or negedge rst) begin
    if(!rst) seg_sel <= 8'b11111110;
    else begin 
        seg_sel <= {seg_sel[6:0], seg_sel[7]};
    end
end

always @(*) begin
if(dac_d_temp[0]==1)
seg_data=8'b01100000;
else
seg_data=8'b11111100;
if(dac_d_temp[1]==1)
seg_data=8'b01100000;
else
seg_data=8'b11111100;
if(dac_d_temp[2]==1)
seg_data=8'b01100000;
else
seg_data=8'b11111100;
if(dac_d_temp[3]==1)
seg_data=8'b01100000;
else
seg_data=8'b11111100;
if(dac_d_temp[4]==1)
seg_data=8'b01100000;
else
seg_data=8'b11111100;
if(dac_d_temp[5]==1)
seg_data=8'b01100000;
else
seg_data=8'b11111100;
if(dac_d_temp[6]==1)
seg_data=8'b01100000;
else
seg_data=8'b11111100;
if(dac_d_temp[7]==1)
seg_data=8'b01100000;
else
seg_data=8'b11111100;
end

always @(*) begin
    case(seg_sel)
        8'b11111110 : bcd = dac_d_temp[0];
        8'b11111101 : bcd = dac_d_temp[1];
        8'b11111011 : bcd = dac_d_temp[2];
        8'b11110111 : bcd = dac_d_temp[3];
        8'b11101111 : bcd = dac_d_temp[4];
        8'b11011111 : bcd = dac_d_temp[5];
        8'b10111111 : bcd = dac_d_temp[6];
        8'b01111111 : bcd = dac_d_temp[7];
        default : bcd = 4'b0000;
    endcase
end

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        state <= DELAY;
    end
    else begin
        case(state)
            DELAY   : if(cnt == 200) state <= SET_WRN;
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
            DELAY :
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
          DELAY   :
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

