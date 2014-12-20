module lab3_2 (input [1:0] SW, output [1:0] LEDR, LEDG);

  assign LEDR = SW;
  
  wire Q;

  D_Latch D0 (SW[0], SW[1], LEDG[0]);
  
endmodule

module D_Latch (input Clk, D, output Q);
  wire S, R;
  wire R_g, S_g, Qa, Qb /* synthesis keep */ ;
  
  assign S = D;
  assign R = ~D;
  assign R_g = R & Clk;
  assign S_g = S & Clk;
  assign Qa = ~(R_g | Qb);
  assign Qb = ~(S_g | Qa);
  assign Q = Qa;
endmodule
