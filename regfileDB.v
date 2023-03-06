// regfileDB.v

module regfileDB(RD1,RD2,A1,A2,A3,WD3,R15,WE3,clk,reset,DBtheRegVal,DBtheReg);
  output  [31:0]  RD1, RD2;
  input   [3:0]   A1, A2, A3;
  input   [31:0]  WD3, R15;
  input           WE3, clk, reset;
  output  [31:0]  DBtheRegVal;
  input   [3:0]   DBtheReg;

  reg     [31:0]  rf[14:0];

  always @(posedge clk)
    if(reset) begin
      rf[0]<=0; rf[1]<=0; rf[2]<=0; rf[3]<=0;
      rf[4]<=0; rf[5]<=0; rf[6]<=0; rf[7]<=0;
      rf[8]<=0; rf[9]<=0; rf[10]<=0; rf[11]<=0;
      rf[12]<=0; rf[13]<=0; rf[14]<=0;
    end else
    if(WE3)
      rf[A3] <= WD3;

  assign  RD1 = (A1 == 4'd15) ? R15 : rf[A1];
  assign  RD2 = (A2 == 4'd15) ? R15 : rf[A2];
  assign  DBtheRegVal = (DBtheReg == 4'd15) ? R15 : rf[DBtheReg];
endmodule
