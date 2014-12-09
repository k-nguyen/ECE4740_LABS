module Lab1_4 (output[6:0] HEX0, input[17:0] SW);
	//part4 - seven segment (characters)
	reg[6:0] out;
	
	assign HEX0 = out;
	
	always@(*)
	begin 
		case(SW[2:0])
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