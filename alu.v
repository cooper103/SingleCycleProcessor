// alu.v
// ALU for simple ARM single-cycle implementation.

module alu(ALUResult,ALUFlags,ALUControl,SrcA,SrcB);
  output  [31:0]  ALUResult;
  output  [3:0]   ALUFlags;
  input   [2:0]   ALUControl;
  input   [31:0]  SrcA, SrcB;

  reg     [31:0]  ALUResult;
  reg             N,Z,C,V;

  always @(ALUControl,SrcA,SrcB)
    case(ALUControl)
     3'b000:  begin   {C,ALUResult}=SrcA+SrcB;        // ADD
                      Z=(ALUResult==32'b0);
                      N=ALUResult[31];
                      V=SrcA[31]&&SrcB[31]&&(!ALUResult[31])
                        ||(!SrcA[31])&&(!SrcB[31])&&ALUResult[31];
              end
      3'b001:  begin   {C,ALUResult}=SrcA+(-SrcB);     // SUB
                      C=!C;
                      Z=(ALUResult==32'b0);
                      N=ALUResult[31];
                      V=SrcA[31]&&(!SrcB[31])&&(!ALUResult[31])
                        ||(!SrcA[31])&&(SrcB[31])&&ALUResult[31];
              end
      3'b010:  begin   ALUResult=SrcA&SrcB;            // AND
                      Z=(ALUResult==32'b0);
                      N=ALUResult[31];
                      V=0;    // Don't care
                      C=0;    // Don't care
              end
      3'b011:  begin   ALUResult=SrcA|SrcB;            // OR (or ORR)
                      Z=(ALUResult==32'b0);
                      N=ALUResult[31];
                      V=0;    // Don't care
                      C=0;    // Don't care
              end
      3'b100: begin    ALUResult = SrcA^SrcB;      // EOR
                      Z=(ALUResult==32'b0);
                      N=ALUResult[31];
                      V=0;    // Don't care
                      C=0;    // Don't care                               
              end
      default:  begin ALUResult=0; {N,Z,C,V}=4'b0100; end
    endcase

  assign ALUFlags = {N,Z,C,V};  
endmodule
