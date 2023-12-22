module CPU8(input wire clk,
            input wire master_reset,
				output wire [7:0] final_output);

		      wire twenty_bit_clk;
twenty_bit_counter twenty_bit_counter1 (.clk(clk),
                                        .final_clk(twenty_bit_clk),
													 .reset(master_reset));
												
				
CPU8_blk CPU8_blk1 (.clk(twenty_bit_clk),
                    .master_reset(master_reset),
						  .final_output(final_output[7:0]));
endmodule
						  

				
