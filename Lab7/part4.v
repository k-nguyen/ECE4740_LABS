module lab7_4 (input CLOCK_50, input [17:0] SW, input [3:0] KEY, output [17:0] LEDR);
	
	reg [25:0] count;	
	reg [2:0] length;	//morse code length  (from 1-4)
	reg [2:0] counter; //morse code length counter 
	reg [3:0] M; //morse code, 1 = dash, 0 = dot
	reg [3:0] Q; //pattern, Q[3] is the input to the FSM
	reg z;	

   assign LEDR = z;
	
	reg[2:0] y_Q, Y_D;	//y_Q represents current state, Y_D represents next state
	parameter AA = 3'b000, BB = 3'b001, CC = 3'b010, DD = 3'b011, EE = 3'b100, FF = 3'b101, GG = 3'b110, HH = 3'b111;
	parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100; //states
	//letter_selection
	always @(SW) 
	begin: letter_selection
		case(SW[2:0])
			AA: begin length = 3'b010; M = 4'b0100; end // A    o- 
			BB: begin length = 3'b100; M = 4'b1000; end // B    -ooo 
			CC: begin length = 3'b100; M = 4'b1010; end // C    -o-o
			DD: begin length = 3'b011; M = 4'b1000; end // D    -oo 
			EE: begin length = 3'b001; M = 4'b0000; end // E    o 
			FF: begin length = 3'b100; M = 4'b0010; end // F    oo-o  
			GG: begin length = 3'b011; M = 4'b1100; end // G    --o 
			HH: begin length = 3'b100; M = 4'b0000; end // H    oooo 
		endcase
	end	
	
	//State Table
	always @(Q[3], KEY[1:0], counter, y_Q) 
													
	begin: state_table
		case (y_Q)
			// State A = Idle State 
			A: Y_D = (!KEY[1])? B:A; 	
			// State B => State Selection State  
			B: Y_D = (!Q[3])? E:C; 	// if next Symbol is 0, go to state E (outputs 0.5sec)
											// if next Symbol is 1, go to state C (outputs 1.5sec)
			// B -> C -> D -> => 1.5 seconds => dash 
			C: Y_D = (!KEY[0])? A:D; 	
			D: Y_D = (!KEY[0]) ? A:E;  
			// B -> E 			 => 0.5 seconds => dot 
			E: Y_D = (counter == 0)? A:B; 
		default: Y_D = 3'bxxx; 
		endcase
	end	
	
	always @(posedge CLOCK_50)
	begin
		if (count < 50000000/2) // at every 0.5 seconds, activate  
			count <= count + 1;
		else
		begin
			count <= 0;
			y_Q <= Y_D; // go to next state 
			if (Y_D == A) begin //update counter and length when next state is A
				counter <= length;
				Q <= M;
			end
			if (Y_D == E) begin    // deduct counter when next state is D and shift pattern
				counter <= counter - 1; 
				Q[3] <= Q[2];
				Q[2] <= Q[1]; 
				Q[1] <= Q[0];
				Q[0] <= 1'b0;
			end
		end
	end
	
	// LED output based on current state 
	always @(y_Q)
	begin: zassign
		case (y_Q) // turn on output for States B,C,D
			B: z = 1;   
			C: z = 1;  
			D: z = 1;  
			default: z = 0; // off output at States E or A 
		endcase
	end
endmodule 