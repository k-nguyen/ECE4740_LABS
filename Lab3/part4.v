module lab3_4 (input [1:0] SW, output [2:0] LEDR, LEDG);
  assign LEDR[1:0] = SW[1:0];
 
  wire Q;

  D_Latch DL (SW[1], SW[0], LEDG[0]);
  ff ff0 (SW[1], SW[0], LEDG[1]);
  ff ff1 (~SW[1], SW[0], LEDG[2]);
endmodule

module D_Latch (input Clk, D, output reg Q);
  always @ (D, Clk)
    if(Clk)
		Q = D;
endmodule

module ff (input Clk, D, output Q);
  wire Qm;
  
  D_Latch DL0 (~Clk, D, Qm);
  D_Latch DL1 (Clk, Qm, Q);
endmodule
