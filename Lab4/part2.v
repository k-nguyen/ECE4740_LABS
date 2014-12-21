module lab4_2 (input [3:0] SW, KEY, output [7:0] LEDG, output [6:0] HEX3, HEX2, HEX1, HEX0);

  wire [15:0] Q;

  counter_16b c (SW[1], KEY[0], SW[0], Q);

  hex_ssd H0 (Q[3:0], HEX0);
  hex_ssd H1 (Q[7:4], HEX1);
  hex_ssd H2 (Q[11:8], HEX2);
  hex_ssd H3 (Q[15:12], HEX3);

 endmodule

module counter_16b (input e, Clk, reset, output[15:0] Q);
  wire [15:0] Qs;
  
  assign Q = Qs;
  
  t_ff T0 (e, Clk, reset, Qs[0]);
  t_ff T1 (e&Qs[0], Clk, reset, Qs[1]);
  t_ff T2 (e&Qs[1], Clk, reset, Qs[2]);
  t_ff T3 (e&Qs[2], Clk, reset, Qs[3]);
  t_ff T4 (e&Qs[3], Clk, reset, Qs[4]);
  t_ff T5 (e&Qs[4], Clk, reset, Qs[5]);
  t_ff T6 (e&Qs[5], Clk, reset, Qs[6]);
  t_ff T7 (e&Qs[6], Clk, reset, Qs[7]);
  t_ff T8 (e&Qs[7], Clk, reset, Qs[8]);
  t_ff T9 (e&Qs[8], Clk, reset, Qs[9]);
  t_ff T10 (e&Qs[9], Clk, reset, Qs[10]);
  t_ff T11 (e&Qs[10], Clk, reset, Qs[11]);
  t_ff T12 (e&Qs[11], Clk, reset, Qs[12]);
  t_ff T13 (e&Qs[12], Clk, reset, Qs[13]);
  t_ff T14 (e&Qs[13], Clk, reset, Qs[14]);
  t_ff T15 (e&Qs[14], Clk, reset, Qs[15]);
endmodule

module t_ff (input e, Clk, reset, output reg Q);
  always @ (posedge Clk)
    if (reset)
      Q = 0;
    else if (e)
      Q <= Q + 1;
endmodule

module hex_ssd (input [3:0] b, output reg [6:0] ssd);
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
		10:ssd=7'b0001000;
      11:ssd=7'b0000011;
      12:ssd=7'b1000110;
      13:ssd=7'b0100001;
      14:ssd=7'b0000110;
      15:ssd=7'b0001110;
		default:ssd=7'b1111111; 
    endcase
  end
endmodule
