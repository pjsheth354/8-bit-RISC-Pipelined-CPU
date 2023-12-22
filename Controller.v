module controller(
        input wire reset_input,
        input wire clk,
        //FE_DE
        input wire [23:0] FEDEinput,
		  input wire [23:0] FEDE_stg_input, 
		  input wire Z_input,N_input,
		  output reg Z_output,N_output,
		  output reg we_rf,
		  output reg FE_mux_sel,
		  output reg RF_in_sel, 
		  
		  
		  //DE_EXE
		  input wire [7:4] EXE_opcode_in,
		  input wire [7:0] EXE_reg_in1,
	     input wire [7:0] EXE_reg_in2,
		  output reg [3:0] EXE_opcode_out,
		  
		  
		  //EXE_DM
		  input wire [7:0] address_input,
	     input wire [7:0] alu_input,
		  input wire [7:4] DM_opcode_in,
		  output reg we_dm,
		  output reg [3:0] DM_opcode_out,
		  output reg reset_output,
		  
		  
		  //DM_WB
		  input wire [7:4] WB_opcode_in,
		  input wire [7:0] datamemory_input,
	     input wire [7:0] datamemory_input1,
		  output reg WB_mux_sel);
	 	     
       




always @(reset_input,Z_input,N_input)begin
      reset_output <= reset_input;
		
		if (reset_input == 1'b1) begin
		   Z_output <= 1'b1;
         N_output <= 1'b0;	
		end
		
      Z_output <= Z_input;
      N_output <= N_input;
end
		  
always @(FEDEinput)
begin
       
       
    if (FEDEinput [15:12] == 4'b0000) begin //nop
		we_rf <= 1'b0;
	 end
	 else if (FEDEinput [15:12] == 4'b0001 | FEDEinput [15:12] == 4'b0010 | FEDEinput [15:12] == 4'b0011 | FEDEinput [15:12] == 4'b0100 | FEDEinput [15:12] == 4'b0101 | FEDEinput [15:12] == 4'b0110 | FEDEinput [15:12] == 4'b0111 | FEDEinput [15:12] == 4'b1000 | FEDEinput [15:12] == 4'b1001 | FEDEinput [15:12] == 4'b1010 | FEDEinput [15:12] == 4'b1011 | FEDEinput [15:12] == 4'b1100 | FEDEinput [15:12] == 4'b1101 | FEDEinput [15:12] == 4'b1110 | FEDEinput [15:12] == 4'b1111) begin
		if (FEDEinput [15:12] == 4'b1001 | FEDEinput [15:12] == 4'b1010 | FEDEinput [15:12] == 4'b1011 | FEDEinput [15:12] == 4'b1100) begin //branch format
			we_rf <= 1'b0 ;
		end
      else if (FEDEinput [15:12] == 4'b0001 | FEDEinput [15:12] == 4'b0010 | FEDEinput [15:12] == 4'b0011 | FEDEinput [15:12] == 4'b0100 | FEDEinput [15:12] == 4'b0101 | FEDEinput [15:12] == 4'b0110 | FEDEinput [15:12] == 4'b0111 | FEDEinput [15:12] == 4'b1000 | FEDEinput [15:12] == 4'b1101 | FEDEinput [15:12] == 4'b1110 | FEDEinput [15:12] == 4'b1111) begin			
	      we_rf <= 1'b1;
			if (FEDEinput [15:12] == 4'b0111)
			   RF_in_sel <= 1'b0;
			else 
			   RF_in_sel <= 1'b1;
		end
	 end	
end

			
always @(EXE_opcode_in, EXE_reg_in1, EXE_reg_in2)
begin
      EXE_opcode_out <= EXE_opcode_in; 	
end 


always @(DM_opcode_in, address_input, alu_input)
begin
   DM_opcode_out <= DM_opcode_in;
   if (DM_opcode_in == 4'b1110)
	   // @ (posedge clk)
       we_dm <= 1'b1; 
	else 
	    we_dm <= 1'b0; 
	
end

always @(datamemory_input, datamemory_input1)
begin
   if (WB_opcode_in == 4'b0000 | WB_opcode_in == 4'b0001 | WB_opcode_in == 4'b0010 | WB_opcode_in == 4'b0011 | WB_opcode_in == 4'b0100 | WB_opcode_in == 4'b0101 | WB_opcode_in == 4'b0110 | WB_opcode_in == 4'b0111 | WB_opcode_in == 4'b1000 | WB_opcode_in == 4'b1001 | WB_opcode_in == 4'b1010 | WB_opcode_in == 4'b1011 | WB_opcode_in == 4'b1100 | WB_opcode_in  == 4'b1111 | WB_opcode_in == 4'b1110)
       WB_mux_sel <= 1'b1; 
	else 
	    WB_mux_sel <= 1'b0; 
	
end

endmodule 	      
       	 