module lab2_2(input [17:0] SW, output [6:0] HEX0, HEX1, HEX2, HEX3);

  wire z;
  wire [3:0] m, aOut;
  assign A[3] = 0;

  comparator C (SW[3:0], z);
  cctA A (SW[3:0], aOut[2:0]);
  mux M (z, SW[3:0], aOut, m);
  cctB B (z, HEX1);
  ssd S (m, HEX0);
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

module cctA (input [2:0] v, output [2:0] a);
  assign a[0] = v[0];
  assign a[1] = ~v[1];
  assign a[2] = (v[2] & v[1]);
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