module FE_DE_reg( 
    input clk,
    input [23:0] reg_in,
	 output reg [23:0] reg_out);

	 

	 
always @ (negedge clk)
begin
reg_out [23:0] <= reg_in [23:0];

end
endmodule
	 