module lab2_4 (input [17:0] SW, output [8:0] LEDR, LEDG, output [6:0] HEX1, HEX0, HEX4, HEX6);

  wire z1, z2;
  wire c1, c2, c3;
  wire [4:0] s;
  wire z;
  wire [3:0] m, aOut;

  assign LEDR[8:0] = SW[8:0];
  assign LEDG[8] = z1 | z2;
  assign LEDG[4:0] = s[4:0];

  comparator cmp1 (SW[3:0], z1);
  comparator cmp2 (SW[7:4], z2);

  fulladder fa1 (SW[0], SW[4], SW[8], s[0], c1);
  fulladder fa2 (SW[1], SW[5], c1, s[1], c2);
  fulladder fa3 (SW[2], SW[6], c2, s[2], c3);
  fulladder fa4 (SW[3], SW[7], c3, s[3], s[4]);

  comparatorC cmpC (s[4:0], z);
  cctA A (s[3:0], aOut);
  mux M (z, s[3:0], aOut, m);
  cctB B (z, HEX1);
  ssd bcd (m, HEX0);
  
  ssd aSSD (SW[3:0], HEX4);
  ssd bSSD (SW[7:4], HEX6);
  
endmodule

module fulladder (a, b, cIn, s, cOut);
  input a, b, cIn;
  output cOut, s;

  wire d;

  assign d = a ^ b;
  assign s = d ^ cIn;
  assign cOut = (b & ~d) | (d & cIn);
endmodule

module ssd (input [3:0] b, output [6:0] seg);
	 assign seg[0] = ((~b[3] & ~b[2] & ~b[1] &  b[0]) | (~b[3] &  b[2] & ~b[1] & ~b[0]));
	 assign seg[1] = ((~b[3] &  b[2] & ~b[1] &  b[0]) | (~b[3] &  b[2] &  b[1] & ~b[0]));
	 assign seg[2] =  (~b[3] & ~b[2] &  b[1] & ~b[0]);
	 assign seg[3] = ((~b[3] & ~b[2] & ~b[1] &  b[0]) | (~b[3] &  b[2] & ~b[1] & ~b[0]) | (~b[3] &  b[2] & b[1] & b[0]) | (b[3] & ~b[2] & ~b[1] & b[0]));
	 assign seg[4] = ~((~b[2] & ~b[0]) | (b[1] & ~b[0]));
	 assign seg[5] = ((~b[3] & ~b[2] & ~b[1] &  b[0]) | (~b[3] & ~b[2] &  b[1] & ~b[0]) | (~b[3] & ~b[2] & b[1] & b[0]) | (~b[3] & b[2] & b[1] & b[0]));
	 assign seg[6] = ((~b[3] & ~b[2] & ~b[1] &  b[0]) | (~b[3] & ~b[2] & ~b[1] & ~b[0]) | (~b[3] &  b[2] & b[1] & b[0]));

endmodule

module comparator (input [3:0] v, output z);
  assign z = (v[3] & (v[2] | v[1]));
endmodule

module cctA (input [3:0] v, output [3:0] a);
  assign a[0] = v[0];
  assign a[1] = ~v[1];
  assign a[2] = (~v[3] & ~v[1]) | (v[2] & v[1]);
  assign a[3] = (~v[3] & v[1]);
endmodule

module cctB (input z, output [6:0]ssd);
  assign ssd[6] = 1;
  assign ssd[5:4] = 2'b00;
  assign ssd[3:1] = {3{z}};
  assign ssd[0] = z;
endmodule

module mux (s, u, v, m);
  // if ~s, send U
  input s;
  input [3:0] u, v;
  output [3:0] m;

  assign m = ({4{~s}} & u) | ({4{s}} & v);
endmodule

module comparatorC (input [4:0] v, output z);
  assign z = v[4] | ((v[3] & v[2]) | (v[3] & v[1]));
endmodule