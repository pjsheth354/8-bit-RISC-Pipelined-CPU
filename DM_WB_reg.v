module DM_WB_reg( 
   input wire clk,
   input wire [7:0] datamemory_input,
	input wire [7:0] datamemory_input1,
	input wire [7:0] mux21_input,
	input wire [3:0] pipe_stg_input,
	input wire [1:0] register_read_Ra,
  	input wire [1:0] register_read_Rb,
	output reg [7:0] datamemory_output,
	output reg [7:0] datamemory_output1,
   output reg [3:0] pipe_stg_output,
	output reg [7:0] mux21_output,   
	output reg [1:0] register_read_Ra_output,
  	output reg [1:0] register_read_Rb_output);
	
always @ (posedge clk)
begin
datamemory_output [7:0] <= datamemory_input [7:0];
datamemory_output1 [7:0] <= datamemory_input1 [7:0];
mux21_output [7:0] <= mux21_input [7:0];
pipe_stg_output [3:0] <= pipe_stg_input[3:0];
register_read_Ra_output [1:0] <= register_read_Ra [1:0];
register_read_Rb_output [1:0] <= register_read_Rb [1:0];
end
endmodule
	