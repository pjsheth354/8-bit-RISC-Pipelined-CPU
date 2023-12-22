module Linkreg (
  input wire clk,
  input wire [23:0] instruction,
  input wire we,
  input wire Z,N,
  output reg [7:0] return_address
);
  reg [7:0] lr;
  reg [7:0] present_address;
  
  assign present_address = instruction[23:16];
  
  
  
  always @(negedge clk) begin
    if (instruction [15:12] == 4'b1011) begin // br.sub input
      lr <= present_address; 
		return_address <= instruction[7:0];
    end
	 
    else if (instruction [15:12] == 4'b1100) begin // return
      return_address <= lr + 8'b00000010;
    end
	 
	 else if (instruction [15:12] == 4'b1001) begin // br
      return_address <= instruction[7:0];
    end

	 else if (instruction [15:12] == 4'b1010 & instruction [11] == 1'b0 ) begin // brz
	   if (Z)
      return_address <= instruction[7:0];
		else 
		return_address <= present_address + 8'b00000010;
    end
	 
	 else if (instruction [15:12] == 4'b1010 & instruction [11] == 1'b1 ) begin // brn
	   if (N)
      return_address <= instruction[7:0];
		else 
		return_address <= present_address + 8'b00000010;
    end
	 
  end
   
  
endmodule