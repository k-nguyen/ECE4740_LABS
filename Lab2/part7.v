module lab2 (input [5:0] SW, output [5:0] LEDR, output [6:0] HEX1, HEX0);
  
  reg [3:0] tens, ones;

  assign LEDR = SW;

  always begin
    if (SW[5:0] > 59) begin
      tens = 6;
      ones = SW[5:0] - 60;
    end else if (SW[5:0] > 49) begin
      tens = 5;
      ones = SW[5:0] - 50;
    end else if (SW[5:0] > 39) begin
      tens = 4;
      ones = SW[5:0] - 40;
    end else if (SW[5:0] > 29) begin
      tens = 3;
      ones = SW[5:0] - 30;
    end else if (SW[5:0] > 19) begin
      tens = 2;
      ones = SW[5:0] - 20;
    end else if (SW[5:0] > 9) begin
      tens = 1;
      ones = SW[5:0] - 10;
    end else begin
      tens = 0;
      ones = SW[5:0];
    end //if
  end //always

  ssd d1 (tens, HEX1);
  ssd d0 (ones, HEX0);

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
