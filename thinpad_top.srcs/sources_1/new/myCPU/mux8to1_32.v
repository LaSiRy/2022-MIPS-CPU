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
`include "Defines.vh"

module mux8to1_32(
    input wire[31:0] I0,
    input wire[31:0] I1,
    input wire[31:0] I2,
    input wire[31:0] I3,
    input wire[31:0] I4,
    input wire[31:0] I5,
    input wire[31:0] I6,
    input wire[31:0] I7,
    input wire[31:0] I8,
    input wire[31:0] I9,
    //input wire[31:0] I10,
    input wire[3:0] select,
    output reg [31:0]res
    );

    always @(*)begin
    case(select)
    `ALU_ADDU :res=I0;
    `ALU_SUBU:res=I1;
    `ALU_SLL:res=I2;
    `ALU_SLT:res=I3;
    `ALU_MUL:res=I4;
    `ALU_XOR:res=I5;
    `ALU_SRL:res=I6;
    `ALU_SRA:res=I7;
    `ALU_OR:res=I8;
    `ALU_AND:res=I9;
    default:res=32'b0;
    endcase
    end
endmodule
