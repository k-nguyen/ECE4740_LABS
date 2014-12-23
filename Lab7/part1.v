module lab7_1 (input [17:0] SW, input [3:0] KEY, output [17:0] LEDR, output [8:0] LEDG);
  
  wire [8:0] D, z;
  wire w;

  assign LEDG = z;
  assign LEDR[8:0] = D;
  
  assign w = SW[1];

  assign D[0] = ~(~(~z[0] | z[1] | z[2] | z[3] | z[4] | z[5] | z[6] | z[7] | z[8]) 
												| ~(D[1] | D[2] | D[3] | D[4] | D[5] | D[6] | D[7] | D[8])); //A
  assign D[1] = (~z[0] | z[5] | z[6] | z[7] | z[8]) & ~w; // B
  assign D[2] = z[1] & ~w; // C
  assign D[3] = z[2] & ~w; // D
  assign D[4] = (z[3] | z[4]) & ~w; // E
  assign D[5] = (~z[0] | z[1] | z[2] | z[3] | z[4]) & w; // F
  assign D[6] = z[5] & w; // G
  assign D[7] = z[6] & w; // H
  assign D[8] = (z[7] | z[8]) & w; // I

  ff_8b FF (~KEY[1], KEY[0], D[8:0], z[8:0]);

endmodule

module ff_8b (input Clk, reset, input [8:0] D, output reg [8:0] Q);

	always @ (negedge Clk or negedge reset) begin
		if(reset == 0)
			Q <= 0;
		else if (Clk == 0)
			Q <= D;
	end
endmodule


