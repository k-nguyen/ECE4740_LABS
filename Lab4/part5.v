module lab4_5 (input CLOCK_50, output [6:0] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
	
	wire [25:0] Q_clk;
	wire [15:0] Q_ssd;
	reg reset_clk, reset_ssd;
	
	wire[23:0] m; 
	
	initial begin
		reset_clk = 0;
		reset_ssd = 0;
	end
	
	lpm_counter_26b(CLOCK_50, 1, reset_clk, Q_clk);
	lab4_lpm_counter(reset_clk, 1, reset_ssd, Q_ssd);
	
	mux5to1 myMux(Q_ssd[3:0], m); 
	
	decoder decSSD0(m[2:0], HEX0);
	decoder decSSD1(m[5:3], HEX1);
	decoder decSSD2(m[8:6], HEX2);
	decoder decSSD3(m[11:9], HEX3);
	decoder decSSD4(m[14:12], HEX4);
	decoder decSSD5(m[17:15], HEX5);
	decoder decSSD6(m[20:18], HEX6);
	decoder decSSD7(m[23:21], HEX7);
	
	always @ (negedge CLOCK_50) begin
    reset_clk = (Q_clk >= 50000000)? 1:0;
	end
	
	always @ (negedge reset_clk) begin
    reset_ssd = (Q_ssd >= 7)? 1:0;
	end

endmodule

module mux5to1(input [3:0] s, output reg [23:0] m);
	//part 3 - 3bit wide, 5-to-1 mux	
	
	//H 		(000) SW[2:0]
	//E 		(001) SW[5:3]
	//L 		(010) SW[8:6]
	//O 		(011) SW[11:9]
	//blank	(100) SW[14:12]
	
	always begin
		case(s)	//switch 15-17 for mux control
			0: m <= {3'b100, 3'b100, 3'b100, 3'b000, 3'b001, 3'b010, 3'b010, 3'b011};	//___HELLO
			1: m <= {3'b100, 3'b100, 3'b000, 3'b001, 3'b010, 3'b010, 3'b011, 3'b100};	//__HELLO_
			2: m <= {3'b100, 3'b000, 3'b001, 3'b010, 3'b010, 3'b011, 3'b100, 3'b100};	//_HELLO__
			3: m <= {3'b000, 3'b001, 3'b010, 3'b010, 3'b011, 3'b100, 3'b100, 3'b100};	//HELLO___
			4: m <= {3'b001, 3'b010, 3'b010, 3'b011, 3'b100, 3'b100, 3'b100, 3'b000};	//ELLO___H
			5: m <= {3'b010, 3'b010, 3'b011, 3'b100, 3'b100, 3'b100, 3'b000, 3'b001};	//LLO___HE
			6: m <= {3'b010, 3'b011, 3'b100, 3'b100, 3'b100, 3'b000, 3'b001, 3'b010};	//LO___HEL
			7: m <= {3'b011, 3'b100, 3'b100, 3'b100, 3'b000, 3'b001, 3'b010, 3'b010};	//O___HELL
			default m <= 23'b111_111_111_111_111_111_111_111;
		endcase
	end
endmodule

module decoder(input[2:0] c, output reg[6:0] out);
	always begin 
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