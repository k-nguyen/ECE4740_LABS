module lab2_6 (input [17:0] SW, output [8:0] LEDG, output [15:0] LEDR, output [6:0] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);

  assign LEDR[15:0] = SW[15:0];
  assign HEX3 = 7'b1111111;

  reg [4:0] t1, t0;
  reg [3:0] z1, z0, s2, s1, s0;
  reg c2, c1;

  always begin
    t0 = SW[3:0] + SW[11:8];
    z0 = (t0>9)? 10:0;
	 c1 = (t0>9)? 1:0;
    s0 = t0 - z0;

    t1 = SW[7:4] + SW[15:12] + c1;
    z1 = (t1>9)? 10:0;
	 c2 = (t1>9)? 1:0;
    s1 = t1 - z1;
    s2 = c2;
 end

  ssd (s0, HEX0);
  ssd (s1, HEX1);
  ssd (s2, HEX2);
  
  ssd (SW[15:12], HEX7);
  ssd (SW[11:8], HEX6);
  ssd (SW[7:4], HEX5);
  ssd (SW[3:0], HEX4);
  
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