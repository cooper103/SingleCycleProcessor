// Mux4Machine.v
// State machine to drive multiplexed four-bit values for display
// on Digilent BASYS2 and BASYS3 seven segment displays.  Assumes
// a high speed input clock, uses internal counter to time-multiplex
// the four display signals.  
module Mux4Machine(muxd,adrive,A,B,C,D,clk,reset,blank);
  output [3:0] muxd; // The multiplexed output selected from A,B,C,D
  output [3:0] adrive;  // Active low common anode drive of display
  input  [3:0] A,B,C,D,blank;
  input        clk,reset;

  reg    [3:0] muxd, adrive;
  parameter NUMSVAR=20;
  //parameter NUMSVAR=8;   // for testing
  // Time-multiplexing: A count of 2^NUMSVAR total clock ticks
  // will occur across one full display of four digits.
  // With a 100 MHz clock (10 ns period), that means 10 ns * 2^20 
  // = 10 ns/tick * 1.048576E6 ticks = 10.48576 ms. That is, the whole
  // display is updated around 95 times per second (95 Hz),
  // with each display "on" for 2.62 ms out of every 10.48 ms.
  reg    [NUMSVAR:1] nS, S; // Internal states to provide clk division

  always @(posedge clk)
    if (reset) S <= 0;
    else  S <= nS;

  always @(S)
    nS = S + 1;

  always @(S[NUMSVAR:NUMSVAR-1] or A or B or C or D or blank)
  begin
    case(S[NUMSVAR:NUMSVAR-1])
        2'b11: begin muxd=A; adrive=(!blank[3] ? 4'b0111 : 4'b1111); end
        2'b10: begin muxd=B; adrive=(!blank[2] ? 4'b1011 : 4'b1111); end
        2'b01: begin muxd=C; adrive=(!blank[1] ? 4'b1101 : 4'b1111); end
        2'b00: begin muxd=D; adrive=(!blank[0] ? 4'b1110 : 4'b1111); end
        default: begin muxd=A; adrive=4'b1111; end
    endcase
  end
endmodule
