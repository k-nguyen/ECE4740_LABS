module Project5 (input CLOCK_50, output [17:0] LEDR, output [7:0] LEDG, output [6:0] HEX0, output [6:0] HEX1, output [6:0] HEX2, output [6:0] HEX3, output [6:0] HEX4, output [6:0] HEX5, output [6:0] HEX6, output [6:0] HEX7);

wire clock50, clock25, clock0, clock;
	reg [31:0] a32BitReg;
	assign clock50 = CLOCK_50, clock25 = a32BitReg[25], clock0 = a32BitReg[0];
	always @ (posedge clock50)
		 a32BitReg <= a32BitReg + 1;
	assign LEDG[0] = clock0 ;
	assign LEDG[1] = clock25;
	assign clock = clock25;
	
	//tri [31:0] BusA, BusB;
	//reg PCTristateEnable, BrTristateEnable; 
	
	wire [31:0] S1Out, S2Out, PCOut, IMOut, DMOut, aluOut, aluMuxOut, memMuxOut, PCMuxOut, PCAddOut;
	wire [6:0] ssd1, ssd2, ssd3, ssd0, ssd4, ssd5, ssd6, ssd7;
	reg DMRead, memWrite, PCWrite, PCReset, RFReset, S1Read, S2Read, DestRead, RFWrite;
	//reg aluMux_S, memMux_S;
	reg [1:0] PCMux_S;
	reg [15:0] PCIn;
	wire[11:0] literal;
	wire alu_N, alu_Z, alu_V, alu_C, N_FF, Z_FF, V_FF, C_FF;
	wire r2r, load, literal_bit, store, r_bit;
	reg N_FF_enable, Z_FF_enable, V_FF_enable, C_FF_enable;
	reg [2:0] currentState; //alu_S, 
	reg [3:0] br_S;
	wire [2:0] S1, S2, destIn;
	wire [3:0] param;
	wire [5:0] control_bits;
	wire br, jmp;
	wire brOut;
	
	assign S1 = IMOut[20:18];
	assign S2 = IMOut[17:15];
	assign destIn = IMOut[14:12];
	assign param = IMOut[24:21];
	assign literal = IMOut[11:0];
	assign r2r = IMOut[27];
	assign load = IMOut[31];
	assign store = IMOut[30];
	assign literal_bit = IMOut[25];
	assign br = IMOut[29];
	assign control_bits[5:1] = IMOut[31:27];
	assign control_bits[0] = IMOut[25];
	assign r_bit = IMOut[26];
	assign jmp = IMOut[28];
	

	//assign BusA = aluOut;
	
//	assign LEDR[3:0] = literal[3:0];
//	assign LEDR[7:4] = S1Out;
//	assign LEDR[11:8] = S2Out;
//	assign LEDR[13:12] = brOut;
//	assign LEDR[17:14] = param; 

	assign LEDR[3] = N_FF;
	assign LEDR[2] = Z_FF;
	assign LEDR[1] = V_FF;
	assign LEDR[0] = C_FF;
	
	assign LEDR[4] = brOut;
	assign LEDR[8:5] = param;
	
	assign LEDR[12] = alu_N;
	assign LEDR[11] = alu_Z;
	assign LEDR[10] = alu_V;
	assign LEDR[9] = alu_C;
	

	//assign LEDG[7:5] = currentState;
	
	assign LEDG[7:2] = control_bits;
	
	assign HEX0[6:0] = ssd0;
	assign HEX1[6:0] = ssd1;
	assign HEX2[6:0] = ssd2;
	assign HEX3[6:0] = ssd3;
	assign HEX4[6:0] = ssd4;
	assign HEX5[6:0] = ssd5;
	assign HEX6[6:0] = ssd6;
	assign HEX7[6:0] = ssd7;
	
	initial begin
		currentState = 0;
		//alu_S = 0;
		memWrite = 0;
		PCWrite = 0;
		RFWrite = 0;
		//memMux_S = 0;
		//aluMux_S = 0;
		//RFReset = 0;
		br_S = 0; 
		//PCTristateEnable = 0;
		//BrTristateEnable = 0;
		//PCReset = 0;
		//RFReset = 0;
		//PCMux_S = 0;
	end
	
	register PC (PCMuxOut, PCWrite, r_bit, clock, PCOut);
	mem myMem (PCOut, aluOut, clock, memWrite, S2Out, IMOut, DMOut, r_bit);
	regFile myRegFile(S1, S2, memMuxOut, destIn, RFWrite, S1Out, S2Out, clock, r_bit);
	alu myALU (S1Out, aluMuxOut, param, aluOut, alu_N, alu_Z, alu_V, alu_C);
	
	//adder PCAdd (PCOut, PCAddOut);
	
	branch myBranch (br_S, N_FF, Z_FF, V_FF, C_FF, brOut);
	
	mux2 memMux (aluOut, DMOut, store|load, memMuxOut);
	mux2 aluMux (S2Out, literal, literal_bit, aluMuxOut);
	mux4 PCMux (PCOut, literal, aluOut, brOut, jmp, PCMuxOut);
	
	SevenSeg16 PCCounter(PCOut[15:0], ssd0, ssd1, ssd2, ssd3);
	SevenSeg16 PCCounter2(aluOut[15:0], ssd4, ssd5, ssd6, ssd7);
	
	//TristateBus PCTristate (PCMuxOut, PCTristateEnable, BusA);
	//TristateBus BrTristate (brOut, BrTristateEnable, BusB);
	//TristateBus S2Tristate (S2, S2TristateEnable, BusE);
	
	flipflop nFF(alu_N, clock, N_FF_enable, N_FF);
	flipflop zFF(alu_Z, clock, Z_FF_enable, Z_FF);
	flipflop vFF(alu_V, clock, V_FF_enable, V_FF);
	flipflop cFF(alu_C, clock, C_FF_enable, C_FF);
	
	always @ (posedge clock)
	begin
		N_FF_enable = 1;  Z_FF_enable = 1;  V_FF_enable = 1;  C_FF_enable = 1;
		if(br==1)
			begin N_FF_enable = 0;  Z_FF_enable = 0;  V_FF_enable = 0;  C_FF_enable = 0; br_S = param;  end
		else
			begin br_S = 0;  end
	
		case(currentState)
			0: begin PCWrite = 1; RFWrite = r2r; memWrite = store; currentState = 3'b0001; end
			1: begin PCWrite = 0; RFWrite = 0; memWrite = 0;  currentState = 3'b0000; end
		endcase
		
	end
