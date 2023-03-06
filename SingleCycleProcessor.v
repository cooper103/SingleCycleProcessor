// SingleCycleProcessor.v

module  SingleCycleProcessor(DBtheRegVal,machineValue,DBtheReg,clk,reset);
  output  [31:0]  DBtheRegVal, machineValue; //machineValue for displaying instruction machine code
  input   [3:0]   DBtheReg;
  input           clk, reset;

  wire            PCSrc, MemtoReg, MemWrite, ALUSrc;
  wire    [1:0]   ImmSrc, RegSrc;
  wire    [2:0]   ALUControl;
  wire    [31:0]  Instr, PCPrime, PCPlus4, PCPlus8, Result, ReadData,
                  ALUResult, SrcA, SrcB, RD2, WriteData, ExtImm;
  wire    [3:0]   RA1, RA2, ALUFlags;

  reg     [31:0]  PC;

  // One state block at this level, the program counter.
  always @(posedge clk)
    if(reset)
        PC <= 0;
    else
        PC <= PCPrime;

  // Wire up the major blocks
  controlunit     ctrlu(.PCSrc(PCSrc),.MemtoReg(MemtoReg),.MemWrite(MemWrite),
                        .ALUControl(ALUControl),.ALUSrc(ALUSrc),.ImmSrc(ImmSrc),
                        .RegWrite(RegWrite),.RegSrc(RegSrc),
                        .Instr(Instr),.Flags(ALUFlags),.clk(clk));
  imem            imemv(.RD(Instr), .mVal(machineValue), .A(PC)); //machineValue for displaying instruction machine code
  regfileDB       regfl(.RD1(SrcA),.RD2(RD2),.A1(RA1),.A2(RA2),.A3(Instr[15:12]),
                        .WD3(Result),.R15(PCPlus8),.WE3(RegWrite),
                        .clk(clk),.reset(reset),.DBtheRegVal(DBtheRegVal),.DBtheReg(DBtheReg));
  extend          extim(.ExtImm(ExtImm),.theData(Instr[23:0]),.ImmSrc(ImmSrc));
  alu             alumv(.ALUResult(ALUResult),.ALUFlags(ALUFlags),.ALUControl(ALUControl),
                        .SrcA(SrcA),.SrcB(SrcB));
  dmem            dmemv(.RD(ReadData),.A(ALUResult),.WD(WriteData),.WE(MemWrite),.clk(clk));

  // Build and wire the glue
  assign  PCPrime = PCSrc ? Result : PCPlus4;
  assign  PCPlus4 = PC+4;
  assign  PCPlus8 = PCPlus4+4;
  assign  Result  = MemtoReg ? ReadData : ALUResult;
  assign  RA1     = RegSrc[0] ? 4'd15 : Instr[19:16];
  assign  RA2     = RegSrc[1] ? Instr[15:12] : Instr[3:0];
  assign  SrcB    = ALUSrc ? ExtImm : RD2;
  assign  WriteData = RD2;

endmodule
