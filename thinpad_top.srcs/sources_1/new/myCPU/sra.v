`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/10 16:46:36
// Design Name: 
// Module Name: sra
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


module sra(
    input wire[31:0]A,
    input wire[31:0]B,
    output reg[31:0]res
    );
    always @* begin
     res = ( $signed(B) ) >>> A[4:0];
    end
endmodule
