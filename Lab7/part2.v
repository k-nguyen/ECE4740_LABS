module lab7_2 (input [17:0] SW, input [3:0] KEY, output [17:0] LEDR, output [8:0] LEDG);

  wire w, Clk;
  reg z;
  
  assign w = SW[1];

  assign Clk = KEY[0];
  
  //assign LEDG[3:0] = y_Q;
  assign LEDR[3:0] = Y_D;

  assign LEDG[0] = z;

  reg [3:0] y_Q, Y_D; // y_Q represents current state, Y_D represents next state
  parameter A = 4'b0000, B = 4'b0001, C = 4'b0010, D = 4'b0011, E = 4'b0100, F = 4'b0101, G = 4'b0110, H = 4'b0111, I = 4'b1000;
  always @(w, y_Q)
  begin: state_table
    case (y_Q)
      A: Y_D = (!w)? B:F;
		B: Y_D = (!w)? C:F;
		C: Y_D = (!w)? D:F;
		D: Y_D = (!w)? E:F;
		E: Y_D = (!w)? E:F;
		F: Y_D = (!w)? G:B;
		G: Y_D = (!w)? H:B;
		H: Y_D = (!w)? I:B;
		I: Y_D = (!w)? I:B;
      default: Y_D = 4'bxxxx;
    endcase
  end // state_table
  
  always @(posedge Clk)
  begin: state_FFs
    y_Q = Y_D;
  end // state_FFS

  always 
  begin: zset
    case (y_Q)
      E: z = 1;
      I: z = 1;
      default: z = 0;
    endcase
  end

endmodule
