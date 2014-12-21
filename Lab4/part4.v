module lab4_4 (input CLOCK_50, output [6:0] HEX0);

	wire [25:0] Q_clk;
	wire [15:0] Q_ssd;
	reg reset_clk, reset_ssd;
	
	initial begin
		reset_clk = 0;
		reset_ssd = 0;
	end
	
	lab4_lpm_counter(reset_clk, 1, reset_ssd, Q_ssd);
	lpm_counter_26b(CLOCK_50, 1, reset_clk, Q_clk);
	dig_ssd H (Q_ssd[3:0], HEX0);
	
	always @ (negedge CLOCK_50) begin
    reset_clk = (Q_clk >= 50000000)? 1:0;
	end
	
	always @ (negedge reset_clk) begin
    reset_ssd = (Q_ssd >= 9)? 1:0;
  end
	
endmodule

module dig_ssd (input [3:0] b, output reg [6:0] ssd);
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
		default:ssd=7'b1111111; 
    endcase
  end
endmodule