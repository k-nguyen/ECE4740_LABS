module lab6_5 (input [17:0] SW, output [17:0] LEDR, output [6:0] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);

  wire [15:0] s;

  multiplier M (SW[15:8], SW[7:0], s);
  
  hex_ssd H7 (SW[15:12], HEX7);
  hex_ssd H6 (SW[11:8], HEX6);
  hex_ssd H5 (SW[7:4], HEX5);
  hex_ssd H4 (SW[3:0], HEX4);
  hex_ssd H3 (s[15:12], HEX3);
  hex_ssd H2 (s[11:8], HEX2);
  hex_ssd H1 (s[7:4], HEX1);
  hex_ssd H0 (s[3:0], HEX0);
endmodule

//8bx8b = 16b
module multiplier (input [7:0] A, B, output [15:0] P);
  
  wire [7:0] s01, s23, s45, s67, s03, s47;
  wire c0, c1, c2, c3, c4, c5;
  
  wire [7:0] s0, s1, s2, s3, s4, s5, s6, s7;

  assign s0 = A&{8{B[0]}};
  assign s1 = A&{8{B[1]}};
  assign s2 = A&{8{B[2]}};
  assign s3 = A&{8{B[3]}};
  assign s4 = A&{8{B[4]}};
  assign s5 = A&{8{B[5]}};
  assign s6 = A&{8{B[6]}};
  assign s7 = A&{8{B[7]}};
  
  //level 1
  adder A0 (s0, s1<<1, 0, s01, c0); //s0+s1 = s01
  defparam A0.n = 16;	
  adder A1 (s2<<2, s3<<3, 0, s23, c1);	//s2+s3 = s23
  defparam A1.n = 16;
  adder A2 (s4<<4, s5<<5, 0, s45, c2);	//s4+s5 = s45
  defparam A2.n = 16;
  adder A3 (s6<<6, s7<<7, 0, s67, c3);	//s6+s7 = s67
  defparam A0.n = 16;
  
  //level 2
  adder A4 (s01, s23, 0, s03, c4);  //s01+s23 = s03
  defparam A1.n = 16;
  adder A5 (s45, s67, 0, s47, c5); //s45+s67 = s47
  defparam A2.n = 16;
  
  //final level
  adder A6 (s03, s47, 0, P[14:0], P[15]);	//s03+s47 = P
  defparam A2.n = 16;
endmodule

module adder (input [n-1:0] A, B, input cin, output wire [n-1:0] sum, output wire carry);
	parameter n = 8;
	
	assign {carry, sum} = A+B+cin;
endmodule

module hex_ssd (input [3:0] b, output reg [6:0] hex);
  always begin
    case(b)
      0:hex=7'b1000000;
      1:hex=7'b1111001;
      2:hex=7'b0100100;
      3:hex=7'b0110000;
      4:hex=7'b0011001;
      5:hex=7'b0010010;
      6:hex=7'b0000010;
      7:hex=7'b1111000;
      8:hex=7'b0000000;
      9:hex=7'b0011000;
		10:hex=7'b0001000;
      11:hex=7'b0000011;
      12:hex=7'b1000110;
      13:hex=7'b0100001;
      14:hex=7'b0000110;
      15:hex=7'b0001110;
		default:hex=7'b1111111; 
    endcase
  end
endmodule