endmodule

module mux2(in1, in2, S, out);
	input wire[31:0] in1, in2;
	input wire S;
	output reg [31:0] out;
		
	always @(in1, in2, S)
	begin
		case(S)
			0: out = in1;
			1: out = in2;
			default: out = 0;
		endcase
	end
endmodule

module mux4(PCAdd, offset, jmp, S[0], S[1], out);
	input wire[31:0] PCAdd, offset, jmp;
	input wire[1:0] S;
	output reg [31:0] out;
		
	always @(PCAdd, offset, jmp, S)
	begin
		case(S)
			0: out = PCAdd+1;
			1: out = PCAdd+offset+1;
			2: out = jmp;
			3: out = PCAdd;
			default: out = PCAdd;
		endcase
	end
endmodule

module adder(in, out);
	input [31:0] in;
	output reg [31:0] out;
	
	always@(in)
		out = in+1;
endmodule

module alu (IN1, IN2, S, OUT, N, Z, V, C);
	parameter MSB = 31; //32-bit alu
	input [MSB:0] IN1, IN2, S;
	output reg [MSB+1:0] OUT;
	output reg N, Z, V, C;
	always @ (IN1, IN2, S)
	begin
		case (S)
			0: OUT = 0;
			1: OUT = IN1;
			2: OUT = IN2;
			3: OUT = IN1 + IN2;
			4: OUT = IN1 - IN2;
			5: OUT = IN1 | IN2;
			6: OUT = IN1 & IN2;
			7: OUT = IN1 + 1;
			default: OUT = MSB+1'bz;
		endcase
		N = OUT[MSB];
		Z = (OUT[MSB:0]==0) ? 1'b1:1'b0;
		if(S==3) V = IN1[MSB]&IN2[MSB]&~OUT[MSB] | ~IN1[MSB]&~IN2[MSB]&OUT[MSB];
			else if(S==4) V = ~IN1[MSB]&IN2[MSB]&OUT[MSB] | IN1[MSB]&~IN2[MSB]&~OUT[MSB];
			else V = 1'bz;
		C = OUT[MSB+1];
	end
endmodule

module regFile(S1, S2, dataIn, destIn, W, outS1, outS2, clock, reset);
	parameter MSB = 31; //32-bit register
	input [2:0] S1, S2, destIn; //from opcode
	input W, clock, reset; //controls for ports
	input [MSB:0] dataIn;
	output reg [MSB:0] outS1, outS2;
	reg [31:0] ram[7:0];
	
	initial begin
		//$readmemb("ram.txt", ram);
		//8 registers
		ram[0] = 32'b00000000000000000000000000000111;  //r0 = 7
		ram[1] = 32'b00000000000000000000000000000001;  //r1 = 1
		ram[2] = 32'b00000000000000000000000000000011;  //r2 = 3
		ram[3] = 32'b00000000000000000000000000000000;  
		ram[4] = 32'b00000000000000000000000000000000;  
		ram[5] = 32'b00000000000000000000000000000000;  
		ram[6] = 32'b00000000000000000000000000000000; 
		ram[7] = 32'b00000000000000000000000000000000;  
	end
	
	always @ (S1, S2)
	begin
		if(reset)
			begin outS1<=0; outS2<=0; end
		else
			begin outS1<=ram[S1]; outS2<=ram[S2]; end
	end
	
	always @ (posedge clock)
	begin
		if(W)
			ram[destIn]<=dataIn;	
	end
	
