module Lab1_5 (HEX0, HEX1, HEX2, HEX3, HEX4, SW);
	//part5 - rotating hello
	output[6:0] HEX0, HEX1, HEX2, HEX3, HEX4;
	input[17:0] SW;
	wire[14:0] m; 
	wire[6:0] ssd0, ssd1, ssd2, ssd3, ssd4;
	
	assign HEX0 = ssd0;
	assign HEX1 = ssd1;
	assign HEX2 = ssd2;
	assign HEX3 = ssd3;
	assign HEX4 = ssd4;
	
	
	decoder decSSD0(m[2:0], ssd0);
	decoder decSSD1(m[5:3], ssd1);
	decoder decSSD2(m[8:6], ssd2);
	decoder decSSD3(m[11:9], ssd3);
	decoder decSSD4(m[14:12], ssd4);
	
	mux5to1 myMux(SW[17:0], m); 
	
endmodule

module decoder_5(input[2:0] c, output reg[6:0] out);
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

module mux5to1_5(input[17:0] sw, output reg [14:0] m);
	//part 3 - 3bit wide, 5-to-1 mux	
	always@(*)
	
	//H 		(000) SW[2:0]
	//E 		(001) SW[5:3]
	//L 		(010) SW[8:6]
	//O 		(011) SW[11:9]
	//blank	(100) SW[14:12]
	
	begin
		case(sw[17:15])	//switch 15-17 for mux control
			0: m <= {sw[2:0], sw[5:3], sw[8:6], sw[8:6], sw[11:9]};	//HELLO
			1: m <= {sw[5:3], sw[8:6], sw[8:6], sw[11:9], sw[2:0]};	//ELLOH
			2: m <= {sw[8:6], sw[8:6], sw[11:9], sw[2:0], sw[5:3]};	//LLOHE
			3: m <= {sw[8:6], sw[11:9], sw[2:0], sw[5:3], sw[8:6]};	//LOHEL
			4: m <= {sw[11:9], sw[2:0], sw[5:3], sw[8:6], sw[8:6]};	//OHELL
			default m <= 15'b111_111_111_111_111;
		endcase
	end
endmodule