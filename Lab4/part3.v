module lab4_3 (input [3:0] SW, KEY, output [7:0] LEDG, output [6:0] HEX3, HEX2, HEX1, HEX0);

	wire [15:0] Q;
	
	lab4_lpm_counter(KEY[0], SW[1], SW[0], Q);

	hex_ssd H0 (Q[3:0], HEX0);
	hex_ssd H1 (Q[7:4], HEX1);
	hex_ssd H2 (Q[11:8], HEX2);
	hex_ssd H3 (Q[15:12], HEX3);
	
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
