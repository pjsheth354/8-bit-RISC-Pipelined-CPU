module DE_stg( 
   input wire clk,
	input wire [7:0] init_input,
   input wire we_rf,           
   input wire [23:0] instruction,     
   input wire [7:0] data,             
   input wire reset,
   input wire RF_in_sel,
	input wire [1:0] WB_read_reg_Ra,
	input wire [3:0] WB_read_opcode,
	input wire [1:0] DM_register_read_Ra_input,
	input wire [7:0] DE_DM_input,
	input wire [3:0] DM_opcode_input,
   output wire [7:0] Ra,              
   output wire [7:0] Rb,              
	output wire [3:0] pipe_stg_output,
	output wire [7:0] address_output,
	output wire [7:0] R0,R1,R2,R3,
	output wire [1:0] register_read_Ra,
	output wire [1:0] register_read_Rb,
	output wire [7:0] Z_N_flag_status,
	output wire [7:0] shift_address,
	output wire [7:0] final_output
	);
	
	
   Regfile Regfile1(.clk(clk),                             
.we(we_rf),
						  .opcode(instruction[15:0]),
						  .RF_in_sel(RF_in_sel),
						  .data(data[7:0]),
						  .reset(reset),
						  .Ra(Ra[7:0]),
						  .Rb(Rb[7:0]),
						  .address_output(address_output[7:0]),
						  .R0(R0),
						  .R1(R1),
						  .R2(R2),
						  .R3(R3),
						  .WB_read_reg_Ra(WB_read_reg_Ra[1:0]),
						  .WB_read_opcode(WB_read_opcode[3:0]),
						  .register_read_Ra_input(DM_register_read_Ra_input),
						  .DE_DM_input(DE_DM_input),
						  .DM_opcode_input(DM_opcode_input),
						  .final_output(final_output[7:0]),
						  .init_input(init_input[7:0]));
						  
	
	assign pipe_stg_output [3:0] = instruction [15:12];
	assign register_read_Ra [1:0] = instruction [11:10];
	assign register_read_Rb [1:0] = instruction [9:8];
   assign Z_N_flag_status [7:0] =  instruction [15:8];
   assign shift_address [7:0] = instruction [23:16];   
endmodule


//----------------------------------------------------------------------------------------

module Regfile(
   input wire clk,
	input wire [7:0] init_input,
   input wire we,
   input wire [15:0] opcode,
   input wire [7:0] data,
   input wire reset,
	input wire RF_in_sel,
	input wire [1:0] WB_read_reg_Ra,
	input wire [3:0] WB_read_opcode,
	input wire [1:0] register_read_Ra_input,
	input wire [7:0] DE_DM_input,
	input wire [3:0] DM_opcode_input,
   output reg [7:0] Ra,
   output reg [7:0] Rb,
	output reg [7:0] address_output,
	output reg [7:0] R0, R1, R2, R3, 
	output reg [7:0] final_output);

   
	
   always @(we,opcode,DE_DM_input,R0,R1,R2,R3,RF_in_sel,init_input,data,WB_read_reg_Ra)
   begin
      
		
      if(we) begin
				
         if (opcode[15:12] == 4'b1101) begin
				address_output <=  opcode [7:0]; 
			end
			
			else if (opcode[15:12] == 4'b1111) begin
			   case (opcode[11:10])
		         2'b00: R0 <= opcode[7:0] ;
               2'b01: R1 <= opcode[7:0] ;
               2'b10: R2 <= opcode[7:0] ;
               2'b11: R3 <= opcode[7:0] ;
			   endcase				
		  	end
		end
		


         if (WB_read_opcode[3:0] == 4'b0001 | WB_read_opcode[3:0] == 4'b0010 | WB_read_opcode[3:0] == 4'b0011 | WB_read_opcode[3:0] == 4'b0100 | WB_read_opcode[3:0] == 4'b0101 | WB_read_opcode[3:0] == 4'b1000 /*| WB_read_opcode[3:0] == 4'b1000*/  )begin
            case (WB_read_reg_Ra[1:0])
              2'b00: R0 <= data;
              2'b01: R1 <= data;
              2'b10: R2 <= data;
              2'b11: R3 <= data; 
            endcase
         end
 
	
         if (DM_opcode_input[3:0] == 4'b1101) begin
            case (register_read_Ra_input[1:0])
              2'b00: R0 <= DE_DM_input;
              2'b01: R1 <= DE_DM_input;
              2'b10: R2 <= DE_DM_input;
              2'b11: R3 <= DE_DM_input; 
            endcase
         end

	

      if ((opcode[15:12] == 4'b0001) | (opcode[15:12] == 4'b0010) | (opcode[15:12] == 4'b0011) | (opcode[15:12] == 4'b0100) | (opcode[15:12] == 4'b0101) | (opcode[15:12] == 4'b0110) |(opcode[15:12] == 4'b0111 | opcode[15:12] == 4'b1110 | opcode[15:12] == 4'b1000)) begin
         case (opcode[11:10])
            2'b00: Ra <= R0;
            2'b01: Ra <= R1;
            2'b10: Ra <= R2;
            2'b11: Ra <= R3;
         endcase
         if (opcode[15:12] == 4'b0111) begin
            if (RF_in_sel == 0)begin              
            R0 <= init_input;
				Ra <= R0;
            end
         end		  
			if (opcode[15:12] == 4'b1110) begin
			   address_output <=  opcode [7:0];
			end
         
			if (opcode[15:12] == 4'b0110) begin
			   final_output <= R0;
			end	
			
         if ((opcode[15:12] == 4'b0001) | (opcode[15:12] == 4'b0010) | (opcode[15:12] == 4'b0011 | opcode[15:12] == 4'b1000)) begin
            case (opcode[9:8])
               2'b00: Rb <= R0;
               2'b01: Rb <= R1;
               2'b10: Rb <= R2;
               2'b11: Rb <= R3;
            endcase  
         end
      end
 end  
endmodule