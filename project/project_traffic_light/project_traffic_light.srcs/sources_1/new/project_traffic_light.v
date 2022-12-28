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
	input clk,rst,Hu,Stop; //clk,rst와 시,분,초 Count, Stop조절 상태를 Input 선언
	output LCD_E, LCD_RS,LCD_RW; //Instruction/data Register를 나타내는 RS, 읽기와 쓰기를 제어하는 RW, Enable E를 output으로 선언
	output [7:0]LCD_DATA; //출력되는 Output 8비트로 선언
	output reg [7:0]LED_out;
	wire LCD_E;
	reg [7:0]Scf; //시간을 조절하는 초의 앞 자리를 8비트와 Reg로 선언
	reg [7:0]Scb; //시간을 조절하는 초의 뒷 자리를 8비트와 Reg로 선언
	reg [7:0]Mcf; //시간을 조절하는 분의 앞 자리를 8비트와 Reg로 선언
	reg [7:0]Mcb; //시간을 조절하는 분의 뒷 자리를 8비트와 Reg로 선언
	reg [7:0]Hcf; //시간을 조절하는 시간의 앞 자리를 8비트와 Reg로 선언
	reg [7:0]Hcb; //시간을 조절하는 시간의 뒷 자리를 8비트와 Reg로 선언
	reg [7:0]Sf;  //시계의 초의 앞 자리를 8비트와 Reg로 선언
	reg [7:0]Sb;  //시계의 초의 뒷 자리를 8비트와 Reg로 선언
	reg [7:0]Mf;  //시계의 분의 앞 자리를 8비트와 Reg로 선언
	reg [7:0]Mb;  //시계의 분의 뒷 자리를 8비트와 Reg로 선언
	reg [7:0]Hf;  //시계의 시간의 앞 자리를 8비트와 Reg로 선언
	reg [7:0]Hb;  //시계의 시간의 뒷 자리를 8비트와 Reg로 선언
	
	reg LCD_RS,LCD_RW; //always구문에서 이용하기 위해 RS, RW reg로 선언
	reg [7:0]LCD_DATA; //Instruction과 출력 될 값을 위한 data를 reg로 선언
	reg [2:0]state; // LCD를 제어하는 State를 reg로 선언
	
	wire huout0; //Oneshot Enable을 만들기위해 wire 연결

	

    oneshot Hour_up(clk,rst,huout0 ,Huen); //시간 Up의 Oneshot을 위한 Instance
	
	integer cnt; //State를 조절하는 cnt를 integer로 선언
	integer cnt_1hz; //시계를 구현하는 Clock을 1hz로 분주 시키기 위한 변수
	integer Sec1; //LCD의 Line에 들어 갈 초의 앞 자리
	integer Sec2; //LCD의 Line에 들어 갈 초의 뒷 자리
	integer Min1; //LCD의 Line에 들어 갈 분의 앞 자리
	integer Min2; //LCD의 Line에 들어 갈 분의 뒷 자리
	integer Hour1; //LCD의 Line에 들어 갈 시간의 앞 자리
	integer Hour2; //LCD의 Line에 들어 갈 시간의 뒷 자리
	
	
	reg clk_1hz;  //분주 된 Clock의 변수
	
	parameter DELAY = 3'b000, FUNCTION_SET = 3'b001, //Parameter로 각각의 state를 정의
				 ENTRY_MODE = 3'b010, DISP_ONOFF = 3'b011,
				 LINE1 = 3'b100, LINE2 = 3'b101,
				 clock = 3'b110;
	

	

