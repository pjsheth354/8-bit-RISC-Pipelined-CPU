module C(
   input wire clk,
   input wire we,
   input wire [15:0] opcode,
   input wire [7:0] data,
   input wire reset,
   output reg [7:0] Ra,
   output reg [7:0] Rb
);
   reg [7:0] R0; 
	reg [7:0] R1; 
	reg [7:0] R2; 
	reg [7:0] R3;

   always @(negedge clk)
   begin
      // load operations
      if(we) begin	
         if (opcode[15:12] == 4'b1101) begin
            case (opcode[11:10])
               2'b00: R0 <= data;
               2'b01: R1 <= data;
               2'b10: R2 <= data;
               2'b11: R3 <= data; 
            endcase
			end
			else if (opcode[15:12] == 4'b1111) begin
			   case (opcode[11:10])
		         2'b00: R0 <= opcode[7:0] ;
               2'b01: R1 <= opcode[7:0] ;
               2'b10: R2 <= opcode[7:0] ;
               2'b11: R3 <= opcode[7:0] ;
			   endcase
		  	end
      end
       
 
      // a format operations and store operation
      if ((opcode[15:12] == 4'b0001) | (opcode[15:12] == 4'b0010) | (opcode[15:12] == 4'b0011) | (opcode[15:12] == 4'b0100) | (opcode[15:12] == 4'b0101) | (opcode[15:12] == 4'b0110) |(opcode[15:12] == 4'b0111 )) begin
         case (opcode[11:10])
            2'b00: Ra <= R0;
            2'b01: Ra <= R1;
            2'b10: Ra <= R2;
            2'b11: Ra <= R3;
         endcase
	  
         if ((opcode[15:12] == 4'b0001) | (opcode[15:12] == 4'b0010) | (opcode[15:12] == 4'b0011)) begin
            case (opcode[9:8])
               2'b00: Rb <= R0;
               2'b01: Rb <= R1;
               2'b10: Rb <= R2;
               2'b11: Rb <= R3;
            endcase  
         end
      end
   end
endmodule
