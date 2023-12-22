module FU(
    input wire [7:0] Ra, Rb, //Input Data stream with opcode and data
	 input wire [7:0] WBinput, DMinput,
	 input wire [3:0] DE_opcode,EXE_opcode,
    output reg [1:0] MUX41, MUX42 // 16 bit Instruction
);



always @(Ra, Rb, WBinput, DMinput)
  begin
    /*if (Ra != 8'b00000000 & (DE_opcode != 4'b1110 & EXE_opcode != 4'b0101)) begin
	   if (Ra == DMinput)
	     MUX41 = 2'b10;
	   else if (Ra == WBinput)
		  MUX41 = 2'b01;
		else*/
	     MUX41 = 2'b00;
	 //end
		
	 /*if (Rb != 8'b00000000) begin
	   if (Rb == DMinput)
	     MUX42 = 2'b10;
	   else if (Rb == WBinput)
		  MUX42 = 2'b01;
		else*/
	     MUX42 = 2'b00;
	 //end
  end
 endmodule