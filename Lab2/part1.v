module lab2_1 (input [17:0] SW, output [6:0] HEX0, HEX1, HEX2, HEX3);
   
	ssd B0 (SW[3:0], HEX0);
   ssd B1 (SW[7:4], HEX1);
   ssd B2 (SW[11:8], HEX2);
   ssd B3 (SW[15:12], HEX3);

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