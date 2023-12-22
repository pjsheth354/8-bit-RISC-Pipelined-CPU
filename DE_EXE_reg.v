module DE_EXE_reg( 
    input clk,
    input [7:0] reg_in1,
	 input [7:0] reg_in2,
	 input [7:0] reg_in_add,
	 input [7:0] FU_in1,
	 input [7:0] FU_in2,
	 input wire [3:0] pipe_stg_input,
	 input wire [1:0] register_read_Ra,
  	 input wire [1:0] register_read_Rb,
	 input wire [7:0] Z_N_flag_status,
	 input wire [7:0] shift_address,
	 output reg [7:0] reg_out1,
	 output reg [7:0] reg_out2,
	 output reg [7:0] reg_out_add,
	 output reg [7:0] reg_out_FU1,
	 output reg [7:0] reg_out_FU2,
	 output wire [3:0] pipe_stg_output,
	 output reg [7:0] shift_address_output,
	 output reg [1:0] register_read_Ra_output,
  	 output reg [1:0] register_read_Rb_output,
	 output wire [7:0] Z_N_flag_status_output);
	 
	 
	 assign Z_N_flag_status_output [7:0] = Z_N_flag_status;
	 assign pipe_stg_output [3:0] = pipe_stg_input[3:0];
	 
always @ (posedge clk)
begin
reg_out1 [7:0] = reg_in1 [7:0];
reg_out2 [7:0] = reg_in2 [7:0];
reg_out_add [7:0] = reg_in_add [7:0];
reg_out_FU1 [7:0] = FU_in1 [7:0];
reg_out_FU2 [7:0] = FU_in2 [7:0];

register_read_Ra_output [1:0] = register_read_Ra [1:0];
register_read_Rb_output [1:0] = register_read_Rb [1:0];

shift_address_output [7:0] = shift_address [7:0]; 
end
endmodule
	 