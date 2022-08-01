`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/03 14:04:38
// Design Name: 
// Module Name: sll
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



module sll32(
    input wire[31:0]A,
    input wire[31:0]B,
    output reg[31:0]res
    );
    wire [4:0]num=A[4:0];
    always @* begin
     res = ( B << num );
    end
endmodule
