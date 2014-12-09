module Lab1_3 (input[17:0] SW, output[7:0] LEDG, output[17:0] LEDR, output reg [2:0] m);
	//part 3 - 3bit wide, 5-to-1 mux
	assign LEDR = SW;	
	assign LEDG[2:0] = m;	//green leds displays mux output
	
	always@(*)
	begin
		case(SW[17:15])	//switch 15-17 for mux control
			0: m <= SW[2:0];	//output u 
			1: m <= SW[5:3];	//output v   
			2: m <= SW[8:6];	//output w
			3: m <= SW[11:9];	//output x
			4: m <= SW[14:12];	//output y
			default m <= 3'b000;
		endcase
	end


endmodule
