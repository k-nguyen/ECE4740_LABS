module lab6_1 (input [17:0] SW, input [3:0] KEY, output [17:0] LEDR);
	
	reg [7:0] A, B;
	wire [7:0] S, Q;
	
	assign LEDR[7:0] = Q;
	
	adder add_8b(SW[7:0], Q, 0, S, LEDR[8]);
	defparam add_8b.n = 8; //8bit adder
	
	D_Latch ff0 (KEY[1], S[0], KEY[0], Q[0]);
	D_Latch ff1 (KEY[1], S[1], KEY[0], Q[1]);
	D_Latch ff2 (KEY[1], S[2], KEY[0], Q[2]);
	D_Latch ff3 (KEY[1], S[3], KEY[0], Q[3]);
	D_Latch ff4 (KEY[1], S[4], KEY[0], Q[4]);
	D_Latch ff5 (KEY[1], S[5], KEY[0], Q[5]);
	D_Latch ff6 (KEY[1], S[6], KEY[0], Q[6]);
	D_Latch ff7 (KEY[1], S[7], KEY[0], Q[7]);
	
	always @ (negedge KEY[0]) begin
    if (KEY[0] == 0) begin
      A = 8'b00000000;
      B = 8'b00000000;
    end
	end
	
endmodule

module adder (input [n-1:0] A, B, input cin, output wire [n-1:0] sum, output wire carry);
	parameter n = 8;
	
	assign {carry, sum} = A+B+cin;
endmodule

module D_Latch (input Clk, D, reset, output reg Q);
  always @ (negedge Clk or negedge reset)
      if (reset == 0)
			Q = 0;
		else if(Clk == 0)
			Q = D;
endmodule