endmodule

//Branch controller
module branch(S, N, Z, V, C, out);
	input N, Z, V, C;
	input [3:0] S;
	output reg out;
	
	always @(S, N, Z, V, C)
	begin
		case(S)
			0: out = 0;							//never branch
			1: out = Z; 						//beq, branch if Z = 1;
			2: out = !Z; 						//bne, Z = 0;
			3: out = C;							//bcs, unsigned higher or same
			4: out = !C;						//bcc, unsigned lower
			5: out = N;							//bmi, negative
			6: out = !N;						//bpl, postive or zero
			7: out = V;							//bvs, overflow
			8: out = !V;						//bvc, no overflow
			9: out = C&!Z;						//bhi, unsigned higher	
			10: out = !C|Z;					//bls, unsigned lower or same
			11: out = (N&V)|(!N&!V);		//bge, greater or equal
			12: out = N^V;						//blt, less than
			13: out = !Z&((N&V)|(!N&!V));	//bgt, greater than
			14: out = Z|(N^V);				//ble, less than or equal
			15: out = 1;						//bra, always
			default: out = 0;	
		endcase
	end
endmodule

module mem(input [5:0] PCAddress, input [5:0] MAddress, input clock, Write, input [31:0] mDataIn, output reg [31:0] PCDataOut, output reg [31:0] mDataOut, input reset);
	reg [31:0] ram[63:0];
	initial begin
		//$readmemb("ram.txt", ram);
		//LSBJRX#_param_s1_s2_dest_literal
		
		//add instruction
//		ram[0] 	= 32'b0000100_0011_000_001_010_000000000000;	//r2r, add, r2 = r0+r1
//		ram[1] 	= 32'b0000100_0011_000_001_010_000000000000;	//r2r, add, r2 = r0+r1
		
		//load instruction
//		ram[0] 	= 32'b1000001_0011_001_111_100_000000100000;	//load d, (s1,#L); r4 = [M(1+32]; NOTE: s2 is not used here
//		ram[33]	= 32'b0000000_0000_000_000_000_000000001111; //[M(32)] = 15 = F = 1111; 
		
		//store instruction
//		ram[0]	= 32'b0100001_0011_001_010_001_000000100000;	//str S2(S1,#L); M[S1+L] = S2; M[1+32] = 3
//		//loaded r4 with contents of M[33] to show that the store instruction worked
//		//r4 = M[33] = 3
//		ram[1] 	= 32'b1000001_0011_001_111_100_000000100000;	//load d, (s1,#L); r4 = [M(1+32)]; NOTE: s2 is not used here
		
		//branch instruction
//		ram[0]	= 32'b0010001_1111_100_100_100_000000000100;	//bra to 5; PC = PC+L+1 = 0+4+1 = 5
//		ram[5] 	= 32'b0000010_0000_000_000_000_000000000000;	//reset
		
		//reset instruction
//		ram[0] 	= 32'b0000100_0011_001_001_010_000000000000;	//add r2 = r1+r1
//		ram[1] 	= 32'b0000100_0001_010_010_010_000000000000;	//read r2
//		ram[2] 	= 32'b0000010_0000_000_000_000_000000000000;	//reset
		
		//jump instruction
//		ram[0] 	= 32'b0001001_0011_001_000_000_000000000110;	//jmp (s1, #L); PC = S1 + L = R1 + L = 1 + 6 = 7
//		ram[1] 	= 32'b0000100_0011_001_001_010_000000000000;	//add r2 = r1+r1 = 2
//		ram[2] 	= 32'b0000100_0001_010_010_010_000000000000;	//read r2
//		ram[7] 	= 32'b0000010_0000_000_000_000_000000000000;	//reset

		ram[0]	= 32'b0000100_0100_000_000_000_000000000000; //cmp
		ram[1]	= 32'b0010000_0001_000_000_000_000000000101; //beq, if equal, PC = 5+1+1 = 7
		ram[7]	= 32'b0000010_0000_000_000_000_000000000000;	//reset



	end

	always @(posedge clock) //Writing to data memory
	begin 
		if (Write)
			ram[MAddress] <= mDataIn;
	end
	
	always @(PCAddress) //Reading from instruction memory
	begin PCDataOut <= ram[PCAddress];end 
	
	always @(MAddress, reset) //Reading from data memory
	begin 
		if(reset==1)
			mDataOut <= 0;
		else 
			mDataOut <= ram[MAddress]; 
	end 

