module twenty_bit_counter (
    input wire clk,
	 input wire reset,
    output wire final_clk,
	 output reg reset_output
);

reg [19:0] inter_count;


	


always @(posedge clk) begin
    if (reset == 1'b1)
    inter_count <= 19'b0;
	 else
    inter_count <= inter_count + 1'b1;
end

assign final_clk = inter_count [19];
  
endmodule