always@ (posedge clk or negedge rst) //시 Counting 값
	 begin
	 Hcf = Hour1; //Count 되기 전 시간의 앞 자리를 LCD에 표시된 Data 값이 들어감
	 Hcb = Hour2; //Count 되기 전 시간의 뒷 자리를 LCD에 표시된 Data 값이 들어감
		if(~rst)
		 begin
			Hcf = 8'b00110000; //시 앞 자리 초기값 0
			Hcb = 8'b00110000; //시 뒷 자리 초기값 0
		 end
		else if(Stop)
			begin
				if(Huen) //시 Count Up 누를 시
					begin
						if(Hcb == 8'b00111001) //두 자리 중 뒷 자리가 9면
							begin
								Hcf = Hcf + 1; //앞 자리에 1을 더하고
								Hcb = 8'b00110000; //뒷 자리는 0
							end
						else if(Hcf == 8'b00110010 & Hcb == 8'b00110011) //앞 자리가 2, 뒷 자리가 3이면
							begin
								Hcf = 8'b00110000; //앞 자리 0
								Hcb = 8'b00110000; //뒷 자리 0
							end
						else //뒷 자리가 9가 아니면
							Hcb = Hcb + 1; // 뒷 자리에 1 더함
					end
			end
		else //Stop이 Low 상태 일 때 시간의 값 유지
			begin
				Hcf = Hcf;
				Hcb = Hcb;
			end
	end
	
always@(posedge clk or negedge rst) //Clock 분주 구문
	begin
		if(~rst) //rst가 1비트 0이면 아래 구문 실행
			begin
				cnt_1hz = 0;
				clk_1hz = 1'b0;
			end
		else if (cnt_1hz >= 499) //clock를 10분주 시켜주는 구문 (cnt_100hz가 0~49 500개이므로 *2 하여 1000)
			begin
				cnt_1hz = 0;
				clk_1hz = ~ clk_1hz;
			end
		else
			cnt_1hz = cnt_1hz + 1;
	end

always@ (posedge clk_1hz or negedge rst) //분주된 Clock에 의해 실제 시계 동작 구문
	begin
	Hf = Hour1; //시간 앞 자리의 초기 값은 LCD의 표시 된 시간의 앞 자리
	Hb = Hour2; //시간 뒷 자리의 초기 값은 LCD의 표시 된 시간의 뒷 자리
	Mf = Min1; //분 앞 자리의 초기 값은 LCD의 표시 된 분의 앞 자리
	Mb = Min2; //분 뒷 자리의 초기 값은 LCD의 표시 된 분의 뒷 자리
	Sf = Sec1; //초의 초기 값은 LCD의 표시 된 초의 앞 자리
	Sb = Sec2; //초의 초기 값은 LCD의 표시 된 초의 뒷 자리
		if(~rst) //Reset을 누를 때 모두 0
			begin //Reset을 누르면 23:59:50초부터 시작
				Hf = 8'b00110010;
				Hb = 8'b00110011;
				Mf = 8'b00110101;
				Mb = 8'b00111001;
				Sf = 8'b00110101;
				Sb = 8'b00110000;
			end
		else if(Stop == 0) //Stop이 Low 상태 일 때 작동
			begin
				if(Sb==8'b00111001)
					begin
						if(Sf==8'b00110101)
							begin
								if(Mb==8'b00111001)  
									begin
										if(Mf==8'b00110101)
											begin
												if(Hf==8'b00110010 & Hb==8'b00110011) //23:59:59 일 때 00:00:00 반환
													begin
														Hf = 8'b00110000;
														Hb = 8'b00110000;
														Mf = 8'b00110000;
														Mb = 8'b00110000;
														Sf = 8'b00110000;
														Sb = 8'b00110000;
													end
												else if(Hb==8'b00111001) //a9:59:59 일 때 (a+1)0:00:00 반환
													begin
														Hf = Hf + 1;
														Hb = 8'b00110000;
														Mf = 8'b00110000;
														Mb = 8'b00110000;
														Sf = 8'b00110000;
														Sb = 8'b00110000;
													end
												else  //ab:59:59 일 때 a(b+1):00:00 반환
													begin
														Hf = Hf;
														Hb = Hb + 8'b00000001;
														Mf = 8'b00110000;
														Mb = 8'b00110000;
														Sf = 8'b00110000;
														Sb = 8'b00110000;
													end
											end
										else //ab:c9:59일 때 ab:(c+1)0:00 반환
											begin
												Hf = Hf;
												Hb = Hb;
												Mf = Mf + 1;
												Mb = 8'b00110000;
												Sf = 8'b00110000;
												Sb = 8'b00110000;
											end
									end
								else //ab:cd:59일 때 ab:c(d+1):00 반환
									begin
										Hf = Hf;
										Hb = Hb;
										Mf = Mf;
										Mb = Mb + 1;
										Sf = 8'b00110000;
										Sb = 8'b00110000;
									end
							end
						else //ab:cd:e9일 때 ab:cd:(e+1)0반환
							begin
								Hf = Hf;
								Hb = Hb;
								Mf = Mf;
								Mb = Mb;
								Sf = Sf + 1;
								Sb = 8'b00110000;
							end
							
					end
				else //ab:cd:ef 일 때 ab:cd:e(f+1) 반환
					begin
						Hf = Hf;
						Hb = Hb;
						Mf = Mf;
						Mb = Mb;
						Sf = Sf;
						Sb = Sb + 1;
					end
			end
		else //Stop이 High 값이면 값 유지
			begin
				Hf = Hf;
				Hb = Hb;
				Mf = Mf;
				Mb = Mb;
				Sf = Sf;
				Sb = Sb;
			end
	end



always@(*) //LCD에 시간을 조정한 값이 들어 갈 지 시계의 값이 들어 갈지 결정하는 구문
	begin
		if(Stop==1) //Stop이 High면 조정한 시간 값 들어감
			begin
				Sec1 = Scf;
				Sec2 = Scb;
				Min1 = Mcf;
				Min2 = Mcb;
				Hour1 = Hcf;
				Hour2 = Hcb;
			end
		else //Stop이 Low 상태면 시계의 시간 값 들어감
			begin
				Sec1 = Sf;
				Sec2 = Sb;
				Min1 = Mf;
				Min2 = Mb;
				Hour1 = Hf;
				Hour2 = Hb;
			end
	end



always@(posedge clk or negedge rst) //Clock로 아래 구문 실행, LCD제어 state를 변화 시키는 구문
	begin
		if(~rst)
			state = DELAY; //Reset 시 초기 state는 delay 상태
		else
			begin
				case(state) //아래 always 구문의 cnt로 인해 state 상태 변화
					DELAY : begin
					 if(cnt==70) state = FUNCTION_SET; //전원 투입 후 최초 명령, Bit 수와 행, 밝기 설정 조절 State
					 LED_out = 8'b1000_0000;
					 end
					FUNCTION_SET : begin
					if(cnt==30) state = DISP_ONOFF; //화면 On/off, 커서와 커서 깜박임 On/off 조절 State
					LED_out = 8'b0100_0000;
					end
					DISP_ONOFF : begin
					if(cnt==30) state = ENTRY_MODE; //읽기 쓰기 과정에서 커서의 위치, 화면 변화 조절 State
					LED_out = 8'b0010_0000;
					end
					ENTRY_MODE : begin
					if(cnt==30) state = LINE1; //커서의 증감과 화면 Shift를 제어하는 State
					LED_out = 8'b0001_0000;
					end
					LINE1 : begin
					if(cnt==20) state = LINE2; //첫 번째 행 출력 State
					LED_out = 8'b0001_0100;
					end
					LINE2 : begin
					if(cnt==20) state = clock; //두 번째 행 출력 State
					LED_out = 8'b0000_0100;
					end
					clock : if(Stop==1) //Stop의 값에 따라 Count와 그냥 시계 를 조절 하는 State
									begin
										if(Hu) //Stop이 1이고 Count 버튼을 누르면
											state = LINE1; //line 1으로 이동
									end
							  else if(cnt==1) state = LINE1; //Stop이 0이면 일반 시계처럼 작동
					default : state = DELAY; //기본 상태는 Delay 상태
				endcase
			end
	end

always@(posedge clk or negedge rst) //Clock로 아래 구문 실행, LCD제어 State 제어 주기를 조절하는 구문
	begin
		if(~rst)
			cnt = 0;
		else
		begin
			case(state)
				DELAY : if(cnt >= 70) cnt = 0; //delay 상태일 때 cnt가 70이 되면 cnt를 0으로 돌리고
						  else cnt = cnt + 1;    //아니면 cnt를 증가 시킴
				FUNCTION_SET : if(cnt >= 30) cnt = 0; //funcset 상태 일 때 cnt가 30이 되면 cnt를 0으로 돌리고
							 else cnt = cnt + 1;		//아니면 cnt를 증가 시킴
				DISP_ONOFF : if(cnt >= 30) cnt = 0;	//disponff 상태 일 때 cnt가 30이 되면 cnt를 0으로 돌리고
								else cnt = cnt + 1;	    //아니면 cnt를 증가 시킴
				ENTRY_MODE : if(cnt >= 30) cnt = 0;	//entry 상태 일 때 cnt가 30이 되면 cnt를 0으로 돌리고
						  else cnt = cnt + 1;	    //아니면 cnt를 증가 시킴
				LINE1 : if(cnt >= 20) cnt = 0;	//line1 상태 일 때 cnt가 20이 되면 cnt를 0으로 돌리고
						  else cnt = cnt + 1;		    //아니면 cnt를 증가 시킴
				LINE2 : if(cnt >= 20) cnt = 0;	//line2 상태 일 때 cnt가 20이 되면 cnt를 0으로 돌리고
						  else cnt = cnt + 1;		    //아니면 cnt를 증가 시킴
				clock : if(cnt >= 1) cnt = 0;  //clock 상태 일 떄 cnt가 100이 되면 cnt를 0으로 돌리고
						  else cnt = cnt + 1; 		//아니면 cnt를 증가 시킴
				default : cnt = 0;					//기본 cnt 값은 0이다.
			endcase
		end
	end
	
always@(posedge clk or negedge rst)  //Clock으로 아래 구문 실행, LCD 실제 동작 제어.
	begin
		if(~rst)  //Reset이 0이면
			begin
				LCD_RS = 1'b1; //rs에 1비트 1 대입, data register 선택
				LCD_RW = 1'b1; //rw에 1비트 1 대입, Write 상태 선택
				LCD_DATA = 8'b00000000; //data에는 0이 출력
			end
		else
			begin
				case(state) 
				FUNCTION_SET : 
				begin
				LCD_RS = 1'b0; //Instruction register 선택
				LCD_RW = 1'b0; //Read 상태
				LCD_DATA = 8'b00111100; //8비트, 2줄, 5x11 폰트 선택
				end
				
				DISP_ONOFF : 
				begin
				LCD_RS = 1'b0; //Instruction register 선택
				LCD_RW = 1'b0;	//Read 상태
				LCD_DATA = 8'b00001111; //Display On, Cursor On, 깜박임 On
				end
				
				ENTRY_MODE : 
				begin
				LCD_RS = 1'b0; //Instruction register 선택
				LCD_RW = 1'b0; //Read 상태
				LCD_DATA = 8'b00000110;	//커서 이동 오른쪽, Cursor이동 O, 화면 이동 X
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
				
		assign LCD_E = clk; //Enable에 Clock 대입
		
endmodule



