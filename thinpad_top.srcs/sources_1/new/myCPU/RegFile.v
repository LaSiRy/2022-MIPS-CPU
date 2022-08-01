`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/10 14:57:35
// Design Name: 
// Module Name: RegFile
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

module RegFile(
//    `DBG_RegFile_Outputs
     input wire clk,
     input wire rst,
     input wire wen,
     input wire [4:0]rs1,
     input wire [4:0]rs2,
     input wire [4:0]rd,
     input wire [31:0]i_data,
     output reg [31:0]rs1_val,
     output reg [31:0]rs2_val
    );
     reg [31:0]regs[0:31];//R1-R31
    integer i;
    always @(negedge clk) begin
        if(rst==1) for(i=0;i<32;i=i+1) regs[i]=0;
        else if((rd!=0)&&(wen==1)) regs[rd]=i_data;
    end
    always @(posedge clk) begin
        if(rst==1) for(i=0;i<32;i=i+1) regs[i]=0;
        rs1_val=(rs1==0)?0:regs[rs1];
        rs2_val=(rs2==0)?0:regs[rs2];
    end
//    `DBG_RegFile_Assignments    
endmodule
