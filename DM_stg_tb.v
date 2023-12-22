module DM_stg_tb;

  reg [7:0] address_input;
  reg [7:0] mux21_input;
  reg [7:0] alu_input;
  reg [7:0] pipe_stg_input;
  reg we;
  reg [3:0] opcode;
  wire [7:0] datamemory_output;
  wire [7:0] datamemory_output1;
  wire [7:0] pipe_stg_output;
  wire [7:0] mux21_output;

  // Instantiate your module
  DM_stg dut (
    .address_input(address_input),
    .alu_input(alu_input),
    .mux21_input(mux21_input),
    .pipe_stg_input(pipe_stg_input),
    .we(we),
    .opcode(opcode),
    .datamemory_output(datamemory_output),
    .datamemory_output1(datamemory_output1),
    .pipe_stg_output(pipe_stg_output),
    .mux21_output(mux21_output)
  );

  initial begin
    we = 1'b0;
    #20
    we = 1'b1;
    alu_input = 8'b10101001; // random number
    address_input = 8'b00000001;
    opcode = 4'b1110; // store
    #10;
    alu_input = 8'b00011001; // random number
    address_input = 8'b00000010;
    opcode = 4'b1110; // store
    #10
    alu_input = 8'b01011101; // random number
    address_input = 8'b00000011;
    opcode = 4'b1110; // store
    #10
    alu_input = 8'b01000000; // random number
    address_input = 8'b00000001;
    opcode = 4'b1110; // store
    #10
    mux21_input = 8'b01011111;
    pipe_stg_input = 8'b01011111;
    #10
    alu_input = 8'b10101001; // random number
    address_input = 8'b00000001;
    opcode = 4'b1101; // load
    #10
    alu_input = 8'b11111111; // random number
    address_input = 8'b00000010;
    opcode = 4'b1101; // load
    #10
    alu_input = 8'b11100111; // random number
    address_input = 8'b00000011;
    opcode = 4'b1101; // load
    #10
    alu_input = 8'b11101011; // random number
    address_input = 8'b00000011;
    opcode = 4'b1001; // load
    #10
    alu_input = 8'b00000000; // random number
    address_input = 8'b10000011;
    opcode = 4'b1000; // load
  end
endmodule
