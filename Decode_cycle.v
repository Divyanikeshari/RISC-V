// This page include code for decode cyle inculding all the module instantiate with it
// Please find the associated module below the main module of decode cycle


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.06.2025 22:04:49
// Design Name: 
// Module Name: Decode_Cycle
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Decode_Cycle(clk, rst, InstrD, PCD, PCPlus4D,RegWriteW, RDW, ResultW,
                     ZeroE, ResultSrcE, MemWriteE, ALUSrcE, RegWriteE, 
                     PCSrcE, ALUControlE, RD1_E, RD2_E, ImmExtE,RdE, PCPlus4E, 
                     PCE, Rs1E, Rs2E,Rs1D_out, Rs2D_out, RdD_out);

input [31:0] InstrD, PCD, PCPlus4D, RDW, ResultW;
input clk, rst, RegWriteW, ZeroE;

output ResultSrcE, MemWriteE, ALUSrcE, RegWriteE, PCSrcE;
output [2:0] ALUControlE;
output [31:0] RD1_E, RD2_E, ImmExtE, PCPlus4E, PCE;
output [4:0] RdE; 
output [4:0] Rs1D_out, Rs2D_out, RdD_out;
output [4:0] Rs1E, Rs2E;


wire ResultSrcD, MemWriteD, ALUSrcD, RegWriteD, PCSrcD;
wire [2:0] ALUControlD;
wire [1:0] ImmSrcD;
wire [31:0] RD1_D, RD2_D, ImmExtD;
wire [4:0] regfile_a1, regfile_a2;

reg ResultSrcD_r, MemWriteD_r, ALUSrcD_r, RegWriteD_r, PCSrcD_r;
reg [2:0] ALUControlD_r;
reg [31:0] RD1_D_r, RD2_D_r, ImmExtD_r, PCPlus4D_r, PCD_r;
reg [4:0] RdD_r, Rs1D_r, Rs2D_r;


control_unit ctrl_block (
                        .Zero(ZeroE), 
                        .op(InstrD[6:0]), 
                        .funct3(InstrD[14:12]), 
                        .funct7_5(InstrD[30]), 
                        .PCSrc(PCSrcD), 
                        .ResultSrc(ResultSrcD), 
                        .MemWrite(MemWriteD), 
                        .ALUSrc(ALUSrcD), 
                        .ImmSrc(ImmSrcD), 
                        .RegWrite(RegWriteD), 
                        .ALUControl(ALUControlD)
                        );
 
                        
assign regfile_a1 = InstrD[19:15];
assign regfile_a2 = InstrD[24:20];

assign Rs1D_out = InstrD[19:15];
assign Rs2D_out = InstrD[24:20];
assign RdD_out = InstrD[11:7];

register_file reg_file (
    .A1(regfile_a1), 
    .A2(regfile_a2), 
    .A3(RDW), 
    .WE3(RegWriteW), 
    .WD3(ResultW), 
    .CLK(clk), 
    .RST(rst), 
    .RD1(RD1_D), 
    .RD2(RD2_D)
);
                                
              
Sign_extension extend_block (
                            .in(InstrD), 
                            .out(ImmExtD), 
                            .ImmSrc(ImmSrcD[0])
                            );


