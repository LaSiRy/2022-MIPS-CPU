`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/04 16:20:22
// Design Name: 
// Module Name: PCreg32
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

//PC
module PCreg32(
    input wire clk,
    input wire rst,
    input wire[31:0]PC,
    input wire[31:0]imm,
    input wire[31:0]jump_reg_pc,
    input wire PCWen,
    input wire isjl,
    input wire isjr,
    input wire IDEX_Branch,
    input wire EXpreMEM_Branch,
    input wire preMEM_Branch,    
    input wire compres,
    output reg[31:0] pre_pc,
    output reg [31:0]PC_out
    );
    reg [31:0]trans_pc;//×ªÒÆ
    wire [31:0]PC_imm;
    wire [31:0]PC_jump;
    assign PC_imm = PC + imm; 
    assign PC_jump = {PC[31:28], imm[27:0]};
 always@(posedge clk)begin
        if(rst) begin//CPUÖØÖÃ
            PC_out<=32'h80000000;
            trans_pc<=0;
            pre_pc<=0;
            end
        else if(isjl)begin
            PC_out   <=  PC_jump;
            trans_pc <= (PCWen|preMEM_Branch)? PC_out: trans_pc;
            pre_pc   <= (PCWen|preMEM_Branch)? trans_pc: pre_pc;
            end
        else if(isjr)begin
            PC_out   <= jump_reg_pc;
            trans_pc <= (PCWen|preMEM_Branch)? PC_out: trans_pc;
            pre_pc   <= (PCWen|preMEM_Branch)? trans_pc: pre_pc;
            end
        else if(IDEX_Branch)begin
              if(compres)begin
                PC_out   <= PC_imm+3'b100;
                trans_pc <= (PCWen|preMEM_Branch)? PC_out: trans_pc;
                pre_pc   <= (PCWen|preMEM_Branch)? trans_pc: pre_pc;
              end
              else begin
                PC_out   <= (PCWen|preMEM_Branch)? PC_out+3'b100: PC_out;
                trans_pc <= (PCWen|preMEM_Branch)? PC_out: trans_pc;
                pre_pc   <= (PCWen|preMEM_Branch)? trans_pc: pre_pc;
              end
            end
        else if(EXpreMEM_Branch)begin
            PC_out   <= PC_out + 3'b100;
            trans_pc <= PC_out;
//            pre_pc   <= trans_pc;
        end
        else if(PCWen==1'b1|preMEM_Branch)begin
            PC_out   <= PC_out + 3'b100;
            trans_pc <= PC_out;
            pre_pc   <= trans_pc;
            end
        else begin end
        end
        
        
endmodule
