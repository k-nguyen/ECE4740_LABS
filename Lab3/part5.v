module lab3_5 (SW, HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0, KEY);
  input [3:0] KEY;
  input [17:0] SW;
  output [0:6] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
  
  reg [15:0] R;
  wire [15:0] Q;

  ff ff0 (~KEY[1], SW[0], ~KEY[0], Q[0]);
  ff ff1 (~KEY[1], SW[1], ~KEY[0], Q[1]);
  ff ff2 (~KEY[1], SW[2], ~KEY[0], Q[2]);
  ff ff3 (~KEY[1], SW[3], ~KEY[0], Q[3]);
  ff ff4 (~KEY[1], SW[4], ~KEY[0], Q[4]);
  ff ff5 (~KEY[1], SW[5], ~KEY[0], Q[5]);
  ff ff6 (~KEY[1], SW[6], ~KEY[0], Q[6]);
  ff ff7 (~KEY[1], SW[7], ~KEY[0], Q[7]);
  ff ff8 (~KEY[1], SW[8], ~KEY[0], Q[8]);
  ff ff9 (~KEY[1], SW[9], ~KEY[0], Q[9]);
  ff ff10 (~KEY[1], SW[10], ~KEY[0], Q[10]);
  ff ff11 (~KEY[1], SW[11], ~KEY[0], Q[11]);
  ff ff12 (~KEY[1], SW[12], ~KEY[0], Q[12]);
  ff ff13 (~KEY[1], SW[13], ~KEY[0], Q[13]);
  ff ff14 (~KEY[1], SW[14], ~KEY[0], Q[14]);
  ff ff15 (~KEY[1], SW[15], ~KEY[0], Q[15]);

  ssd H0 (SW[3:0], HEX0);
  ssd H1 (SW[7:4], HEX1);
  ssd H2 (SW[11:8], HEX2);
  ssd H3 (SW[15:12], HEX3);
  ssd H4 (R[3:0], HEX4);
  ssd H5 (R[7:4], HEX5);
  ssd H6 (R[11:8], HEX6);
  ssd H7 (R[15:12], HEX7);
  
  always
    R = Q;

endmodule

module D_Latch (input Clk, D, reset, output reg Q);
  always @ (D, Clk, reset)
      if (reset)
			Q = 0;
		else if(Clk)
			Q = D;
		
endmodule

module ff (input Clk, D, reset, output Q);
  wire Qm;
  
  D_Latch DL0 (~Clk, D, reset, Qm);
  D_Latch DL1 (Clk, Qm, reset, Q);
endmodule

module ssd (input [15:0] b, output reg [6:0] hex);
  always begin
    case(b)
      0:SSD=7'b1000000;
      1:SSD=7'b1111001;
      2:SSD=7'b0100100;
      3:SSD=7'b0110000;
      4:SSD=7'b0011001;
      5:SSD=7'b0010010;
      6:SSD=7'b0000010;
      7:SSD=7'b1111000;
      8:SSD=7'b0000000;
      9:SSD=7'b0011000;
      10:ssd=7'b0001000;
      11:ssd=7'b0000011;
      12:ssd=7'b1000110;
      13:ssd=7'b0100001;
      14:ssd=7'b0000110;
      15:ssd=7'b0001110;
		default:hex=7'b1111111; 
    endcase
  end
endmodule
