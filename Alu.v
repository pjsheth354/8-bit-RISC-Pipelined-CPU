/*module Alu(
    input wire [7:0] Ra, 
    input wire [7:0] Rb, 
    input wire [3:0] ALUmode, 
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
parameter IN = 4'b0111;
parameter MOV = 4'b1000;

parameter LOAD = 4'b1101;
parameter STORE = 4'b1110;
parameter LOADIMM = 4'b1111;

// Intermediate wires
reg [8:0] ALUresult;
reg zeroFlag;
reg negativeFlag;

always @* begin
    // ALU operations
    case (ALUmode)
        ADD: ALUresult = Ra + Rb;
        SUB: ALUresult = Ra - Rb;
        NAND: ALUresult = ~ (Ra & Rb);
        SHL: ALUresult = Ra << Rb[3:0];
        SHR: ALUresult = Ra >> Rb[3:0];
        OUT: ALUresult = Ra;
        IN: ALUresult = Rb;
        MOV: ALUresult = Rb;
        NOP: ALUresult = 8'b0;
        LOAD, STORE, LOADIMM: ALUresult = Ra;
    endcase
end

// Zero flag
assign Z = (ALUresult == 8'b0) ? 1'b1 : 1'b0;

// Negative flag
assign N = ALUresult[7];

// Output
assign Out = ALUresult[7:0];

endmodule*/
