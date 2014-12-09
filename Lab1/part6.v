module Lab1_6 (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,  SW);
	//part6 - rotating hello with blanks
	output[6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
	input[17:0] SW;
	wire[23:0] m; 
	wire[6:0] ssd0, ssd1, ssd2, ssd3, ssd4, ssd5, ssd6, ssd7;
	
	assign HEX0 = ssd0;
	assign HEX1 = ssd1;
	assign HEX2 = ssd2;
	assign HEX3 = ssd3;
	assign HEX4 = ssd4;
	assign HEX5 = ssd5;
	assign HEX6 = ssd6;
	assign HEX7 = ssd7;
	
	decoder decSSD0(m[2:0], ssd0);
	decoder decSSD1(m[5:3], ssd1);
	decoder decSSD2(m[8:6], ssd2);
	decoder decSSD3(m[11:9], ssd3);
	decoder decSSD4(m[14:12], ssd4);
	decoder decSSD5(m[17:15], ssd5);
	decoder decSSD6(m[20:18], ssd6);
	decoder decSSD7(m[23:21], ssd7);
	
	mux5to1 myMux(SW[17:0], m); 
	
endmodule

module decoder(input[2:0] c, output reg[6:0] out);
	always@(*)
	begin 
		case(c)
			0: out<=7'b0001001;	//H
			1: out<=7'b0000110;	//E
			2: out<=7'b1000111;	//L
			3: out<=7'b1000000;	//0
			4: out<=7'b1111111;	//blank
			5: out<=7'b1111111;
			6: out<=7'b1111111;
			7: out<=7'b1111111;
			default: out<=7'b0000000;
		endcase
	end
endmodule

module mux5to1(input[17:0] sw, output reg [23:0] m);
	//part 3 - 3bit wide, 5-to-1 mux	
	always@(*)
	
	//H 		(000) SW[2:0]
	//E 		(001) SW[5:3]
	//L 		(010) SW[8:6]
	//O 		(011) SW[11:9]
	//blank	(100) SW[14:12]
	
	begin
		case(sw[17:15])	//switch 15-17 for mux control
			0: m <= {sw[14:12], sw[14:12], sw[14:12], sw[2:0], sw[5:3], sw[8:6], sw[8:6], sw[11:9]};	//___HELLO
			1: m <= {sw[14:12], sw[14:12], sw[2:0], sw[5:3], sw[8:6], sw[8:6], sw[11:9], sw[14:12]};	//__HELLO_
			2: m <= {sw[14:12], sw[2:0], sw[5:3], sw[8:6], sw[8:6], sw[11:9], sw[14:12], sw[14:12]};	//_HELLO__
			3: m <= {sw[2:0], sw[5:3], sw[8:6], sw[8:6], sw[11:9], sw[14:12], sw[14:12], sw[14:12]};	//HELLO___
			4: m <= {sw[5:3], sw[8:6], sw[8:6], sw[11:9], sw[14:12], sw[14:12], sw[14:12], sw[2:0]};	//ELLO___H
			5: m <= {sw[8:6], sw[8:6], sw[11:9], sw[14:12], sw[14:12], sw[14:12], sw[2:0], sw[5:3]};	//LLO___HE
			6: m <= {sw[8:6], sw[11:9], sw[14:12], sw[14:12], sw[14:12], sw[2:0], sw[5:3], sw[8:6]};	//LO___HEL
			7: m <= {sw[11:9], sw[14:12], sw[14:12], sw[14:12], sw[2:0], sw[5:3], sw[8:6], sw[8:6]};	//O___HELL
			default m <= 23'b111_111_111_111_111_111_111_111;
		endcase
	end
endmodule