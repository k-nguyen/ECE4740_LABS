module lab8_7 (CLOCK_50, SW, LEDG, KEY, HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0, SRAM_ADDR, SRAM_DQ, SRAM_CE_N, SRAM_OE_N, SRAM_WE_N, SRAM_UB_N, SRAM_LB_N);
  input CLOCK_50;
  input [17:0] SW;
  input [3:0] KEY;
  output [8:0] LEDG;
  output [6:0] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;

  output [17:0] SRAM_ADDR;
  inout [15:0] SRAM_DQ;
  output SRAM_CE_N;
  output SRAM_OE_N;
  output SRAM_WE_N;
  output SRAM_UB_N;
  output SRAM_LB_N;
  
  wire [7:0] data;
  wire [7:0] q;
  wire [4:0] addr;
  wire w, clk;
  
  assign SRAM_ADDR[17:5] = 13'b0000000000000;
  assign SRAM_DQ[15:8] = 8'b00000000;
  assign SRAM_CE_N = 0;
  assign SRAM_OE_N = 0;
  assign SRAM_UB_N = 0;
  assign SRAM_LB_N = 0;

  assign SRAM_WE_N = ~w;
  assign SRAM_DQ[7:0] = w ? data : 8'bZ ;
  assign q = SRAM_DQ[7:0];
  assign SRAM_ADDR = muxaddr;
  
  assign data = SW[7:0];
  assign w = SW[17];
  assign clk = KEY[0];
  assign addr = SW[15:11];
  
  assign LEDG[0] = w;
  
  wire [4:0] raddr;
  wire [25:0] trigger;
  modk_counter C0 (CLOCK_50, clk, trigger);
  defparam C0.n = 26;
  defparam C0.k = 50000000;

  modk_counter C1 (trigger[25], clk, raddr);
  defparam C1.n = 5;
  defparam C1.k = 32;

  reg [4:0] muxaddr;
  always @(muxaddr, addr, raddr, w) begin
    if (w)
      muxaddr <= addr;
    else
      muxaddr <= raddr;
  end

  hex_ssd H7 (addr[4], HEX7);
  hex_ssd H6 (addr[3:0], HEX6);
  hex_ssd H5 (data[7:4], HEX5);
  hex_ssd H4 (data[3:0], HEX4);
  hex_ssd H3 (raddr[4], HEX3);
  hex_ssd H2 (raddr[3:0], HEX2);
  hex_ssd H1 (q[7:4], HEX1);
  hex_ssd H0 (q[3:0], HEX0);
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
