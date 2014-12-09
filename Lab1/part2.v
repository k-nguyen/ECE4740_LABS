module Lab1_2 (input[17:0] SW, output[7:0] LEDG, output[17:0] LEDR, output reg [7:0] m);
	//part 2 - 8bit wide, 2-to-1 mux
	assign LEDR = SW;	
	assign LEDG = m;	//green leds displays mux output
	
	always@(*)
	begin
		case(SW[17])	//switch 17 for mux control
			0: m <= SW[7:0];	//output x if switch 17 is off
			1: m <= SW[15:8];	//output y if switch 17 is on 
			default m <= 8'b0000_0000;
		endcase
	end
endmodule
