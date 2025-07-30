module DSP48A1_tb();
reg clk;
reg CARRYIN;
reg CEA, CEB, CEC, CECARRYIN, CED, CEM, CEOPMODE, CEP;
reg RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP;
reg [17:0] A, B, D, BCIN;
reg [47:0] C, PCIN;
reg [7:0] OPMODE;
wire CARRYOUT, CARRYOUTF;
wire [17:0] BCOUT;
wire [35:0] M;
wire [47:0] P, PCOUT;
DSP48A1 DUT (
              .CLK(clk),.CARRYIN(CARRYIN),.A(A), .B(B), .D(D), .BCIN(BCIN),
              .CEA(CEA), .CEB(CEB), .CEC(CEC), .CECARRYIN(CECARRYIN),
              .CED(CED), .CEM(CEM), .CEOPMODE(CEOPMODE), .CEP(CEP),
              .RSTA(RSTA), .RSTB(RSTB), .RSTC(RSTC), .RSTCARRYIN(RSTCARRYIN),
              .RSTD(RSTD), .RSTM(RSTM), .RSTOPMODE(RSTOPMODE), .RSTP(RSTP),
              .C(C), .PCIN(PCIN),
              .OPMODE(OPMODE),
              .CARRYOUT(CARRYOUT), .CARRYOUTF(CARRYOUTF),
              .BCOUT(BCOUT),
              .M(M),.P(P), .PCOUT(PCOUT)
);

initial begin
  clk = 0;
  forever begin
  #1 clk = ~clk;
  end
end

initial begin
  //2.1. Verify Reset Operation 
  RSTA = 1; RSTB = 1; RSTC = 1; RSTCARRYIN = 1;
  RSTD = 1; RSTM = 1; RSTOPMODE = 1; RSTP = 1;
  A = $random; B = $random; D = $random; BCIN = $random;
  C = $random; PCIN = $random; OPMODE = $random; CARRYIN = $random;
  CEA = $random; CEB = $random; CEC = $random; CECARRYIN = $random;
  CED = $random; CEM = $random; CEOPMODE = $random; CEP = $random;
  @(negedge clk);
  if (CARRYOUT != 0 || CARRYOUTF != 0 || BCOUT != 0 || M != 0 || P != 0 || PCOUT != 0) begin
    $display("reset check failed");
    $stop;
  end 
  else 
    $display("reset check passed");

  RSTA = 0; RSTB = 0; RSTC = 0; RSTCARRYIN = 0;
  RSTD = 0; RSTM = 0; RSTOPMODE = 0; RSTP = 0;
  CEA = 1;CEB = 1;CEC = 1;CECARRYIN = 1;
  CED = 1;CEM = 1;CEOPMODE = 1;CEP = 1;
  
  //2.2. Verify DSP Path 1 
  OPMODE = 8'b11011101;
  A= 20; B = 10; C = 350; D = 25;
  BCIN =$random; PCIN =$random; CARRYIN =$random;
  repeat(4) @(negedge clk);
  @(negedge clk);
  if (CARRYOUT != 0 || CARRYOUTF != 0 || BCOUT != 'hf || M != 'h12c || P != 'h32 || PCOUT != 'h32) begin
    $display("Path 1 check failed");
    $stop;
  end 
  else 
    $display("Path 1 check passed");

  //2.3. Verify DSP Path 2 
  OPMODE = 8'b00010000;
  A= 20; B = 10; C = 350; D = 25;
  BCIN =$random; PCIN =$random; CARRYIN =$random;
  repeat(3) @(negedge clk);
  if (CARRYOUT != 0 || CARRYOUTF != 0 || BCOUT != 'h23 || M != 'h2bc || P != 0 || PCOUT != 0) begin
    $display("Path 2 check failed");
    $stop;
  end 
  else 
    $display("Path 2 check passed");

  //2.4. Verify DSP Path 3 
  OPMODE = 8'b00001010;
  A= 20; B = 10; C = 350; D = 25;
  BCIN =$random; PCIN =$random; CARRYIN =$random;
  repeat(3) @(negedge clk);
  if (CARRYOUT != 0 || CARRYOUTF != 0 || BCOUT != 'ha || M != 'hc8 || P != 0 || PCOUT != 0) begin
    $display("Path 3 check failed");
    $stop;
  end 
  else 
    $display("Path 3 check passed");

  //2.5. Verify DSP Path 4 
  OPMODE = 8'b10100111;
  A = 5; B = 6; C = 350; D = 25; PCIN = 3000;
  BCIN =$random; CARRYIN =$random; 
  repeat(3) @(negedge clk);
  if (CARRYOUT != 1 || CARRYOUTF != 1 || BCOUT != 'h6 || M != 'h1e || P != 'hfe6fffec0bb1 || PCOUT != 'hfe6fffec0bb1) begin
    $display("Path 4 check failed");
    $stop;
  end 
  else 
    $display("Path 4 check passed");

  $stop;

end
endmodule