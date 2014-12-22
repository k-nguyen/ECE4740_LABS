module lab6_3 (input [17:0] SW, output [6:0] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);

  wire [7:0] s;
  
  assign HEX7 = 7'b1111111;
  assign HEX5 = 7'b1111111;
  assign HEX3 = 7'b1111111;
  assign HEX2 = 7'b1111111;

  multiplier M (SW[11:8], SW[3:0], s);
  
  hex_ssd H6 (SW[11:8], HEX6);
  hex_ssd H4 (SW[3:0], HEX4);
  hex_ssd H1 (s[7:4], HEX1);
  hex_ssd H0 (s[3:0], HEX0);
endmodule

//4bx4b = 8b
module multiplier (input [3:0] A, B, output [7:0] P);
  wire [7:0] s01, s02;
  wire c0, c1;
  
  wire [7:0] s0, s1, s2, s3;

  assign s0 = A&{B[0],B[0],B[0],B[0]};
  assign s1 = A&{B[1],B[1],B[1],B[1]};
  assign s2 = A&{B[2],B[2],B[2],B[2]};
  assign s3 = A&{B[3],B[3],B[3],B[3]};
  
  adder A0 (s0, s1<<1, 0, s01, c0);
  defparam A0.n = 7;
  adder A1 (s01, s2<<2, c0, s02, c1);
  defparam A1.n = 7;
  adder A2 (s02, s3<<3, c1, P[6:0], P[7]);
  defparam A2.n = 7;
  
endmodule

module adder (input [n-1:0] A, B, input cin, output wire [n-1:0] sum, output wire carry);
	parameter n = 4;
	
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
