module testbench_FE_stg;

  // Inputs
  reg [15:0] input_data_bit;
  reg [7:0] s3;
  reg s4, s6;

  // Outputs
  wire [23:0] output_instructions;

  // Instantiate the module under test
  FE_stg UUT (
    .input_data_bit(input_data_bit),
    .s3(s3),
    .s4(s4),
    .s6(s6),
    .output_instructions(output_instructions)
  );

  
  initial begin
	 s6 = 1'b1;
	 #50;
	 s6 = 1'b0;
	 s4 = 1'b0;
	 s3 = 8'b000011111;
    input_data_bit = 16'b00001111111100000; 
	 s4 = 1'b1;
	 #10;
	 input_data_bit = 16'b00001111111100011;
    #10;
	 input_data_bit = 16'b00000111111101100;
	 #10;
	 #1000;
    $finish;
  end

endmodule
