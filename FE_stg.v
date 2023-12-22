module FE_stg (clk,instruction,reset,Z,N);
   input clk;
	input reset;
	input Z,N;
   output reg [23:0] instruction;

  
	reg [7:0] mem[0:255];
	reg [23:0] inter_path;
	reg [23:0] inter_path1;
	reg [7:0] current_address,always_address;
	wire [7:0] address; 
	reg mux_sel;
	reg [7:0] link_address;
	reg [7:0] link_register;
	reg [1:0] stall_flag;
	reg [7:0] stall_register;
	reg [7:0] stall_address;
	
	
	always @(clk) begin
			 
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
	mem[15] = 8'b11111111; //changed original is 8'b11111111
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
	mem[60] = 8'b10000110;
	mem[61] = 8'b00000000;
	mem[62] = 8'b11100000;
	mem[63] = 8'b00011111;
	mem[64] = 8'b11000000;
	mem[65] = 8'b00000000;
	end

	always @(posedge clk or posedge reset) // counter
begin 
  if (reset == 1'b1) begin
    current_address <= 8'b00000000;
  end 
  else begin 
    if (address == 8'b00000000) begin
      current_address <= 8'b00000000;
    end 
    else begin 
      if (mux_sel == 1'b0 & stall_flag == 2'b00)
        current_address <= address;
      else if (mux_sel == 1'b1)
        current_address <= link_address;
      else if (stall_flag == 2'b11 | stall_flag == 2'b01)
        current_address <= stall_address;
    end
  end
end

	
	
	always @(current_address,reset) 
	begin  
       	
	    if (reset != 1'b1) begin
		 inter_path = {current_address, mem[current_address] , mem[current_address+1]};
		 
	    instruction <= inter_path;
		 
		 if (stall_flag == 2'b11) begin
		 stall_flag = 2'b01;
		 end
		 
		 if (stall_flag == 2'b01) begin
		 @ (posedge clk)
		 stall_flag = 2'b00;
		 end
		 
		 if ((inter_path [15:12] == 4'b0100 & inter_path1 [15:12] == 4'b1000) | (inter_path [15:12] == 4'b1101 & inter_path1 [15:12] == 4'b0101) | (inter_path [15:12] == 4'b0101 & inter_path1 [15:12] == 4'b1110) | (inter_path [15:12] == 4'b1101 & inter_path1 [15:12] == 4'b0001) | (inter_path [15:12] == 4'b1000 & inter_path1 [15:12] == 4'b1111) | (inter_path [15:12] == 4'b1000 & inter_path1 [15:12] == 4'b1111) | (inter_path [15:12] == 4'b1000 & inter_path1 [15:12] == 4'b1110) | (inter_path [15:12] == 4'b1111 & inter_path1 [15:12] == 4'b0010) | (inter_path [15:12] == 4'b0011 & inter_path1 [15:12] == 4'b0110) )
		 stall_flag = 2'b11;
		 	
	    if (reset != 1'b1)
	    stall_flag <= 2'b00;		
		 
   end
	end 
	
	always @(instruction , reset) begin
	
	if (reset == 1'b1)
	mux_sel = 1'b0;
	
	if (instruction [15:12] == 4'b1011 | instruction [15:12] == 4'b1100 | instruction [15:12] == 4'b1001 | instruction [15:12] == 4'b1010) begin // everything		 			 
			 
			 if (instruction [15:12] == 4'b1011 | instruction [15:12] == 4'b1100 | instruction [15:12] == 4'b1001) begin
			   link_register <= current_address;
		      mux_sel <= 1'b1;
				if (instruction [15:12] == 4'b1011 | instruction [15:12] == 4'b1001) //br sub, br
               link_address <= instruction[7:0]; 
            else if (instruction [15:12] == 4'b1100) // return
				   link_address <= link_register + 8'b00000010;             	      	
		    end
			 
			 if (instruction [15:12] == 4'b1010) begin //brz
			 if (instruction [10] == 1'b0)begin
		      mux_sel <= 1'b1;
				if (Z == 1'b1) begin
               link_address <= instruction[7:0];	
				end
            else if (Z == 1'b0) // return
				   link_address <= current_address + 8'b00000010;  
			 end
		    end
			 
			 if (instruction [15:12] == 4'b1010) begin //brn
			 if (instruction [10] == 1'b1)begin
		      mux_sel <= 1'b1;
				if (N == 1'b1) begin
               link_address <= instruction[7:0];
				end	
            else if (N == 1'b0) // return
				   link_address <= current_address + 8'b00000010;  
			 end
		    end
			
			if (instruction [15:12] != 4'b1011 | instruction [15:12] != 4'b1100 | instruction [15:12] == 4'b1001 | instruction [15:12] != 4'b1010) //mux 0 for br.sub, br and return
			begin
			   @(posedge clk)
		      mux_sel <= 1'b0;		 
		   end
			end
	end
	
always @(instruction) begin
	
	if (stall_flag == 2'b11)begin
	   stall_register = current_address;
      stall_address = 8'b00000000;	
	end	
	if (stall_flag == 2'b01) begin// return 
		stall_address = stall_register + 8'b00000010; 
		end
end	 			

	
	
	always @(instruction) //adder
	begin
	    always_address = current_address + 8'b00000010;
	end 
		 assign address = (reset) ? 8'b00000000 : always_address ; 
	
endmodule