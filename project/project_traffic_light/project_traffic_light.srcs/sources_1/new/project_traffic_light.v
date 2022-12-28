`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/27 08:20:40
// Design Name: 
// Module Name: project_traffic_light
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
module project_traffic_light(clk, rst, LCD_DATA,LCD_RS,LCD_RW,LED_out,clk,rst,Hu,Stop, LCD_E);
	input clk,rst,Hu,Stop; //clk,rst�� ��,��,�� Count, Stop���� ���¸� Input ����
	output LCD_E, LCD_RS,LCD_RW; //Instruction/data Register�� ��Ÿ���� RS, �б�� ���⸦ �����ϴ� RW, Enable E�� output���� ����
	output [7:0]LCD_DATA; //��µǴ� Output 8��Ʈ�� ����
	output reg [7:0]LED_out;
	wire LCD_E;
	reg [7:0]Scf; //�ð��� �����ϴ� ���� �� �ڸ��� 8��Ʈ�� Reg�� ����
	reg [7:0]Scb; //�ð��� �����ϴ� ���� �� �ڸ��� 8��Ʈ�� Reg�� ����
	reg [7:0]Mcf; //�ð��� �����ϴ� ���� �� �ڸ��� 8��Ʈ�� Reg�� ����
	reg [7:0]Mcb; //�ð��� �����ϴ� ���� �� �ڸ��� 8��Ʈ�� Reg�� ����
	reg [7:0]Hcf; //�ð��� �����ϴ� �ð��� �� �ڸ��� 8��Ʈ�� Reg�� ����
	reg [7:0]Hcb; //�ð��� �����ϴ� �ð��� �� �ڸ��� 8��Ʈ�� Reg�� ����
	reg [7:0]Sf;  //�ð��� ���� �� �ڸ��� 8��Ʈ�� Reg�� ����
	reg [7:0]Sb;  //�ð��� ���� �� �ڸ��� 8��Ʈ�� Reg�� ����
	reg [7:0]Mf;  //�ð��� ���� �� �ڸ��� 8��Ʈ�� Reg�� ����
	reg [7:0]Mb;  //�ð��� ���� �� �ڸ��� 8��Ʈ�� Reg�� ����
	reg [7:0]Hf;  //�ð��� �ð��� �� �ڸ��� 8��Ʈ�� Reg�� ����
	reg [7:0]Hb;  //�ð��� �ð��� �� �ڸ��� 8��Ʈ�� Reg�� ����
	
	reg LCD_RS,LCD_RW; //always�������� �̿��ϱ� ���� RS, RW reg�� ����
	reg [7:0]LCD_DATA; //Instruction�� ��� �� ���� ���� data�� reg�� ����
	reg [2:0]state; // LCD�� �����ϴ� State�� reg�� ����
	
	wire huout0; //Oneshot Enable�� ��������� wire ����

	

    oneshot Hour_up(clk,rst,huout0 ,Huen); //�ð� Up�� Oneshot�� ���� Instance
	
	integer cnt; //State�� �����ϴ� cnt�� integer�� ����
	integer cnt_1hz; //�ð踦 �����ϴ� Clock�� 1hz�� ���� ��Ű�� ���� ����
	integer Sec1; //LCD�� Line�� ��� �� ���� �� �ڸ�
	integer Sec2; //LCD�� Line�� ��� �� ���� �� �ڸ�
	integer Min1; //LCD�� Line�� ��� �� ���� �� �ڸ�
	integer Min2; //LCD�� Line�� ��� �� ���� �� �ڸ�
	integer Hour1; //LCD�� Line�� ��� �� �ð��� �� �ڸ�
	integer Hour2; //LCD�� Line�� ��� �� �ð��� �� �ڸ�
	
	
	reg clk_1hz;  //���� �� Clock�� ����
	
	parameter DELAY = 3'b000, FUNCTION_SET = 3'b001, //Parameter�� ������ state�� ����
				 ENTRY_MODE = 3'b010, DISP_ONOFF = 3'b011,
				 LINE1 = 3'b100, LINE2 = 3'b101,
				 clock = 3'b110;
	

	

always@ (posedge clk or negedge rst) //�� Counting ��
	 begin
	 Hcf = Hour1; //Count �Ǳ� �� �ð��� �� �ڸ��� LCD�� ǥ�õ� Data ���� ��
	 Hcb = Hour2; //Count �Ǳ� �� �ð��� �� �ڸ��� LCD�� ǥ�õ� Data ���� ��
		if(~rst)
		 begin
			Hcf = 8'b00110000; //�� �� �ڸ� �ʱⰪ 0
			Hcb = 8'b00110000; //�� �� �ڸ� �ʱⰪ 0
		 end
		else if(Stop)
			begin
				if(Huen) //�� Count Up ���� ��
					begin
						if(Hcb == 8'b00111001) //�� �ڸ� �� �� �ڸ��� 9��
							begin
								Hcf = Hcf + 1; //�� �ڸ��� 1�� ���ϰ�
								Hcb = 8'b00110000; //�� �ڸ��� 0
							end
						else if(Hcf == 8'b00110010 & Hcb == 8'b00110011) //�� �ڸ��� 2, �� �ڸ��� 3�̸�
							begin
								Hcf = 8'b00110000; //�� �ڸ� 0
								Hcb = 8'b00110000; //�� �ڸ� 0
							end
						else //�� �ڸ��� 9�� �ƴϸ�
							Hcb = Hcb + 1; // �� �ڸ��� 1 ����
					end
			end
		else //Stop�� Low ���� �� �� �ð��� �� ����
			begin
				Hcf = Hcf;
				Hcb = Hcb;
			end
	end
	
always@(posedge clk or negedge rst) //Clock ���� ����
	begin
		if(~rst) //rst�� 1��Ʈ 0�̸� �Ʒ� ���� ����
			begin
				cnt_1hz = 0;
				clk_1hz = 1'b0;
			end
		else if (cnt_1hz >= 499) //clock�� 10���� �����ִ� ���� (cnt_100hz�� 0~49 500���̹Ƿ� *2 �Ͽ� 1000)
			begin
				cnt_1hz = 0;
				clk_1hz = ~ clk_1hz;
			end
		else
			cnt_1hz = cnt_1hz + 1;
	end

always@ (posedge clk_1hz or negedge rst) //���ֵ� Clock�� ���� ���� �ð� ���� ����
	begin
	Hf = Hour1; //�ð� �� �ڸ��� �ʱ� ���� LCD�� ǥ�� �� �ð��� �� �ڸ�
	Hb = Hour2; //�ð� �� �ڸ��� �ʱ� ���� LCD�� ǥ�� �� �ð��� �� �ڸ�
	Mf = Min1; //�� �� �ڸ��� �ʱ� ���� LCD�� ǥ�� �� ���� �� �ڸ�
	Mb = Min2; //�� �� �ڸ��� �ʱ� ���� LCD�� ǥ�� �� ���� �� �ڸ�
	Sf = Sec1; //���� �ʱ� ���� LCD�� ǥ�� �� ���� �� �ڸ�
	Sb = Sec2; //���� �ʱ� ���� LCD�� ǥ�� �� ���� �� �ڸ�
		if(~rst) //Reset�� ���� �� ��� 0
			begin //Reset�� ������ 23:59:50�ʺ��� ����
				Hf = 8'b00110010;
				Hb = 8'b00110011;
				Mf = 8'b00110101;
				Mb = 8'b00111001;
				Sf = 8'b00110101;
				Sb = 8'b00110000;
			end
		else if(Stop == 0) //Stop�� Low ���� �� �� �۵�
			begin
				if(Sb==8'b00111001)
					begin
						if(Sf==8'b00110101)
							begin
								if(Mb==8'b00111001)  
									begin
										if(Mf==8'b00110101)
											begin
												if(Hf==8'b00110010 & Hb==8'b00110011) //23:59:59 �� �� 00:00:00 ��ȯ
													begin
														Hf = 8'b00110000;
														Hb = 8'b00110000;
														Mf = 8'b00110000;
														Mb = 8'b00110000;
														Sf = 8'b00110000;
														Sb = 8'b00110000;
													end
												else if(Hb==8'b00111001) //a9:59:59 �� �� (a+1)0:00:00 ��ȯ
													begin
														Hf = Hf + 1;
														Hb = 8'b00110000;
														Mf = 8'b00110000;
														Mb = 8'b00110000;
														Sf = 8'b00110000;
														Sb = 8'b00110000;
													end
												else  //ab:59:59 �� �� a(b+1):00:00 ��ȯ
													begin
														Hf = Hf;
														Hb = Hb + 8'b00000001;
														Mf = 8'b00110000;
														Mb = 8'b00110000;
														Sf = 8'b00110000;
														Sb = 8'b00110000;
													end
											end
										else //ab:c9:59�� �� ab:(c+1)0:00 ��ȯ
											begin
												Hf = Hf;
												Hb = Hb;
												Mf = Mf + 1;
												Mb = 8'b00110000;
												Sf = 8'b00110000;
												Sb = 8'b00110000;
											end
									end
								else //ab:cd:59�� �� ab:c(d+1):00 ��ȯ
									begin
										Hf = Hf;
										Hb = Hb;
										Mf = Mf;
										Mb = Mb + 1;
										Sf = 8'b00110000;
										Sb = 8'b00110000;
									end
							end
						else //ab:cd:e9�� �� ab:cd:(e+1)0��ȯ
							begin
								Hf = Hf;
								Hb = Hb;
								Mf = Mf;
								Mb = Mb;
								Sf = Sf + 1;
								Sb = 8'b00110000;
							end
							
					end
				else //ab:cd:ef �� �� ab:cd:e(f+1) ��ȯ
					begin
						Hf = Hf;
						Hb = Hb;
						Mf = Mf;
						Mb = Mb;
						Sf = Sf;
						Sb = Sb + 1;
					end
			end
		else //Stop�� High ���̸� �� ����
			begin
				Hf = Hf;
				Hb = Hb;
				Mf = Mf;
				Mb = Mb;
				Sf = Sf;
				Sb = Sb;
			end
	end



always@(*) //LCD�� �ð��� ������ ���� ��� �� �� �ð��� ���� ��� ���� �����ϴ� ����
	begin
		if(Stop==1) //Stop�� High�� ������ �ð� �� ��
			begin
				Sec1 = Scf;
				Sec2 = Scb;
				Min1 = Mcf;
				Min2 = Mcb;
				Hour1 = Hcf;
				Hour2 = Hcb;
			end
		else //Stop�� Low ���¸� �ð��� �ð� �� ��
			begin
				Sec1 = Sf;
				Sec2 = Sb;
				Min1 = Mf;
				Min2 = Mb;
				Hour1 = Hf;
				Hour2 = Hb;
			end
	end



always@(posedge clk or negedge rst) //Clock�� �Ʒ� ���� ����, LCD���� state�� ��ȭ ��Ű�� ����
	begin
		if(~rst)
			state = DELAY; //Reset �� �ʱ� state�� delay ����
		else
			begin
				case(state) //�Ʒ� always ������ cnt�� ���� state ���� ��ȭ
					DELAY : begin
					 if(cnt==70) state = FUNCTION_SET; //���� ���� �� ���� ���, Bit ���� ��, ��� ���� ���� State
					 LED_out = 8'b1000_0000;
					 end
					FUNCTION_SET : begin
					if(cnt==30) state = DISP_ONOFF; //ȭ�� On/off, Ŀ���� Ŀ�� ������ On/off ���� State
					LED_out = 8'b0100_0000;
					end
					DISP_ONOFF : begin
					if(cnt==30) state = ENTRY_MODE; //�б� ���� �������� Ŀ���� ��ġ, ȭ�� ��ȭ ���� State
					LED_out = 8'b0010_0000;
					end
					ENTRY_MODE : begin
					if(cnt==30) state = LINE1; //Ŀ���� ������ ȭ�� Shift�� �����ϴ� State
					LED_out = 8'b0001_0000;
					end
					LINE1 : begin
					if(cnt==20) state = LINE2; //ù ��° �� ��� State
					LED_out = 8'b0001_0100;
					end
					LINE2 : begin
					if(cnt==20) state = clock; //�� ��° �� ��� State
					LED_out = 8'b0000_0100;
					end
					clock : if(Stop==1) //Stop�� ���� ���� Count�� �׳� �ð� �� ���� �ϴ� State
									begin
										if(Hu) //Stop�� 1�̰� Count ��ư�� ������
											state = LINE1; //line 1���� �̵�
									end
							  else if(cnt==1) state = LINE1; //Stop�� 0�̸� �Ϲ� �ð�ó�� �۵�
					default : state = DELAY; //�⺻ ���´� Delay ����
				endcase
			end
	end

always@(posedge clk or negedge rst) //Clock�� �Ʒ� ���� ����, LCD���� State ���� �ֱ⸦ �����ϴ� ����
	begin
		if(~rst)
			cnt = 0;
		else
		begin
			case(state)
				DELAY : if(cnt >= 70) cnt = 0; //delay ������ �� cnt�� 70�� �Ǹ� cnt�� 0���� ������
						  else cnt = cnt + 1;    //�ƴϸ� cnt�� ���� ��Ŵ
				FUNCTION_SET : if(cnt >= 30) cnt = 0; //funcset ���� �� �� cnt�� 30�� �Ǹ� cnt�� 0���� ������
							 else cnt = cnt + 1;		//�ƴϸ� cnt�� ���� ��Ŵ
				DISP_ONOFF : if(cnt >= 30) cnt = 0;	//disponff ���� �� �� cnt�� 30�� �Ǹ� cnt�� 0���� ������
								else cnt = cnt + 1;	    //�ƴϸ� cnt�� ���� ��Ŵ
				ENTRY_MODE : if(cnt >= 30) cnt = 0;	//entry ���� �� �� cnt�� 30�� �Ǹ� cnt�� 0���� ������
						  else cnt = cnt + 1;	    //�ƴϸ� cnt�� ���� ��Ŵ
				LINE1 : if(cnt >= 20) cnt = 0;	//line1 ���� �� �� cnt�� 20�� �Ǹ� cnt�� 0���� ������
						  else cnt = cnt + 1;		    //�ƴϸ� cnt�� ���� ��Ŵ
				LINE2 : if(cnt >= 20) cnt = 0;	//line2 ���� �� �� cnt�� 20�� �Ǹ� cnt�� 0���� ������
						  else cnt = cnt + 1;		    //�ƴϸ� cnt�� ���� ��Ŵ
				clock : if(cnt >= 1) cnt = 0;  //clock ���� �� �� cnt�� 100�� �Ǹ� cnt�� 0���� ������
						  else cnt = cnt + 1; 		//�ƴϸ� cnt�� ���� ��Ŵ
				default : cnt = 0;					//�⺻ cnt ���� 0�̴�.
			endcase
		end
	end
	
always@(posedge clk or negedge rst)  //Clock���� �Ʒ� ���� ����, LCD ���� ���� ����.
	begin
		if(~rst)  //Reset�� 0�̸�
			begin
				LCD_RS = 1'b1; //rs�� 1��Ʈ 1 ����, data register ����
				LCD_RW = 1'b1; //rw�� 1��Ʈ 1 ����, Write ���� ����
				LCD_DATA = 8'b00000000; //data���� 0�� ���
			end
		else
			begin
				case(state) 
				FUNCTION_SET : 
				begin
				LCD_RS = 1'b0; //Instruction register ����
				LCD_RW = 1'b0; //Read ����
				LCD_DATA = 8'b00111100; //8��Ʈ, 2��, 5x11 ��Ʈ ����
				end
				
				DISP_ONOFF : 
				begin
				LCD_RS = 1'b0; //Instruction register ����
				LCD_RW = 1'b0;	//Read ����
				LCD_DATA = 8'b00001111; //Display On, Cursor On, ������ On
				end
				
				ENTRY_MODE : 
				begin
				LCD_RS = 1'b0; //Instruction register ����
				LCD_RW = 1'b0; //Read ����
				LCD_DATA = 8'b00000110;	//Ŀ�� �̵� ������, Cursor�̵� O, ȭ�� �̵� X
				end
				LINE1:
		begin
			LCD_RW=1'b0;
			case(cnt)
			0:
			begin
				LCD_RS=1'b0;
				LCD_DATA=8'b10000000;
			end
			1:
			begin
			 	LCD_RS=1'b1;
				LCD_DATA=8'b01010100;//T
			end
			2:
			begin
				LCD_RS=1'b1;
				LCD_DATA=8'b01001001;//I
			end
			3:
			begin
				LCD_RS=1'b1;
				LCD_DATA=8'b01001101;//M

			end
			4:
			begin
				LCD_RS=1'b1;
				LCD_DATA=8'b01000101;//E
			end
			5:
			begin
				LCD_RS=1'b1;
				LCD_DATA=8'b00100000;// 
			end
			6:
			begin
				LCD_RS=1'b1;
				LCD_DATA=8'b00111010;//:
			end
			7:
			begin
				LCD_RS=1'b1;
				LCD_DATA=8'b00100000;// 
			end
			8:
			begin
				LCD_RS=1'b1;
				LCD_DATA=Hf;
			end
			9:
			begin
				LCD_RS=1'b1;
				LCD_DATA=Hb;
			end
			10:
			begin
				LCD_RS=1'b1;
				LCD_DATA=8'b00111010;//:
			end
			11:
			begin
				LCD_RS=1'b1;
				LCD_DATA=Mf;
			end
			12:
			begin
				LCD_RS=1'b1;
				LCD_DATA=Mb;
			end
			13:
			begin
				LCD_RS=1'b1;
				LCD_DATA=8'b00111010;//:
			end
			14:
			begin
				LCD_RS=1'b1;
				LCD_DATA=Sf;
			end
			15:
			begin
				LCD_RS=1'b1;
				LCD_DATA=Sb;
			end
			16:
			begin
				LCD_RS=1'b1;
				LCD_DATA=8'b00100000;
			end
			default:
			begin
				LCD_RS=1'b1;
				LCD_DATA=8'b00110000;
			end
			endcase
		end
		
		LINE2:
		begin
			LCD_RW=1'b0;
			case(cnt)
			0:
			begin
				LCD_RS=1'b0;
				LCD_DATA=8'b11000000;
			end
			1:
			begin
				LCD_RS=1'b1;
				LCD_DATA=8'b01010011;//S

			end
			2:
			begin
			 	LCD_RS=1'b1;
				LCD_DATA=8'b01010100;//T
			end
			3:
			begin
			   LCD_RS=1'b1;
			   LCD_DATA=8'b01000001;//A
			end
			4:
			begin
			 	LCD_RS=1'b1;
				LCD_DATA=8'b01010100;//T
			end
			5:
			begin
				LCD_RS=1'b1;
				LCD_DATA=8'b01000101;//E
			end
			6:
			begin
				LCD_RS=1'b1;
				LCD_DATA=8'b00111010;//:
			end
			7:
			begin
				LCD_RS=1'b1;
				LCD_DATA=8'b00100000;
			end
			8:
			begin
				LCD_RS=1'b1;
				LCD_DATA=8'b00100000;
			end
			9:
			begin
				LCD_RS=1'b1;
				LCD_DATA=8'b00111010;//:
			end
			10:
			begin
				LCD_RS=1'b1;
				LCD_DATA=8'b00111010;//:
			end
			11:
			begin
				LCD_RS=1'b1;
				LCD_DATA=8'b00111010;//:
			end
			12:
			begin
				LCD_RS=1'b1;
				LCD_DATA=8'b00111010;//:
			end
			13:
			begin
				LCD_RS=1'b1;
				LCD_DATA=8'b00111010;//:
			end
			14:
			begin
				LCD_RS=1'b1;
				LCD_DATA=8'b00111010;//:
			end
			15:
			begin
				LCD_RS=1'b1;
				LCD_DATA=8'b00111010;//:
			end
			16:
			begin
				LCD_RS=1'b1;
				LCD_DATA=8'b00111010;//:
			end
			default:
			begin
				LCD_RS=1'b1;
				LCD_DATA=8'b00100000;
			end
			endcase
		end//LINE2 end
		
		default:
		begin
			LCD_RS=1'b1;
			LCD_RW=1'b1;
			LCD_DATA=8'b00000000;
		end
		endcase
	end
end
				
		assign LCD_E = clk; //Enable�� Clock ����
		
endmodule



