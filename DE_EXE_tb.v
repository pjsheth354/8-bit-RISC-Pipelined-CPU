`timescale 1ns / 1ps

module DE_EXE_stg_tb;

  reg we_rf, we_lr;           // controller
  reg [23:0] instruction;     // FE_DE reg
  reg [7:0] data;             // WB MUX
  reg Z, N;                   // controller
  reg reset;                  // controller
  wire [7:0] Ra, Rb, R0, R1, R2, R3;           // DE_EX reg
  wire [7:0] return_address;   // FE MUX
  wire [3:0] pipe_stg_output;
  wire [7:0] address_output;

  // Instantiate your module
  DE_stg dut (
    .we_rf(we_rf),
    .we_lr(we_lr),
    .instruction(instruction[23:0]),
    .data(data[7:0]),
    .Z(Z),
    .N(N), 
    .reset(reset),
    .Ra(Ra[7:0]),
    .Rb(Rb[7:0]),
    .R0(R0[7:0]),
    .R1(R1[7:0]),
    .R2(R2[7:0]),
    .R3(R3[7:0]),
    .return_address(return_address[7:0]),
    .pipe_stg_output(pipe_stg_output[3:0]),
    .address_output(address_output[7:0])
  );
	 
  initial begin
    we_rf = 1'b0;
    reset = 1'b1;
    #20;
    we_lr = 1'b1;
    we_rf = 1'b1;
    reset = 1'b0;
    #20;
    data = 8'b00110011; // random number
    Z = 1'b0;
    N = 1'b0;
    #10;
    instruction = 24'b000000001101000000000000; // load in r0
    data = 8'b00000001; // random number
    #10;
    instruction = 24'b000000001101010000000000; // load in r1
    data = 8'b00000011; // random number
    #10;
    instruction = 24'b000000001101100000000000; // load in r2
    data = 8'b00000111; // random number
    #10;
    instruction = 24'b000000001111110011100111; // loadimm in r3 this value 
    data = 8'b00000001; // random number
    #10;
/*    instruction = 24'b000000101001000000010000; // br
    data = 8'b11001100; // random number 
    #10;
    instruction = 24'b000000101001100000011000; // br
    data = 8'b11111100; 
    #10;
    instruction = 24'b000000101011000011011010; // br sub
    data = 8'b00001100; 
    #10;*/
    instruction = 24'b000000000001111000000000; // add
    data = 8'b11011100; 
    #10;
    instruction = 24'b000000000010100000000000; // sub
    data = 8'b00000100; 
    #10;
    instruction = 24'b000000000010100000000000; // add
    data = 8'b00000100; 
    #10;
    instruction = 24'b000000000010100000000000; // sub
    data = 8'b00000100; 
    #10;
    instruction = 24'b000000000010100000000000; // add
    data = 8'b00000100; 
    #10;
    instruction = 24'b000000000010100000000000; // sub
    data = 8'b00000100; 
    #10;
    instruction = 24'b000011111000110000000000; // mov
    data = 8'b01100110;
  end
endmodule
