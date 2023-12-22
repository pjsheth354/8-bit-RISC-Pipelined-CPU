`timescale 10ns / 1ps
module CPU8_tb;  
                reg clk;
                reg reset;
				    wire [7:0] final_output;


 CPU8 dut (
    .clk(clk),
    .master_reset(reset),
    .final_output(final_output[7:0])
  );					
					
					
					
initial begin 
    clk = 0;
    forever begin
    #10 clk = ~clk;
    end
end 

 initial begin
    reset = 1'b1;
    #133675;
    reset = 1'b0;
	 #136607;

  end
endmodule
