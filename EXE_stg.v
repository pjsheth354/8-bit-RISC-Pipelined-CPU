module EXE_stg(
	input wire [7:0] mux41_data1,
	input wire [7:0] mux41_dataWB1,
	input wire [7:0] mux41_data2,
	input wire [7:0] mux41_dataWB2,
	input wire [7:0] mux41_dataDM1,
	input wire [7:0] mux41_dataDM2,
	input wire [7:0] address_input,
	input wire [7:0] mux21_input1,
	input wire [7:0] mux21_input2,
	input wire [3:0] pipe_stg_input,
	input wire [3:0] opcode,
	input wire [1:0] FU_sel1, FU_sel2,
	input wire Controller_sel,
	input wire [1:0] register_read_Ra,
  	input wire [1:0] register_read_Rb,
	input wire [7:0] Z_N_flag_status,
	input wire [7:0] shift_address,
	input wire reset,
	output wire [7:0] address_output,
	output wire [7:0] mux21_output,
	output wire [7:0] alu_output,
	output wire [3:0] pipe_stg_output,
	output wire Z_output,N_output,
	output wire [1:0] register_read_Ra_output,
  	output wire [1:0] register_read_Rb_output);

//Intermediate wires
wire [7:0] s1,s4;

//Not useful wires
wire [7:0] u1, u2;

//CU wires
wire [1:0] c2;


assign pipe_stg_output [3:0] = pipe_stg_input [3:0];
assign address_output = address_input;
assign register_read_Ra_output [1:0] = register_read_Ra [1:0];
assign register_read_Rb_output [1:0] = register_read_Rb [1:0];

Mux_EX_4to1 mux1(
	.out(s1), 
	.inA(mux41_data1), 
	.inB(mux41_dataWB1), 
	.inC(mux41_dataDM1), 
	.inD(u1), 
	.sel(FU_sel1)
);

Mux_EX_4to1 mux2(
	.out(s4), 
	.inA(mux41_data2), 
	.inB(mux41_dataWB2), 
	.inC(mux41_dataDM2), 
	.inD(u2), 
	.sel(FU_sel2)
);

Alu ALU_Des(
	.Ra(s1), 
   .Rb(s4), 
   .ALUmode(opcode), 
   .Z(Z_output), 
   .N(N_output), 
	.shift_address_input(shift_address[7:0]),
   .Out(alu_output),
	.Z_N_flag_status(Z_N_flag_status),
	.reset(reset)
);

Mux_EX_2to1 mux3(
	.out(mux21_output), 
	.inA(mux21_input1), 
	.inB(mux21_input2), 
	.sel(Controller_sel)
);

endmodule

//----------------------------------------------------------
module Mux_EX_4to1 (out, inA, inB, inC, inD, sel);

    output [7:0] out;
    input wire [7:0] inA;
	 input wire [7:0] inB;
	 input wire [7:0] inC;
    input wire [7:0] inD;
    input wire [1:0] sel;
	reg [7:0]out;

	always@(inA,inB,inC,inD,sel)
	begin
        if (sel == 2'b00)
            begin
            out <= inA;
            end
		  else if (sel == 2'b01)
            begin
            out <= inB;
            end
		  else if (sel == 2'b10)
            begin
            out <= inC;
            end
        else 
            begin
            out <= inD;
            end
    end	 

endmodule
//---------------------------------------------------------------------------------
module Mux_EX_2to1 (out, inA, inB, sel);

    output [7:0] out;
    input wire [7:0] inA;
    input wire [7:0] inB;
    input wire sel;
	reg [7:0]out;

	always@(inA,inB,sel)
	begin
        if (sel == 1'b0)
            begin
            out <= inA;
            end
        else 
            begin
            out <= inB;
            end
    end	 

endmodule

//-----------------------------------------------------------------------------------------
module Alu(
    input wire [7:0] Ra, 
    input wire [7:0] Rb, 
    input wire [3:0] ALUmode,
	 input wire [7:0] Z_N_flag_status,
	 input wire [7:0] shift_address_input,
	 input wire reset, 
    output wire Z, 
    output wire N, 
    output wire [7:0] Out
);

parameter NOP = 4'b0000;
parameter ADD = 4'b0001;
parameter SUB = 4'b0010;
parameter NAND = 4'b0011;
parameter SHL = 4'b0100;
parameter SHR = 4'b0101;
parameter OUT = 4'b0110;
parameter MOV = 4'b1000;
parameter LOAD = 4'b1101;
parameter STORE = 4'b1110;
parameter LOADIMM = 4'b1111;

// Intermediate wires
reg signed [8:0] ALUresult;
reg zeroFlag;
reg negativeFlag;
reg [3:0] count;
reg [3:0] count_tri;
reg [3:0] count_n;


//ALU Operations- Order1
always @(Ra,Rb,shift_address_input,zeroFlag,ALUmode) begin
    
    case (ALUmode)
        ADD: ALUresult = Ra + Rb;
        SUB: ALUresult = Ra - Rb;
        NAND: ALUresult = ~ (Ra & Rb);
        SHL: ALUresult = Ra << 1'b1;
        SHR: begin 
					if(shift_address_input == 8'b00010000) begin
						ALUresult = Ra >> 1'b1;
					end
					
					if(shift_address_input == 8'b00011000) begin
						 if (zeroFlag == 1'b1)
							 begin 
								ALUresult = Ra >> 1'b1;
							 end
						 if (zeroFlag == 1'b0)
							 begin 
								ALUresult = (Ra >> 1'b1) | 8'b10000000;
							 end
					end
				 end 
        OUT: ALUresult = Ra;
        NOP: ALUresult = 9'b0;
        LOAD: ALUresult = Ra;
		  STORE: ALUresult = Ra;
		  LOADIMM: ALUresult = Ra;
		  MOV: ALUresult = Rb;
    endcase
end

// Sequential Ordering-Order2
always @(reset,Z_N_flag_status,count, zeroFlag,count_tri,count_n,negativeFlag) begin 
	
	if (reset == 1'b1) begin
   count = 4'b0000;
	zeroFlag = 1'b1;
	negativeFlag = 1'b0;
	count_tri = 4'b0000;
	count_n = 4'b0000;
	end
	
	else begin
	
	if(Z_N_flag_status[7:4] == 4'b1010) begin
	
		if (Z_N_flag_status[2] == 1'b0) begin
			count = count + 4'b0001;
		end
		if(count > 4'b0011) begin
			zeroFlag = 0;
			count_tri = count_tri + 4'b0001;
			
			if(count_tri > 4'b0111) begin
				count = 4'b0000;
			end
		end
		if (count <= 4'b0011) begin
			zeroFlag = 1;
			count_tri = 4'b0000;
		end
		
		if (Z_N_flag_status[2] == 1'b1) begin
			count_n = count;
		end
		if (count_n == 4'b0110) begin
			negativeFlag = 1'b1;
			count_n = 4'b0;
		end
		
		if (count_n != 4'b0000) begin
			negativeFlag = 1'b0;
		end
		
		if (zeroFlag == 1'b1 & negativeFlag == 1'b1) begin
			negativeFlag = 1'b0;
		end
		
	end
end
end
//Zero Flag
assign Z = zeroFlag;

// Negative flag
assign N = negativeFlag;

// Output
assign Out = ALUresult[7:0];

endmodule
