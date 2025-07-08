// This page include code for writeback cyle inculding all the module instantiate with it
// Please find the associated module below the main module of writeback cycle

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.06.2025 02:03:09
// Design Name: 
// Module Name: WriteBack_Cycle
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


module WriteBack_cycle(clk, rst, ResultSrcW, ALUResultW, 
                    ReadDataW, PCPlus4W, ResultW);
                    
input clk, rst, ResultSrcW;
input [31:0] ALUResultW, ReadDataW, PCPlus4W;
output [31:0] ResultW;


Mux mux(
        .a(ALUResultW),
        .b(ReadDataW),
        .s(ResultSrcW),
        .out(ResultW)
        );
endmodule



//*********************************************************************************************************//

//***********************************              MUX            *****************************************//

//*********************************************************************************************************//

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
