module lab4_1 (input [3:0] SW, KEY, output [7:0] LEDG, output [6:0] HEX1, HEX0);

  wire [7:0] Q;
  wire [3:0] Q2;

  counter_8b c8 (SW[1], KEY[0], SW[0], Q);

  hex_ssd H0 (Q[3:0], HEX0);
  hex_ssd H1 (Q[7:4], HEX1);
 
  counter_4b c4 (SW[1], KEY[0], SW[0], Q2);
endmodule

module counter_4b (input e, Clk, reset, output [3:0] Q);
  wire [3:0] Qs;
  
  assign Q = Qs;

  t_ff T0 (e, Clk, reset, Qs[0]);
  t_ff T1 (e&Qs[0], Clk, reset, Qs[1]);
  t_ff T2 (e&Qs[1], Clk, reset, Qs[2]);
  t_ff T3 (e&Qs[2], Clk, reset, Qs[3]);
endmodule

module counter_8b (input e, Clk, reset, output[7:0] Q);
  wire [7:0] Qs;
  
  assign Q = Qs;
  
  t_ff T0 (e, Clk, reset, Qs[0]);
  t_ff T1 (e&Qs[0], Clk, reset, Qs[1]);
  t_ff T2 (e&Qs[1], Clk, reset, Qs[2]);
  t_ff T3 (e&Qs[2], Clk, reset, Qs[3]);
  t_ff T4 (e&Qs[3], Clk, reset, Qs[4]);
  t_ff T5 (e&Qs[4], Clk, reset, Qs[5]);
  t_ff T6 (e&Qs[5], Clk, reset, Qs[6]);
  t_ff T7 (e&Qs[6], Clk, reset, Qs[7]);
endmodule

module t_ff (input e, Clk, reset, output reg Q);
  always @ (posedge Clk)
    if (reset)
      Q = 0;
    else if (e)
      Q = ~Q;
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
