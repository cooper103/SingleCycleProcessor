// extend.v

module  extend(ExtImm,theData,ImmSrc);
  output  [31:0]  ExtImm;
  input   [23:0]  theData;
  input   [1:0]   ImmSrc;

  reg     [31:0]  ExtImm;

  always  @(theData, ImmSrc)
    case(ImmSrc)
      2'b00:  ExtImm = {24'b0,theData[7:0]};
      2'b01:  ExtImm = {20'b0,theData[11:0]};
      2'b10:  ExtImm = {{6{theData[23]}},theData[23:0],2'b00};
      default:  ExtImm = 32'b0;
    endcase
endmodule



