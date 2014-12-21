module lab5_4 (input CLOCK_50, input [17:0] SW, input [3:0] KEY, output [17:0] LEDR);

  wire [25:0] halfSEC;
  wire pulses;
  wire [3:0] morse;
  
  reg pulse;
  reg [13:0] signal;
  
  //.5s clock
  modk_counter C0 (CLOCK_50, KEY[0], halfSEC);
  defparam C0.n = 26;
  defparam C0.k = 25000000;

  //0.5s pulses
  modk_counter C1 (pulse, KEY[0], pulses);
  defparam C1.n = 1;
  defparam C1.k = 2;
  
  //LEDR counter
  modk_counter C2 (pulses, KEY[0], morse);
  defparam C2.n = 4;
  defparam C2.k = 14;

  morse_code(morse[3:0], signal, LEDR[0]);

  always @ (negedge CLOCK_50) begin
    if (halfSEC == 24999999)
      pulse = 1;
    else
      pulse = 0;
  end
  
// A    o-       -_--        101100000000
// B    -ooo     --_-_-_-    110101010000
// C    -o-o     --_-_--_-   110101101000
// D    -oo      --_-_-      110101000000
// E    o        -           100000000000
// F    oo-o     -_-_--_-    101011010000
// G    --o      --_--_-     110110100000
// H    oooo     -_-_-_-     101010100000
  
  always @ (negedge KEY[1]) begin
    case (SW[2:0])
      0: signal = 14'b00101100000000; // A
      1: signal = 14'b00110101010000; // B
      2: signal = 14'b00110101101000; // C
      3: signal = 14'b00110101000000; // D
      4: signal = 14'b00100000000000; // E
      5: signal = 14'b00101011010000; // F
      6: signal = 14'b00110110100000; // G
      7: signal = 14'b00101010100000; // H
    endcase
  end
	
endmodule

module morse_code(input [3:0] code, input [13:0] signal, output reg morse);
 always begin
    case (code)
      0:morse = signal[13];
      1:morse = signal[12];
      2:morse = signal[11];
      3:morse = signal[10];
      4:morse = signal[9];
      5:morse = signal[8];
      6:morse = signal[7];
      7:morse = signal[6];
      8:morse = signal[5];
      9:morse = signal[4];
      10:morse = signal[3];
      11:morse = signal[2];
      12:morse = signal[1];
      13:morse = signal[0];
		default: morse = 0;
    endcase
  end
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