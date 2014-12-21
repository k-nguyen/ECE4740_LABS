module lab5_2 (input CLOCK_50, input [3:0] KEY, output [6:0] HEX2, HEX1, HEX0);
	
  wire [25:0] cycles;
  wire [3:0] out1s, out10s, out100s;
  reg ones, tens, hundreds;

  modk_counter C0 (CLOCK_50, KEY[0], cycles);
  defparam C0.n = 26;
  defparam C0.k = 50000000;

  modk_counter C1 (ones, KEY[0], out1s);
  defparam C1.n = 4;
  defparam C1.k = 11;

  modk_counter C2 (tens, KEY[0], out10s);
  defparam C2.n = 4;
  defparam C2.k = 11;

  modk_counter C3 (hundreds, KEY[0], out100s);
  defparam C3.n = 4;
  defparam C3.k = 10;

  always @ (negedge CLOCK_50) begin
    ones = (cycles == 49999999)? 1:0;
	 tens = (out1s == 10)? 1:0;
    hundreds = (out10s == 10)? 1:0;
  end

  dig_ssd H0 (out1s, HEX0);
  dig_ssd H1 (out10s, HEX1);
  dig_ssd H2 (out100s, HEX2);
	
endmodule

module modk_counter(input clk, reset_n, output reg [n-1:0] Q);
  parameter n = 8;
  parameter k = 256;
 
  always @(posedge clk or negedge reset_n)
  begin
    if (~reset_n)
      Q <= 'd0;
    else begin
      Q <= Q + 1'b1;
      if (Q == k-1)
        Q <= 'd0;
    end
  end
endmodule

module dig_ssd (input [3:0] b, output reg [6:0] ssd);
  always begin
    case(b)
      0:ssd=7'b1000000;
      1:ssd=7'b1111001;
      2:ssd=7'b0100100;
      3:ssd=7'b0110000;
      4:ssd=7'b0011001;
      5:ssd=7'b0010010;
      6:ssd=7'b0000010;
      7:ssd=7'b1111000;
      8:ssd=7'b0000000;
      9:ssd=7'b0011000;
		default:ssd=7'b1111111; 
    endcase
  end
endmodule