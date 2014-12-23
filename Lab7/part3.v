module lab7_3 (input [17:0] SW, input [3:0] KEY, output [17:0] LEDR, output [8:0] LEDG);
  
  wire w, Clk;
  wire [3:0] s0Q, s1Q;
  reg z;
  
  assign w = SW[1];
  assign Clk = KEY[0];
  assign LEDR[3:0] = s1Q;
  assign LEDG[0] = z;
  
  assign s0Clk = (~s0Q[3] | ~w) & ~Clk;
  assign s1Clk = (~s1Q[3] | w) & ~Clk;

  assign s0Clr = ~w;
  assign s1Clr = w;

  assign s0In = ~(s0Q[3] | s0Q[2] | s0Q[1] | s0Q[0]) & w;
  assign s1In = ~(s1Q[3] | s1Q[2] | s1Q[1] | s1Q[0]) & ~w;
  
  lpm_4b_shiftreg SR0 (s0Clk, s0Clr, s0In, s0Q);
  lpm_4b_shiftreg SR1 (s1Clk, s1Clr, s1In, s1Q);

  always 
  begin: zset
    z = (s0Q[3] == 1 | s1Q[3] == 1)? 1:0;
  end

endmodule
