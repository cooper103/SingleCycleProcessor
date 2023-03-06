// imem.v

module imem(RD, mVal, A);
  output  [31:0]  RD, mVal; //mVal for displaying instruction machine code
  input   [31:0]  A;

  reg     [31:0]  RD;

  always @(A)
    case(A[5:2])
      4'b0000: RD = 32'hE3A0_2031;  //      MOV  R2, #0x31
      4'b0001: RD = 32'hE3A0_30E6;  //      MOV  R3, #0xE6
      4'b0010: RD = 32'hE022_2003;  //      EOR  R2, R2, R3
      default: RD = 32'hEAFF_FFFE;  // T3:  BAL  T3
    endcase
    
   assign mVal = RD;
endmodule
