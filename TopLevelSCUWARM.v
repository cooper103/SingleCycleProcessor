// TopLevelSCUWARM.v

module TopLevelSCUWARM(sevenSegmentsa2g,anodeDrives,theReg,TopHalf,PushButton,clk,reset,iCode);
  output [0:6]    sevenSegmentsa2g;
  output [3:0]    anodeDrives;
  input  [3:0]    theReg;
  input           TopHalf, PushButton, clk, reset, iCode;

  wire   [31:0]   theRegVal, mDisp, out; //mDisp for displaying instruction machine code
  wire   [3:0]    the7SegVal;
  wire   [3:0]    setA, setB, setC, setD;

  SingleCycleProcessor    scpuw(.DBtheRegVal(theRegVal),.machineValue(mDisp),.DBtheReg(theReg),.clk(PushButton),.reset(reset));
  Mux4Machine             mux4m(.muxd(the7SegVal),.adrive(anodeDrives),.A(setA),.B(setB),
                                .C(setC),.D(setD),.clk(clk),.reset(reset),.blank(4'b0000));
  Hex27Seg                hx27s(.Leds(sevenSegmentsa2g),.HexVal(the7SegVal));

  assign  setA = TopHalf ? out[31:28] : out[15:12];
  assign  setB = TopHalf ? out[27:24] : out[11:8];
  assign  setC = TopHalf ? out[23:20] : out[7:4];
  assign  setD = TopHalf ? out[19:16] : out[3:0];
  
  assign  out[31:0] = iCode ? mDisp[31:0] : theRegVal[31:0];
    
endmodule
