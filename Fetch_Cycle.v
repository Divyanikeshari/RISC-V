// This page include code for fetch cyle inculding all the module instantiate with it
// Please find the associated module below the main module of fetch cycle

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.06.2025 00:18:56
// Design Name: 
// Module Name: Fetch_Cycle
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


module Fetch_cycle(clk, rst, PCTargetE, PCSrcE, InstrD, PCD, PCPlus4D);

input PCSrcE, clk, rst;
input [31:0] PCTargetE;
output reg [31:0] InstrD, PCD, PCPlus4D;


wire [31:0] PCPlus4F, PCF, PC_F;
wire [31:0] InstrF;
reg [31:0] InstrF_reg, PCF_reg, PCPlus4F_reg;


Mux pc_mux1(
            .a(PCPlus4F),
            .b(PCTargetE),
            .s(PCSrcE),
            .out(PCF)
            );
            

PC pc_block(
            .clk(clk), 
            .rst(rst), 
            .PC_Next(PCF), 
            .pc(PC_F)
            );
            

pc_adder adder(
                .a(PC_F),
                .b(32'd4),
                .sum(PCPlus4F)
                );
                

                
instruction_mem instr_mem_block (
                                .A(PC_F),
                                .RD(InstrF),
                                .rst(rst)
                                ) ;
                                

                
 always @ (posedge clk or negedge rst) begin
    if (rst == 1'b0) begin
        InstrF_reg = 32'h00000000;
        PCF_reg = 32'h00000000;
        PCPlus4F_reg = 32'h00000000;
    end
    else begin
        InstrF_reg <= InstrF;
        PCF_reg <= PC_F;
        PCPlus4F_reg <= PCPlus4F ;
    end
 end  
 
 always @(*) begin
        InstrD   = InstrF_reg;
        PCD      = PCF_reg;
        PCPlus4D = PCPlus4F_reg;
    end                                              
 
            
endmodule


//**********************************************************************************************************************//

//*************************************         MUX           **********************************************************//

//**********************************************************************************************************************//

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.06.2025 21:23:24
// Design Name: 
// Module Name: MUX
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


module Mux(a,b,s,out);
input [31:0] a,b;
input s;
output [31:0] out;

assign out = (!s) ? a : b;

endmodule


//**********************************************************************************************************************//

//*************************************    PROGRAM COUNTER    **********************************************************//

//**********************************************************************************************************************//

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.06.2025 15:20:34
// Design Name: 
// Module Name: Program_counter
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


module PC(clk, rst, PC_Next, pc);
input clk, rst;
input [31:0] PC_Next;
output reg [31:0] pc;

always @(posedge clk)begin
    if (rst != 0)
        begin
        pc <= PC_Next; 
        end
    else 
        begin
        pc <= 32'h00000000;
        end 
    end

endmodule


//**********************************************************************************************************************//

//*************************************       PC_ADDER        **********************************************************//

//**********************************************************************************************************************//

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.06.2025 23:50:59
// Design Name: 
// Module Name: pc_adder
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


module pc_adder(a,b,sum);
input [31:0] a,b;
output [31:0] sum;

assign sum = a+b;
endmodule


//**********************************************************************************************************************//

//*************************************   INSTRUCTION MEMORY  **********************************************************//

//**********************************************************************************************************************//

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.06.2025 15:11:00
// Design Name: 
// Module Name: INSTRUCTION_MEMORY
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


module instruction_mem(A,RD,rst);
input [31:0] A;
input rst;
output [31:0]RD;

reg [31:0]instruct_mem [1023:0];

assign RD = rst ? instruct_mem[A] : 32'h00000000;

initial 
begin
instruct_mem [0] = 32'hFFC4A303; // LW X6, -4(X9) 
instruct_mem [4] = 32'h00832383; // LW X7, 8(X6)
instruct_mem [8] = 32'h00736233; // OR X4,X6,X7
instruct_mem [12] = 32'hFE44AE23; // SW X4, -4(X9)
instruct_mem [16] = 32'hFFC4A183; // LW X3,-4(X9)
instruct_mem [20] = 32'h007302B3; // ADD X5,X6,X7
instruct_mem [24] = 32'h00532423; // SW X5, 8(X6)
instruct_mem [28] = 32'h00832103; // LW X2, 8(X6)
end

endmodule
