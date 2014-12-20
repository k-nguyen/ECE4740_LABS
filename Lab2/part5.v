module lab2_5 (input [17:0] SW, output [8:0] LEDG, output[17:0] LEDR, output [6:0] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);

  wire z2, z3, z4, z5;
  wire c1, c2, c3, c4, c5, c6;
  wire [4:0] s0, s1;
  wire z0, z1;
  wire [3:0] a0, m0, a1, m1;
 
  assign LEDR[15:0] = SW[15:0];
  assign HEX3 = 7'b1111111;
  assign LEDG[8] = z2 | z3 | z4 | z5;
  assign LEDG[3:0] = s0[3:0];  
  assign LEDG[7:4] = s1[3:0];
  
  ssd (SW[15:12], HEX7);
  ssd (SW[11:8], HEX6);
  ssd (SW[7:4], HEX5);
  ssd (SW[3:0], HEX4);
  
  comparator cmp1 (SW[3:0], z2);
  comparator cmp2 (SW[7:4], z3);
  comparator cmp3 (SW[11:8], z4);
  comparator cmp4 (SW[15:12], z5);

  fulladder fa1 (SW[0], SW[8], 0, s0[0], c1);
  fulladder fa2 (SW[1], SW[9], c1, s0[1], c2);
  fulladder fa3 (SW[2], SW[10], c2, s0[2], c3);
  fulladder fa4 (SW[3], SW[11], c3, s0[3], s0[4]);

  comparatorC cmpC0 (s0[4:0], z0);
  cctA A0 (s0[3:0], a0);
  mux M0 (z0, s0[3:0], a0, m0);
  ssd bcd0 (m0, HEX0);

  fulladder fa5 (SW[4], SW[12], z0, s1[0], c4);
  fulladder fa6 (SW[5], SW[13], c4, s1[1], c5);
  fulladder fa7 (SW[6], SW[14], c5, s1[2], c6);
  fulladder fa8 (SW[7], SW[15], c6, s1[3], s1[4]);

  comparatorC cmpC1 (s1[4:0], z1);
  cctA A1 (s1[3:0], a1);
  mux M1 (z1, s1[3:0], a1, m1);
  cctB B1 (z1, HEX2);
  ssd bcd1 (m1, HEX1);

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