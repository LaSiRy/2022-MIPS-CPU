`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/04 15:53:57
// Design Name: 
// Module Name: immGen
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


module immGen(
    input wire[31:0] inst_field,
    input wire[2:0] ImmSel,
    output reg [31:0] Imm_out
    );
    always @* begin
    case(ImmSel)
        3'b000: Imm_out<={{16{inst_field[15]}},inst_field[15:0]};//I-TypeÎÞ·ûºÅ,LW,SW
        3'b001: Imm_out<={16'b0,inst_field[15:0]};//I-TypeÓÐ·ûºÅ£¬ori,xori,andi
        3'b010: Imm_out<={{14{inst_field[15]}},inst_field[15:0],2'b0};//Branch
        3'b011: Imm_out<={4'b0,inst_field[25:0],2'b0};//J,Jal
        3'b100: Imm_out<={inst_field[15:0],16'b0};//Lui
        3'b101: Imm_out<={27'b0,inst_field[10:6]};//sll,srl
        default: Imm_out<=0;
      endcase
    end
endmodule
