module lab5_1 (input [1:0] KEY, output [17:0] LEDR);
 
  modk_counter c (KEY[1], KEY[0], LEDR[7:0]);
  defparam c.n = 8;
  defparam c.k = 17;
  
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

