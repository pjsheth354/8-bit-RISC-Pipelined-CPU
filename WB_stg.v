module WB_stg (
    input wire [7:0] inA,
    input wire [7:0] inB,
	 input wire [7:0] mux21_input,
    input wire sel,
	 input wire [1:0] register_read_Ra,
	 input wire [3:0] pipe_stg_input,
	 output wire [3:0] pipe_stg_output,
    output reg [7:0] out,
    output wire [7:0] mux21_output,
	 output wire [1:0] register_read_Ra_output);	
	

assign  mux21_output [7:0] = mux21_input[7:0];	
assign register_read_Ra_output [1:0] = register_read_Ra [1:0];
assign pipe_stg_output [3:0] = pipe_stg_input [3:0];

always@(inA,inB,sel)
begin
    if (sel == 0)
      begin
         out <= inA; // load imm
      end
    else 
      begin
         out <= inB; // everthing else
      end
end	 
endmodule