module REG_MUX #(
  parameter RSTTYPE = "SYNC",
  parameter WIDTH = 18,
  parameter INREG = 0
  )
  (
    input [WIDTH-1:0] in,
    input rst,
    input clk,
    input CE,
    output [WIDTH-1:0] mux_out 
  );
  reg [WIDTH-1 : 0] reg_out ;

  generate
  if (RSTTYPE == "SYNC") begin
    always @(posedge clk) begin
      if(CE) begin
        if(rst)
          reg_out <= 0;
        else 
          reg_out <= in;
      end
    end
  end
  else if(RSTTYPE == "ASYNC") begin
    always @(posedge clk or posedge rst) begin
        if(rst)
          reg_out <= 0;
        else if(CE) 
          reg_out <= in;
    end 
  end
  endgenerate

  assign mux_out = (INREG)? reg_out : in;

endmodule