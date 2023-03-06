// controlunit.v

module controlunit(PCSrc,MemtoReg,MemWrite,ALUControl,ALUSrc,ImmSrc,RegWrite,RegSrc,
                   Instr,Flags,clk);
  output          PCSrc, MemtoReg, MemWrite,ALUSrc,RegWrite;
  output [1:0]    ImmSrc, RegSrc;
  output [2:0]    ALUControl;
  input  [31:0]   Instr;
  input  [3:0]    Flags;
  input           clk;

  reg             N,Z,C,V,Write;    // For processor storage of status flags
  reg             CondEx;     // Is the condition satisfied for storage
  reg    [2:0]    ALUControl, FlagW;

  // Parsing of Instr into identifiable segments.
  wire   [3:0]    Cond, Rd;
  wire   [1:0]    Op;
  wire   [5:0]    Funct;
  wire            S;

  wire            Branch, MemW, RegW, ALUOp;

  wire            PCS;

  // Provide the internal decoding names of the instruction field bits.
  assign  Cond  = Instr[31:28];
  assign  Op    = Instr[27:26];
  assign  Funct = Instr[25:20];
  assign  Rd    = Instr[15:12];
  assign  S     = Instr[20];


  assign  Branch   = (Op==2'b10);
  assign  MemtoReg = (Op==2'b01)&&(Funct[0]);
  assign  MemW     = (Op==2'b01)&&(!Funct[0]);
  assign  ALUSrc   = !((Op==2'b00)&&(!Funct[5]));
  assign  ImmSrc   = Op;
  assign  RegW     = ((Op==2'b00) || ((Op==2'b01)&&Funct[0])) && Write; //Added write signal so regWrite can only be active for nonCMP instructions
  assign  RegSrc[1]= (Op==2'b01)&&(!Funct[0]);
  assign  RegSrc[0]= (Op==2'b10);
  assign  ALUOp    = (Op==2'b00);

  // The PC Logic block
  assign  PCS = ((Rd==4'd15) && RegW) || Branch;

  always @(ALUOp,Funct,S)
    case(ALUOp)
      1'b0:   {ALUControl,FlagW} = 5'b000_00;
      1'b1:   case({Funct[4:1],S})
                5'b0100_0:  begin {ALUControl,FlagW} = 5'b000_00; Write = 1; end  // ADD
                5'b0100_1:  begin {ALUControl,FlagW} = 5'b000_11; Write = 1; end  // ADDS
                5'b0010_0:  begin {ALUControl,FlagW} = 5'b001_00; Write = 1; end  // SUB
                5'b0010_1:  begin {ALUControl,FlagW} = 5'b001_11; Write = 1; end  // SUBS
                5'b0000_0:  begin {ALUControl,FlagW} = 5'b010_00; Write = 1; end  // AND
                5'b0000_1:  begin {ALUControl,FlagW} = 5'b010_10; Write = 1; end  // ANDS
                5'b1100_0:  begin {ALUControl,FlagW} = 5'b011_00; Write = 1; end  // ORR
                5'b1100_1:  begin {ALUControl,FlagW} = 5'b011_10; Write = 1; end  // ORRS
                5'b1010_1:  begin {ALUControl,FlagW} = 5'b001_11; Write = 0; end  // CMP
                5'b0001_0:  begin ALUControl = 3'b100; FlagW = 2'b00; Write = 1; end  // EOR
                5'b0001_1:  begin ALUControl = 3'b100; FlagW = 2'b10; Write = 1; end  // EORS
                default:    begin {ALUControl,FlagW} = 5'b000_00; Write = 1; end  
              endcase
      default: {ALUControl,FlagW} = 5'b000_00;
    endcase

  // The processor storage of status flags
  always @(posedge clk) begin
    N <= (FlagW[1]&&CondEx) ? Flags[3] : N;
    Z <= (FlagW[1]&&CondEx) ? Flags[2] : Z;
    C <= (FlagW[0]&&CondEx) ? Flags[1] : C;
    V <= (FlagW[0]&&CondEx) ? Flags[0] : V;
  end

  always @(Cond,N,Z,C,V)
    case(Cond)
      4'b0000:    CondEx = Z;                     // EQ
      4'b0001:    CondEx = !Z;                    // NE
      4'b0010:    CondEx = C;                     // CS/HS
      4'b0011:    CondEx = !C;                    // CC/LO
      4'b0100:    CondEx = N;                     // MI
      4'b0101:    CondEx = !N;                    // PL
      4'b0110:    CondEx = V;                     // VS
      4'b0111:    CondEx = !V;                    // VC
      4'b1000:    CondEx = (!Z) && C;             // HI
      4'b1001:    CondEx = Z || (!C);             // LS
      4'b1010:    CondEx = !(N ^ V);              // GE
      4'b1011:    CondEx = N ^ V;                 // LT
      4'b1100:    CondEx = (!Z) && (!(N ^ V));    // GT
      4'b1101:    CondEx = Z || (N ^ V);          // LE
      4'b1110:    CondEx = 1;                     // AL
      default:    CondEx = 1;
    endcase

  // Conditionally controlled updates to PC, Reg, Mem
  assign  PCSrc = PCS && CondEx;
  assign  RegWrite = RegW && CondEx;
  assign  MemWrite = MemW && CondEx;
endmodule
