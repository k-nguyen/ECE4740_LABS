module lab2_3 (input [17:0] SW, output [8:0] LEDG, LEDR);

  assign LEDR[8:0] = SW[8:0];

  wire c1, c2, c3;

  fulladder fa1 (SW[0], SW[4], SW[8], LEDG[0], c1);
  fulladder fa2 (SW[1], SW[5], c1, LEDG[1], c2);
  fulladder fa3 (SW[2], SW[6], c2, LEDG[2], c3);
  fulladder fa4 (SW[3], SW[7], c3, LEDG[3], LEDG[4]);
endmodule

module fulladder (a, b, cIn, s, cOut);
  input a, b, cIn;
  output cOut, s;

  wire d;

  assign d = a ^ b;
  assign s = d ^ cIn;
  assign cOut = (b & ~d) | (d & cIn);
endmodule
