module DSP48A1 #(
    parameter A0REG = 0,
    parameter A1REG = 1,
    parameter B0REG = 0,
    parameter B1REG = 1,
    parameter CREG = 1,
    parameter DREG = 1,
    parameter MREG = 1,
    parameter PREG = 1,
    parameter CARRYINREG = 1,
    parameter CARRYOUTREG = 1,
    parameter OPMODEREG = 1,
    parameter CARRYINSEL = "OPMODE5",
    parameter B_INPUT = "DIRECT",
    parameter RSTTYPE = "SYNC"
  )
  (
    input [17:0] A,
    input [17:0] B,
    input [47:0] C,
    input [17:0] D,
    input CARRYIN,
    input CLK,
    input [7:0] OPMODE,
    input CEA,
    input CEB,
    input CEC,
    input CECARRYIN,
    input CED,
    input CEM,
    input CEOPMODE,
    input CEP,
    input RSTA,
    input RSTB,
    input RSTC,
    input RSTCARRYIN,
    input RSTD,
    input RSTM,
    input RSTOPMODE,
    input RSTP,
    input [17:0] BCIN,
    input [47:0] PCIN,
    output [17:0] BCOUT,
    output [47:0] PCOUT,
    output [35:0] M,
    output [47:0] P,
    output CARRYOUT,
    output CARRYOUTF
  );
  wire [17:0] B_mux;
  wire [17:0] A0_mux_out;
  wire [17:0] A1_mux_out;
  wire [17:0] B0_mux_out;
  wire [17:0] B1_mux_out;
  wire [47:0] C_mux_out;
  wire [17:0] D_mux_out;
  wire [7:0]  OPMODE_mux_out;
  wire [17:0] pre_add_sub_out;
  wire [17:0] B1_mux;
  wire [35:0] multiplier_out;
  reg [47:0] X_mux_out;
  reg [47:0] Z_mux_out;
  wire carry_cascade_mux;
  wire cin;
  wire [47:0] post_add_sub_out;
  wire cout;


  
  //inputs
  REG_MUX #(.RSTTYPE(RSTTYPE),.WIDTH(18),.INREG(A0REG)) 
          a0(.in(A),.rst(RSTA),.clk(CLK),.CE(CEA),.mux_out(A0_mux_out));

  assign B_mux = (B_INPUT == "DIRECT")? B: (B_INPUT == "CASCADE")? BCIN : 0;
  REG_MUX #(.RSTTYPE(RSTTYPE),.WIDTH(18),.INREG(B0REG)) 
          b0(.in(B_mux),.rst(RSTB),.clk(CLK),.CE(CEB),.mux_out(B0_mux_out));

  REG_MUX #(.RSTTYPE(RSTTYPE),.WIDTH(48),.INREG(CREG)) 
          c(.in(C),.rst(RSTC),.clk(CLK),.CE(CEC),.mux_out(C_mux_out));

  REG_MUX #(.RSTTYPE(RSTTYPE),.WIDTH(18),.INREG(DREG)) 
          d(.in(D),.rst(RSTD),.clk(CLK),.CE(CED),.mux_out(D_mux_out));

  //Pre-Adder/Subtracter
  REG_MUX #(.RSTTYPE(RSTTYPE),.WIDTH(8),.INREG(OPMODEREG)) 
          opmode(.in(OPMODE),.rst(RSTOPMODE),.clk(CLK),.CE(CEOPMODE),.mux_out(OPMODE_mux_out));
  assign pre_add_sub_out = (OPMODE_mux_out[6])? D_mux_out-B0_mux_out : D_mux_out+B0_mux_out;
  
  //multiplier
  assign B1_mux = (OPMODE_mux_out[4])? pre_add_sub_out : B0_mux_out;
  REG_MUX #(.RSTTYPE(RSTTYPE),.WIDTH(18),.INREG(A1REG)) 
          a1(.in(A0_mux_out),.rst(RSTA),.clk(CLK),.CE(CEA),.mux_out(A1_mux_out));
  REG_MUX #(.RSTTYPE(RSTTYPE),.WIDTH(18),.INREG(B1REG)) 
          b1(.in(B1_mux),.rst(RSTB),.clk(CLK),.CE(CEB),.mux_out(B1_mux_out));
  assign BCOUT = B1_mux_out;
  assign multiplier_out = A1_mux_out*B1_mux_out;
  REG_MUX #(.RSTTYPE(RSTTYPE),.WIDTH(36),.INREG(MREG)) 
          m(.in(multiplier_out),.rst(RSTM),.clk(CLK),.CE(CEM),.mux_out(M));
  
  //X and M muxes
  //X
  always @(*) begin
    case(OPMODE_mux_out[1:0])
      2'b00 : X_mux_out = 0;
      2'b01 : X_mux_out = M;
      2'b10 : X_mux_out = P;
      2'b11 : X_mux_out = {D[11:0],A,B};
    endcase
  end
  //Z
  always @(*) begin
    case(OPMODE_mux_out[3:2])
      2'b00 : Z_mux_out = 0;
      2'b01 : Z_mux_out = PCIN;
      2'b10 : Z_mux_out = P;
      2'b11 : Z_mux_out = C_mux_out;
    endcase
  end

  //CIN
  assign carry_cascade_mux = (CARRYINSEL == "CARRYIN")? CARRYIN : (CARRYINSEL == "OPMODE5")? OPMODE_mux_out[5] : 0;
  REG_MUX #(.RSTTYPE(RSTTYPE),.WIDTH(1),.INREG(CARRYINREG)) 
          CYI(.in(carry_cascade_mux),.rst(RSTCARRYIN),.clk(CLK),.CE(CECARRYIN),.mux_out(cin));

  //Post-Adder/Subtracter
  assign {cout,post_add_sub_out} = (OPMODE_mux_out[7])? Z_mux_out-(X_mux_out+cin) : Z_mux_out+X_mux_out+cin;
  REG_MUX #(.RSTTYPE(RSTTYPE),.WIDTH(1),.INREG(CARRYOUTREG)) 
          CYO(.in(cout),.rst(RSTCARRYIN),.clk(CLK),.CE(CECARRYIN),.mux_out(CARRYOUT));
  assign CARRYOUTF = CARRYOUT;
  REG_MUX #(.RSTTYPE(RSTTYPE),.WIDTH(48),.INREG(PREG)) 
          p(.in(post_add_sub_out),.rst(RSTP),.clk(CLK),.CE(CEP),.mux_out(P));
  assign PCOUT = P;

endmodule