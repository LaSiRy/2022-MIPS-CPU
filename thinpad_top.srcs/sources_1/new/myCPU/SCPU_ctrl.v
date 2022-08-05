`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/04 16:33:02
// Design Name: 
// Module Name: SCPU_ctrl
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
module SCPU_ctrl(
    input wire rst,
    input wire[5:0]OPcode, //inst[31:26]
    input wire[5:0]Func6,  //inst[5:0]
    input wire Ctrl_Z,
    output reg [2:0]ImmSel,
    output reg ALUSrc_B,//ALUB输入数据选择?0:rs2,1:imm
    output reg ALUSrc_A,//ALUA输入数据选择?0:rs1,1:imm
    output reg [1:0]MemtoReg,//0:ALU,1:Mem,2:PC+8 3:lui
    output reg isBranch,
    output reg is_jl,
    output reg is_jr,
    output reg RegWrite,//1:regeiter写
    output reg MemR,//Mem读
    output reg MemW,//Mem写
    output reg [1:0]mem_op,//Mem操作
    output reg [3:0]ALU_Control,//ALU操作
    output reg [2:0]Comp_ctrl
    
    );
    always @* begin
    if(rst==1'b1)begin
       isBranch<=0;
       RegWrite<=0;
       MemR<=0;
       MemW<=0;
       is_jl<=0;
       is_jr<=0;
    end
    else begin
        case(OPcode)
        `LW: begin //lw
                 ALUSrc_B<=1'b1;
                 ALUSrc_A<=0;
                 RegWrite<=1'b1&Ctrl_Z;
                 MemR<=1'b1&Ctrl_Z;
                 MemW<=0;
                 mem_op<=`mem_sel_LW;
                 ImmSel<=0;
                 ALU_Control<=`ALU_ADDU;
                 MemtoReg<=2'b01;
                 isBranch<=0;
                 is_jl<=0;
                 is_jr<=0;
                end
        `LB:begin //lb
                 ALUSrc_B<=1'b1;
                 ALUSrc_A<=0;
                 RegWrite<=1'b1&Ctrl_Z;
                 MemR<=1'b1&Ctrl_Z;
                 MemW<=0;
                 mem_op<=`mem_sel_LB;
                 ImmSel<=0;
                 ALU_Control<=`ALU_ADDU;
                 MemtoReg<=2'b01;
                 isBranch<=0;
                 is_jl<=0;
                 is_jr<=0;
                end
        `ANDI: begin//andi
               ALUSrc_B<=1'b1;
               ALUSrc_A<=0;
               RegWrite<=1'b1&Ctrl_Z;
               MemR<=0;
               MemW<=0;
               MemtoReg<=0;
               ImmSel<=3'b001;
               isBranch<=0;
               is_jl<=0;
               is_jr<=0;
               ALU_Control<=`ALU_AND;
               end
        `ORI:  begin//ori
               ALUSrc_B<=1'b1;
               ALUSrc_A<=0;
               RegWrite<=1'b1&Ctrl_Z;
               MemR<=0;
               MemW<=0;
               MemtoReg<=0;
               ImmSel<=3'b001;
               isBranch<=0;
               is_jl<=0;
               is_jr<=0;
               ALU_Control<=`ALU_OR;
               end
        `XORI: begin//xori
               ALUSrc_B<=1'b1;
               ALUSrc_A<=0;
               RegWrite<=1'b1&Ctrl_Z;
               MemR<=0;
               MemW<=0;
               MemtoReg<=0;
               ImmSel<=3'b001;
               isBranch<=0;
               is_jl<=0;
               is_jr<=0;
               ALU_Control<=`ALU_XOR;
               end
        `SLTI: begin//slti
               ALUSrc_B<=1'b1;
               ALUSrc_A<=0;
               RegWrite<=1'b1&Ctrl_Z;
               MemR<=0;
               MemW<=0;
               MemtoReg<=0;
               ImmSel<=0;
               isBranch<=0;
               is_jl<=0;
               is_jr<=0;
               ALU_Control<=`ALU_SLT;
               end
        `ADDIU: begin//addiu
                ALUSrc_B<=1'b1;
                ALUSrc_A<=0;
                RegWrite<=1'b1&Ctrl_Z;
                MemR<=0;
                MemW<=0;
                MemtoReg<=0;
                ImmSel<=0;
                isBranch<=0;
                is_jl<=0;
                is_jr<=0;
                ALU_Control<=`ALU_ADDU;
                end
        `SW:begin //sw
                 ALUSrc_B<=1'b1;
                 ALUSrc_A<=0;
                 RegWrite<=0;
                 MemW<=1'b1&Ctrl_Z;
                 MemR<=0;
                 mem_op<=`mem_sel_SW;
                 ImmSel<=0;
                 ALU_Control<=`ALU_ADDU;
                 isBranch<=0;
                 is_jl<=0;
                 is_jr<=0;
                 end 
        `SB:begin //sb
                 ALUSrc_B<=1'b1;
                 ALUSrc_A<=0;
                 RegWrite<=0;
                 MemW<=1'b1&Ctrl_Z;
                 MemR<=0;
                 mem_op<=`mem_sel_SB;
                 ImmSel<=0;
                 ALU_Control<=`ALU_ADDU;
                 isBranch<=0;
                 is_jl<=0;
                 is_jr<=0;
                 end
        `OP: begin //add,addu,sub,sll,slt,xor,srl,sra,or,and
                 MemW<=0;
                 MemR<=0;
                 isBranch<=0;
                case(Func6) 
                  `OP_ADDU:begin
                    ALUSrc_B<=0;
                    ALUSrc_A<=0;
                    ALU_Control<=`ALU_ADDU;  
                    MemtoReg<=0;
                    RegWrite<=1'b1&Ctrl_Z;
                    is_jl<=0;
                    is_jr<=0;
                    end 
                  `OP_SLT:begin
                    ALUSrc_B<=0;
                    ALUSrc_A<=0;
                    ALU_Control<=`ALU_SLT;
                    MemtoReg<=0;
                    RegWrite<=1'b1&Ctrl_Z;
                    is_jl<=0;
                    is_jr<=0;
                    end
                  `OP_XOR:begin
                    ALUSrc_B<=0;
                    ALUSrc_A<=0;
                    ALU_Control<=`ALU_XOR;
                    MemtoReg<=0;
                    RegWrite<=1'b1&Ctrl_Z;
                    is_jl<=0;
                    is_jr<=0;
                    end
                  `OP_SLL:begin
                    ALUSrc_B<=0;
                    ALUSrc_A<=1'b1;
                    ImmSel<=3'b101;
                    ALU_Control<=`ALU_SLL;
                    MemtoReg<=0;
                    RegWrite<=1'b1&Ctrl_Z;
                    is_jl<=0;
                    is_jr<=0;
                    end
                  `OP_SRL:begin
                    ALUSrc_B<=0;
                    ALUSrc_A<=1'b1;
                    ImmSel<=3'b101;
                    ALU_Control<=`ALU_SRL; 
                    MemtoReg<=0;
                    RegWrite<=1'b1&Ctrl_Z;
                    is_jl<=0;
                    is_jr<=0;
                    end
                  `OP_SRA:begin
                    ALUSrc_B<=0;
                    ALUSrc_A<=1'b1;
                    ImmSel<=3'b101;
                    ALU_Control<=`ALU_SRA;  
                    MemtoReg<=0;
                    RegWrite<=1'b1&Ctrl_Z;
                    is_jl<=0;
                    is_jr<=0;
                    end
                  `OP_OR:begin
                    ALUSrc_B<=0;
                    ALUSrc_A<=0;
                    ALU_Control<=`ALU_OR;
                    MemtoReg<=0;
                    RegWrite<=1'b1&Ctrl_Z;
                    is_jl<=0;
                    is_jr<=0;
                    end
                  `OP_AND:begin
                    ALUSrc_B<=0;
                    ALUSrc_A<=0;
                    ALU_Control<=`ALU_AND;
                    MemtoReg<=0;
                    RegWrite<=1'b1&Ctrl_Z;
                    is_jl<=0;
                    is_jr<=0;
                    end
                  `OP_SRLV:begin
                    ALUSrc_B<=0;
                    ALUSrc_A<=0;
                    ALU_Control<=`ALU_SRL;
                    MemtoReg<=0;
                    RegWrite<=1'b1&Ctrl_Z;
                    is_jl<=0;
                    is_jr<=0;
                    end
                   `OP_JR:begin
                     ALUSrc_B<=0;
                     ALUSrc_A<=0;
                     ALU_Control<=`ALU_ADDU;  
                     RegWrite<=0;
                     is_jl<=0;
                     is_jr<=1'b1&Ctrl_Z;
                    end
                    `OP_JALR:begin 
                     ALUSrc_B<=0;
                     ALUSrc_A<=0;
                     ALU_Control<=`ALU_ADDU;  
                     MemtoReg<=2'd2;
                     RegWrite<=1'b1&Ctrl_Z;
                     is_jl<=0;
                     is_jr<=1'b1&Ctrl_Z;
                   end
                  default:begin end
                  endcase
                 end 
        `LUI: begin//lui
                 RegWrite<=1'b1&Ctrl_Z;
                 MemW<=0;
                 MemR<=0;
                 ImmSel<=3'b100;
                 MemtoReg<=2'b11;
                 isBranch<=0;
                 is_jl<=0;
                 is_jr<=0;
                end
        `BEQ: begin//beq
                 ALUSrc_B<=0;
                 ALUSrc_A<=0;
                 RegWrite<=0;
                 MemW<=0;
                 MemR<=0;
                 ImmSel<=3'b010;
                 isBranch<=1'b1&Ctrl_Z;
                 is_jl<=0;
                 is_jr<=0;
                 Comp_ctrl<=`CMP_EQ;
              end
         `BNE: begin//bne
                 ALUSrc_B<=0;
                 ALUSrc_A<=0;
                 RegWrite<=0;
                 MemW<=0;
                 MemR<=0;
                 ImmSel<=3'b010;
                 isBranch<=1'b1&Ctrl_Z;
                 is_jl<=0;
                 is_jr<=0;
                 Comp_ctrl<=`CMP_NE;
              end
          `BGTZ:begin 
                 ALUSrc_B<=0;
                 ALUSrc_A<=0;
                 RegWrite<=0;
                 MemW<=0;
                 MemR<=0;
                 ImmSel<=3'b010;
                 isBranch<=1'b1&Ctrl_Z;
                 is_jl<=0;
                 is_jr<=0;
                 Comp_ctrl<=`CMP_GT;
               end
          `J:begin 
                 RegWrite<=0;
                 MemR<=0;
                 MemW<=0;
                 ImmSel<=3'b011;
                 isBranch<=0;
                 is_jl<=1'b1&Ctrl_Z;
                 is_jr<=0;
               end
          `JAL:begin 
                 RegWrite<=1'b1&Ctrl_Z;
                 MemtoReg<=2'd2;
                 MemR<=0;
                 MemW<=0;
                 ImmSel<=3'b011;
                 isBranch<=0;
                 is_jl<=1'b1&Ctrl_Z;
                 is_jr<=0;
               end
          `MUL:begin 
                ALUSrc_B<=0;
                ALUSrc_A<=0;
                RegWrite<=1'b1&Ctrl_Z;
                MemR<=0;
                MemW<=0;
                MemtoReg<=0;
                isBranch<=0;
                is_jl<=0;
                is_jr<=0;
                ALU_Control<=`ALU_MUL;
               end
        default: begin 
                  RegWrite<=0;
                  MemR<=0;
                  MemW<=0;
                  isBranch<=0;
                  is_jl<=0;
                  is_jr<=0;
               end
        endcase
      end
    end
endmodule
