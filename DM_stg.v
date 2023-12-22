module DM_stg( 
   input clk,
   input wire [7:0] address_input,
	input wire [7:0] mux21_input,
	input wire [7:0] alu_input,
	input wire [3:0] pipe_stg_input,
	input wire we,
	input wire [3:0] opcode,
	input wire [1:0] register_read_Ra,
  	input wire [1:0] register_read_Rb,
	output wire [7:0] datamemory_output,
	output wire [7:0] datamemory_output1,
   output wire [3:0] pipe_stg_output,
	output wire [7:0] mux21_output,	
	output wire [1:0] register_read_Ra_output,
  	output wire [1:0] register_read_Rb_output,
	output wire [7:0] DM_DE_output);
	
	
	 Datamem Datamem1 (.clk(clk),
	                   .we(we),
	                   .address(address_input),
							 .alu_input(alu_input),
							 .opcode(opcode),
							 .datamemory_output(datamemory_output),
							 .datamemory_output1(datamemory_output1),
							 .DM_DE_output(DM_DE_output)); 
							 
assign pipe_stg_output [3:0] = pipe_stg_input [3:0];
assign mux21_output [7:0] = mux21_input [7:0];	
assign register_read_Ra_output [1:0] = register_read_Ra [1:0];
assign register_read_Rb_output [1:0] = register_read_Rb [1:0];	
endmodule

//-------------------------------------------------------------------------------------------	
module Datamem(  
    input wire clk,
    input wire we,
    input wire [7:0] address, 
    input wire [7:0] alu_input,
	 input wire [3:0] opcode,
    output reg [7:0] datamemory_output,
	 output reg [7:0] datamemory_output1,
	 output reg [7:0] DM_DE_output);
	 
    reg [7:0] datamem [2**8:0];

/*
parameter LOAD = 4'b1101;
parameter STORE = 4'b1110;
parameter LOADIMM = 4'b1111;	 
*/	 
	 
always @(we,opcode,datamem,alu_input)
begin
     if(opcode == 4'b1110) 
	    begin
         if(we) 
	        begin
             datamem[address] <= alu_input;
	        end
       end
	  else if (opcode == 4'b1111) 
	    begin
         datamemory_output <= datamem[address];
	    end
	  else if(opcode == 4'b0000 | opcode == 4'b0001 | opcode == 4'b0010 | opcode == 4'b0011 | opcode == 4'b0100 | opcode == 4'b0101 | opcode == 4'b0110 | opcode == 4'b0111 | opcode == 4'b1000 | opcode == 4'b1001 | opcode == 4'b1010 | opcode == 4'b1011 | opcode == 4'b1100) 
	    begin
	      datamemory_output1 <= alu_input;
       end 	
	  else if (opcode == 4'b1101) 
	      DM_DE_output <= datamem[address];
end 
endmodule 
