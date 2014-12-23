module lab8_1 (input [17:0] SW, output [17:0] LEDR);
  
  wire [7:0] data, q;
  wire [4:0] addr; //32 8bit words
  wire w, clk;

  assign data = SW[7:0];
  assign w = SW[8];
  assign clk = SW[9];
  assign addr = SW[14:10];
  assign LEDR[7:0] = q;

  ramlpm ram (addr, clk, data, w, q);

endmodule