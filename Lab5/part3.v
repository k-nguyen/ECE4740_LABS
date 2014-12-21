module lab5_3 (input CLOCK_50, input [3:0] KEY, output [6:0] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);

  wire [25:0] perSEC;
  wire [31:0] perMIN;
  wire [37:0] perHR;

  wire [5:0] secs, mins;
  wire [4:0] hrs;

  reg sec, min, hr;

  assign HEX1 = 7'b1111111;
  assign HEX0 = 7'b1111111;

  modk_counter C0 (CLOCK_50, KEY[0], perSEC);
  defparam C0.n = 26;
  defparam C0.k = 50000000;

  modk_counter C1 (CLOCK_50, KEY[0], perMIN);
  defparam C1.n = 32;
  defparam C1.k = 3000000000;

  modk_counter C2 (CLOCK_50, KEY[0], perHR);
  defparam C2.n = 38;
  defparam C2.k = 180000000000;

  modk_counter C3 (sec, KEY[0], secs);
  defparam C3.n = 6;
  defparam C3.k = 60;

  modk_counter C4 (min, KEY[0], mins);
  defparam C4.n = 6;
  defparam C4.k = 60;

  modk_counter C5 (hr, KEY[0], hrs);
  defparam C5.n = 5;
  defparam C5.k = 24;

  always @ (negedge CLOCK_50) begin
    sec = (perSEC == 49999999)? 1:0;   
    min = (perMIN == 2999999999)? 1:0;
    hr = (perHR == 179999999999)? 1:0;
  end   
 
  ssd_2digits DHrs (hrs, HEX7, HEX6);
  ssd_2digits DMins (mins, HEX5, HEX4);
  ssd_2digits DSecs (secs, HEX3, HEX2);
  
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

module ssd_2digits (x, ssd1, ssd0);
  input [6:0] x;
  output [0:6] ssd1, ssd0;

  reg [3:0] ones, tens;

  always begin
    ones = x % 10;
    tens = (x - ones) / 10;
  end

  digital_ssd B1 (tens, ssd1);
  digital_ssd B0 (ones, ssd0);
endmodule

module digital_ssd (input [6:0] b, output reg [6:0] ssd);
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