always @ (posedge clk or negedge rst) begin
    if (rst == 1'b0) begin
        ResultSrcD_r <= 1'b0;
        MemWriteD_r <= 1'b0;
        ALUSrcD_r <= 1'b0;
        RegWriteD_r <= 1'b0;
        PCSrcD_r <= 1'b0;
        ALUControlD_r <= 3'b000;
        RD1_D_r <= 32'h00000000;
        RD2_D_r <= 32'h00000000;
        ImmExtD_r <= 32'h00000000; 
        RdD_r <= 5'b00000;
        PCD_r <= 32'h00000000;
        PCPlus4D_r <= 32'h00000000;
        Rs1D_r <= 5'b00000;
        Rs2D_r <= 5'b00000;
    end
    else begin
        ResultSrcD_r <= ResultSrcD;
        MemWriteD_r <= MemWriteD;
        ALUSrcD_r <= ALUSrcD;
        RegWriteD_r <= RegWriteD;
        PCSrcD_r <= PCSrcD;
        ALUControlD_r <= ALUControlD;
        RD1_D_r <= RD1_D;
        RD2_D_r <= RD2_D;
        ImmExtD_r <= ImmExtD; 
        RdD_r <= InstrD[11:7];
        PCD_r <= PCD;
        PCPlus4D_r <= PCPlus4D;
        Rs1D_r <= InstrD[19:15];
        Rs2D_r <= InstrD[24:20]; 
    end
end

assign ResultSrcE = ResultSrcD_r;
assign MemWriteE = MemWriteD_r;
assign ALUSrcE = ALUSrcD_r;
assign RegWriteE = RegWriteD_r;
assign PCSrcE = PCSrcD_r;
assign ALUControlE = ALUControlD_r;
assign RD1_E = RD1_D_r;
assign RD2_E = RD2_D_r;
assign ImmExtE = ImmExtD_r;
assign RdE = RdD_r;
assign PCE = PCD;
assign PCPlus4E = PCPlus4D;
assign Rs1E = Rs1D_r;
assign Rs2E = Rs2D_r;

endmodule


//**********************************************************************************************************************//

//*************************************     CONTROL_UNIT      **********************************************************//

//**********************************************************************************************************************//

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2025 00:45:35
// Design Name: 
// Module Name: Control_Unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module control_unit(Zero, op, funct3, funct7_5, PCSrc, ResultSrc, MemWrite, ALUSrc, ImmSrc, RegWrite,ALUOp, ALUControl);
input Zero, funct7_5;
input [6:0] op;
input [2:0] funct3;

output PCSrc, ResultSrc, MemWrite, ALUSrc, RegWrite;
output [1:0] ImmSrc, ALUOp;
output [2:0] ALUControl; 


wire [1:0] aluop;
wire Branch;

main_decoder main_decoder_module(
                            .Zero(Zero), 
                            .op(op),
                            .Branch(Branch), 
                            .ResultSrc(ResultSrc), 
                            .MemWrite(MemWrite),
                            .ALUSrc(ALUSrc),
                            .ImmSrc(ImmSrc), 
                            .RegWrite(RegWrite), 
                            .ALUOp(aluop)
                            );

ALU__Decoder alu_decoder_module (
                                .op_5(op[5]), 
                                .funct3(funct3), 
                                .funct7_5(funct7_5), 
                                .ALUOp(aluop), 
                                .ALUControl(ALUControl)
                                );

assign PCSrc = Branch & Zero;

endmodule


//*************************************     MAIN_DECODER      **********************************************************//

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.06.2025 10:48:30
// Design Name: 
// Module Name: main_decoder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module main_decoder(Zero, op, Branch, ResultSrc, MemWrite,ALUSrc,ImmSrc, RegWrite, ALUOp);
input Zero;
input [6:0] op;
output RegWrite, ALUSrc, MemWrite, ResultSrc, Branch;
output [1:0] ImmSrc, ALUOp;

wire [31:0] PCSrc; 

assign RegWrite = ((op == 7'b0000011) | (op == 7'b0110011)) ? 1'b1 : 1'b0;
assign ALUSrc = ((op == 7'b0000011) | (op == 7'b0100011)) ? 1'b1 : 1'b0;
assign MemWrite = (op == 7'b0100011) ? 1'b1 : 1'b0;
assign ResultSrc = (op == 7'b0000011) ? 1'b1 : 1'b0;
assign Branch = (op == 7'b1100011) ? 1'b1 : 1'b0;
assign ImmSrc = (op == 7'b0100011) ? 2'b01 : (op == 7'b1100011) ? 2'b10 :2'b00;
assign ALUOp = (op == 7'b0110011) ? 2'b10 : (op == 7'b1100011) ? 2'b01 : 2'b00;

assign PCSrc = Zero & Branch;
 
endmodule


//*************************************     ALU_DECODER      **********************************************************//

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.06.2025 12:28:32
// Design Name: 
// Module Name: ALU_Decoder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU__Decoder(op_5, funct3, funct7_5, ALUOp, ALUControl);
input op_5;
input [2:0] funct3;
input funct7_5;
input [1:0] ALUOp;
output reg [2:0] ALUControl;

wire [1:0] concatenation;

assign concatenation = {op_5 , funct7_5};


always @(*) begin
    case (ALUOp)
      2'b00: ALUControl = 3'b000;  // ADD for load/store
      2'b01: ALUControl = 3'b001;  // SUB for BEQ
      2'b10: begin
        case (funct3)
          3'b000: ALUControl = (concatenation == 2'b11) ? 3'b001 : 3'b000; // ADD or SUB
          3'b111: ALUControl = 3'b010; // AND
          3'b110: ALUControl = 3'b011; // OR
          3'b100: ALUControl = 3'b100; // XOR
          3'b010: ALUControl = 3'b101; // SLT
          3'b001: ALUControl = 3'b110; // SLL
          3'b101: ALUControl = 3'b111; // SRL
          default: ALUControl = 3'b000;
        endcase
      end
      default: ALUControl = 3'b000;
    endcase
  end
endmodule


//**********************************************************************************************************************//

//*************************************    REGISTER_MEMORY    **********************************************************//

//**********************************************************************************************************************//


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.06.2025 15:28:25
// Design Name: 
// Module Name: Register_File
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module register_file(A1, A2, A3, WE3, WD3, CLK, RST, RD1, RD2);
input [4:0] A1, A2, A3;
input CLK,RST;
input WE3;
input [31:0] WD3;
output [31:0] RD1, RD2;

reg [31:0] mem [31:0];

// READ OPERATION
assign RD1 = (RST == 1'b1) ? mem[A1] : 32'b00000000;
assign RD2 = (RST == 1'b1) ? mem[A2] : 32'b00000000;

// WRITE OPERATION
always @(posedge CLK)
    begin
    if (WE3 == 1'b1)
        begin
        mem[A3] <= WD3;
        end
    end
 
initial begin
    mem [9] = 32'h00000020;
end

endmodule


//**********************************************************************************************************************//

//*************************************     SIGN EXTENSION    **********************************************************//

//**********************************************************************************************************************//

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.06.2025 23:59:24
// Design Name: 
// Module Name: Sign_Extension
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Sign_extension(in, out, ImmSrc);
input [31:0] in;
input ImmSrc;
output reg [31:0] out;

always @(*) begin
    if (ImmSrc == 1'b1)
        out <= {{20{in[31]}}, in[31:25], in[11:7]}; 
    else
        out <= {{20{in[31]}}, in[31:20]};           
end

endmodule
