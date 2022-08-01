`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/03 10:32:40
// Design Name: 
// Module Name: ADC32
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


module or32(
    input wire[31:0]A,
    input wire[31:0]B,
    output reg[31:0]res
    );
    always @* begin
     res = A | B;
    end
endmodule