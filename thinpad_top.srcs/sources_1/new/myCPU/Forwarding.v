`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/12 11:05:42
// Design Name: 
// Module Name: Forwarding
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

//forwarding: alu_res -> alu, wb -> alu
module Forwarding(
    input wire EXMEM_WB,
    input wire MEMWB_WB,
    input wire preMEM_WB,
    input wire[4:0]rs1,
    input wire[4:0]rs2,
    input wire[4:0]EXMEM_rd,
    input wire[4:0]MEMWB_rd,
    input wire[4:0]preMEM_rd,
    input wire ALUSrc_B, //idex aluscr_b
    input wire ALUSrc_A, //idex aluscr_a
    input wire[31:0]IDEX_rs1,
    input wire[31:0]IDEX_rs2,
    input wire[31:0]Imm,
    input wire[31:0]EXMEM_Alu,//EX_alu
    input wire[31:0]EXMEM_pc,//EX_pc
    input wire[31:0]EXMEM_lui,//EX_lui
    input wire[1:0]EXMEM_RegWrite,//choose which
    input wire[31:0]preMEM_pc,//premem_pc
    input wire[31:0]preMEM_lui,//premem_lui
    input wire[31:0]preMEM_rdval,//premem_alu
    input wire[1:0]preMEM_RegWrite,//choose which
    input wire[31:0]WB_rdval,//WB
    //////////
    output reg [31:0]ALU_Scr1,
    output reg [31:0]ALU_Scr2 
    );
  always @(*) begin
    //rs1
    if(ALUSrc_A)ALU_Scr1<=Imm;
    else if(rs1 == EXMEM_rd && rs1 != 0)begin
        if(EXMEM_WB) begin
            case(EXMEM_RegWrite)
              2'b0: ALU_Scr1 <= EXMEM_Alu;
              2'b10: ALU_Scr1 <= EXMEM_pc + 4'b1000;
              2'b11: ALU_Scr1 <= EXMEM_lui;
              default:begin ALU_Scr1 <= IDEX_rs1; end
            endcase
        end
        else ALU_Scr1 <= IDEX_rs1;
     end
    else if(rs1 == preMEM_rd && rs1 != 0)
        if(preMEM_WB) begin
            case(preMEM_RegWrite)
              2'b0: ALU_Scr1 <= preMEM_rdval;
              2'b10: ALU_Scr1 <= preMEM_pc + 4'b1000;
              2'b11: ALU_Scr1 <= preMEM_lui;
              default:begin ALU_Scr1 <= IDEX_rs1; end
            endcase
        end
        else ALU_Scr1 <= IDEX_rs1;
    else if(rs1 == MEMWB_rd && rs1 != 0)
        if(MEMWB_WB) 
            ALU_Scr1 <= WB_rdval;
        else ALU_Scr1 <= IDEX_rs1;
    else ALU_Scr1 <= IDEX_rs1;
    //rs2
    if(ALUSrc_B)ALU_Scr2 <= Imm;
    else if(rs2 == EXMEM_rd && rs2 != 0)begin
       if(EXMEM_WB) begin
            case(EXMEM_RegWrite)
              2'b0: ALU_Scr2 <= EXMEM_Alu;
              2'b10: ALU_Scr2 <= EXMEM_pc + 4'b1000;
              2'b11: ALU_Scr2 <= EXMEM_lui;
              default:begin ALU_Scr2 <= IDEX_rs2; end
            endcase
        end
        else ALU_Scr2 <= IDEX_rs2;
      end
    else if(rs2 == preMEM_rd && rs2 != 0)begin
        if(preMEM_WB) begin
            case(preMEM_RegWrite)
              2'b0: ALU_Scr2 <= preMEM_rdval;
              2'b10: ALU_Scr2 <= preMEM_pc + 4'b1000;
              2'b11: ALU_Scr2 <= preMEM_lui;
              default:begin ALU_Scr2 <= IDEX_rs2; end
            endcase
        end
        else ALU_Scr2 <= IDEX_rs2;
    end
    else if(rs2 == MEMWB_rd && rs2 != 0)begin
        if(MEMWB_WB) ALU_Scr2 <= WB_rdval;
        else ALU_Scr2 <= IDEX_rs2;
     end
    else ALU_Scr2 <= IDEX_rs2;
    end
endmodule
