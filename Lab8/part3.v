  module lab8_3 (input [17:0] SW, input [3:0] KEY, output [8:0] LEDG, output [6:0] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
  
  wire [7:0] data;
  wire [4:0] addr; //32 8bit words
  wire w, clk;
  reg [7:0] q;

  assign data = SW[7:0];
  assign w = SW[17];
  assign clk = KEY[0];
  assign addr = SW[15:11];
  
  assign LEDG[0] = w;
  
  assign HEX3 = 7'b1111111;
  assign HEX2 = 7'b1111111;
  
  hex_ssd H7 (addr[4], HEX7);
  hex_ssd H6 (addr[3:0], HEX6);
  hex_ssd H5 (data[7:4], HEX5);
  hex_ssd H4 (data[3:0], HEX4);
  hex_ssd H1 (q[7:4], HEX1);
  hex_ssd H0 (q[3:0], HEX0);
  
  reg [7:0] memory_array [31:0];
  always @(posedge clk) begin
    if (w)
      memory_array[addr] <= data;
    q <= memory_array[addr];
  end

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
