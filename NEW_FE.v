module InstructionMemory(clk,instruction);
   input clk;
   output wire [23:0] instruction;

	reg [7:0] mem[0:255];
	reg [23:0] inter_path;
	
	initial begin
			 
	mem[0] = 8'b00000000;
	mem[1] = 8'b00000000;
	mem[2] = 8'b00000000;
	mem[3] = 8'b00000000;
	mem[4] = 8'b01110000;
	mem[5] = 8'b00000000;
	mem[6] = 8'b11100000;
	mem[7] = 8'b11111111;
	mem[8] = 8'b11110000;
	mem[9] = 8'b00000111;
	mem[10] = 8'b11100000;
	mem[11] = 8'b00011111;
	mem[12] = 8'b11110000;
	mem[13] = 8'b11111111;
	mem[14] = 8'b11110100;
	mem[15] = 8'b11001111; //changed original is 8'b11111111
	mem[16] = 8'b01010000;
	mem[17] = 8'b00000000;
	mem[18] = 8'b01000100;
	mem[19] = 8'b00000000;
	mem[20] = 8'b10001100;
	mem[21] = 8'b00000000;
	mem[22] = 8'b11010000;
	mem[23] = 8'b11111111;
	mem[24] = 8'b01010000;
	mem[25] = 8'b00000000;
	mem[26] = 8'b11100000;
	mem[27] = 8'b11111111;
	mem[28] = 8'b10000011;
	mem[29] = 8'b00000000;
	mem[30] = 8'b10100000;
	mem[31] = 8'b00100100;
	mem[32] = 8'b00010001;
	mem[33] = 8'b00000000;
	mem[34] = 8'b10010000;
	mem[35] = 8'b00100110;
	mem[36] = 8'b00110001;
	mem[37] = 8'b00000000;
	mem[38] = 8'b01100000;
	mem[39] = 8'b00000000;
	mem[40] = 8'b10110000;
	mem[41] = 8'b00110100;
	mem[42] = 8'b10000011;
	mem[43] = 8'b00000000;
	mem[44] = 8'b10100100;
	mem[45] = 8'b00110000;
	mem[46] = 8'b10010000;
	mem[47] = 8'b00010000;
	mem[48] = 8'b10010000;
	mem[49] = 8'b00000100;
	mem[50] = 8'b00000000;
	mem[51] = 8'b00000000;
	mem[52] = 8'b11010000;
	mem[53] = 8'b00011111;
	mem[54] = 8'b10001001;
	mem[55] = 8'b00000000;
	mem[56] = 8'b11110100;
	mem[57] = 8'b00000001;
	mem[58] = 8'b00100001;
	mem[59] = 8'b00000000;
	mem[60] = 8'b11100000;
	mem[61] = 8'b00011111;
	mem[62] = 8'b10000110;
	mem[63] = 8'b00000000;
	mem[64] = 8'b11000000;
	mem[65] = 8'b00000000;
	
   address = 8'b00000000;
	end

	always @(posedge clk) // counter
	begin 
	if (reset != 1'b1)
	    if (address == 8'b00000000)
	    current_address <= 8'b00000000;
		 
		 else 
		 current_address <= address;
	end	 
   end
	
	
	always @(current_address) 
	begin   
	    if (reset != 1'b1)
		 inter_path = {current_address, mem[current_Address] , mem[current_address+1]}; 
	
	    assign instruction = inter_path;
	end 
		
	
	always @(instruction) //adder
	begin
	    address <= current_address + 8'b00000010;
	end 	
endmodule