endmodule

module register (in, W, Reset, clock, out);
	parameter MSB = 31; //32-bit register
	input [MSB:0] in;
	input W, Reset, clock;
	output reg [MSB:0] out;
	initial begin
		out = 0; //Need to specify entire bits, i.e., cannot do out[9:7] = -1
	end
	always @ (posedge clock)
	begin
		if(Reset == 1)
			out <= 0;
		else if (W==1)
			out <= in;
	end
endmodule

module TristateBus (in, oe, out);
	parameter MSB = 31; //32-bit Tristate Buffer

   input wire [MSB:0] in;
	input wire oe;
   output tri [MSB:0] out;

   bufif1  b0(out[0], in[0], oe); //http://www.altera.com/support/examples/verilog/ver_tristate.html
   bufif1  b1(out[1], in[1], oe);
   bufif1  b2(out[2], in[2], oe);
   bufif1  b3(out[3], in[3], oe);
   bufif1  b4(out[4], in[4], oe); 
   bufif1  b5(out[5], in[5], oe);
   bufif1  b6(out[6], in[6], oe);
   bufif1  b7(out[7], in[7], oe);
   bufif1  b8(out[8], in[8], oe); 
   bufif1  b9(out[9], in[9], oe);
   bufif1  b10(out[10], in[10], oe);
   bufif1  b11(out[11], in[11], oe);
   bufif1  b12(out[12], in[12], oe);
   bufif1  b13(out[13], in[13], oe);
   bufif1  b14(out[14], in[14], oe);
   bufif1  b15(out[15], in[15], oe);
	bufif1  b16(out[16], in[16], oe);
	bufif1  b17(out[17], in[17], oe);
	bufif1  b18(out[18], in[18], oe);
	bufif1  b19(out[19], in[19], oe);
	bufif1  b20(out[20], in[20], oe);
	bufif1  b21(out[21], in[21], oe);
	bufif1  b22(out[22], in[22], oe);
	bufif1  b23(out[23], in[23], oe);
	bufif1  b24(out[24], in[24], oe);
	bufif1  b25(out[25], in[25], oe);
	bufif1  b26(out[26], in[26], oe);
	bufif1  b27(out[27], in[27], oe);
	bufif1  b28(out[28], in[28], oe);
	bufif1  b29(out[29], in[29], oe);
	bufif1  b30(out[30], in[30], oe);
	bufif1  b31(out[31], in[31], oe);

endmodule

module flipflop (input D, CLK, enable, output reg Q); 
	always @ (posedge CLK)
		if(enable)
			Q <= D;
endmodule

//********************************************************************************************
// Name: SevenSeg16
// Purpose: 
//********************************************************************************************
module SevenSeg16 (val, ssd1, ssd2, ssd3, ssd4); 
  input wire [15:0] val;
  output wire [6:0] ssd1; // val[3:0]
  output wire [6:0] ssd2; // val[7:4]
  output wire [6:0] ssd3; // val[11:8]
  output wire [6:0] ssd4; // val[15:12]
  
  SevenSegDriver seg0 (val[3:0], ssd1);
  SevenSegDriver seg1 (val[7:4], ssd2);
  SevenSegDriver seg2 (val[11:8], ssd3);
  SevenSegDriver seg3 (val[15:12], ssd4);
endmodule

//********************************************************************************************
// Name: SevenSegDriver
// Purpose: 
//********************************************************************************************
module SevenSegDriver (val, ssd);
  input wire [3:0] val; // 4-bit input value
  output reg [6:0] ssd; // Decoded value sent to SSD

  always @ (*)
  begin
    case(val)
      0: 
        ssd = 7'b1000000;
      1: 
        ssd = 7'b1111001;
      2: 
        ssd = 7'b0100100;
      3: 
        ssd = 7'b0110000;
      4: 
        ssd = 7'b0011001;
      5: 
        ssd = 7'b0010010;
      6: 
        ssd = 7'b0000010;
      7: 
        ssd = 7'b1111000;
      8: 
        ssd = 7'b0000000;
      9: 
        ssd = 7'b0011000;
      10: 
        ssd = 7'b0001000; // A
      11: 
        ssd = 7'b0000011; // b
      12: 
        ssd = 7'b1000110; // C
      13: 
        ssd = 7'b0100001; // d
      14: 
        ssd = 7'b0000110; // E
      15: 
        ssd = 7'b0001110; // F
      default: 
        ssd = 7'b1111111; // NO LIGHT
    endcase
  end
endmodule
