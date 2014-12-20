module lab3_3 (input [1:0] SW, output [1:0] LEDR, LEDG);
  assign LEDR = SW;
  
  wire Q;

  ff F0 (SW[1], SW[0], LEDG[0]);
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

module ff (input Clk, D, output Q);
  wire Qm;
  
  D_Latch DL0 (~Clk, D, Qm);
  D_Latch DL1 (Clk, Qm, Q);
endmodule
