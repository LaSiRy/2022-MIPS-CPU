`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/12 01:16:04
// Design Name: 
// Module Name: HazardDetec
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


module HazardDetec(//��ʵ����forwarding֮��ֻ��xxx-sd, xxx-ld, ld-use/ld-sd,sw-lw��תָ����Ҫnop
    input wire rst,
    //Structure Hazard
    input wire [31:0]EXpreMEM_addr,
    input wire EXpreMEM_MW,
    input wire [31:0]MEM_addr,
    input wire preMEM_MR,
    input wire preMEM_MW,
    //Date Hazard
    input wire[4:0]IFID_rs1,
    input wire[4:0]IFID_rs2,
    input wire IDEX_MR,//ǰ���Ƿ�Ϊlw��ָ��
    input wire IDEX_MW,//ǰ���Ƿ�Ϊsw��ָ��
    input wire IFID_sw,//�����Ƿ�Ϊsw��ָ��
    input wire IFID_lw,//�����Ƿ���lwָ��
    input wire[4:0]IDEX_rd,
    input wire[4:0]EXpreMEM_rd,//only used in ... sw 
    input wire[4:0]preMEM_rd,//only used in ... sw 
    input wire EXpreMEM_MR,
    //Control Hazard
    input wire IDEX_branch,
    input wire EXpreMEM_Branch,
    input wire preMEM_Branch,
    //Output��Ϊͳһ����Hazardʱ������ź���0
    output wire PCWen,//1:��д
    output wire IFIDWen,//1����д
    output wire Contrl_zero//1:���ı� 0:��IDEX���ж�д�ź�����
    );
    reg data_hazard;
    reg control_hazard;
    assign PCWen=data_hazard;
    assign IFIDWen=data_hazard;
    assign Contrl_zero=control_hazard;
    always @(*) begin
        if(rst==1'b1)begin
         data_hazard<=1'b1;
         control_hazard<=1'b1;
        end
//         else if(preMEM_addr >= 32'h80000000 && preMEM_addr <= 32'h803fffff && (preMEM_MR||preMEM_MW))begin
//         data_hazard<=0;
//         control_hazard<=0;//structure hazard
//        end
//        else if(MEM_addr >= 32'h80000000 && MEM_addr <= 32'h803fffff && (EXpreMEM_MR||EXpreMEM_MW))begin
//         data_hazard<=0;
//         control_hazard<=0;//structure hazard
//        end
        else if(IDEX_rd!=0&&(IFID_rs1==IDEX_rd||IFID_rs2==IDEX_rd)&&IDEX_MR)begin
         data_hazard<=0;
         control_hazard<=0;//lw-use
        end
        else if(EXpreMEM_rd!=0&&(IFID_rs1==EXpreMEM_rd||IFID_rs2==EXpreMEM_rd) && EXpreMEM_MR)begin
         data_hazard<=0;
         control_hazard<=0;//lw-use
        end
        else if(IDEX_MR && IFID_sw)begin
         data_hazard<=0;
         control_hazard<=0;//lw-SW
        end
        else if(IDEX_rd!=0&&IFID_rs2==IDEX_rd&&IFID_sw)begin
         data_hazard<=0;
         control_hazard<=0;//xxx-sw
        end 
        else if(EXpreMEM_rd!=0&&IFID_rs2==EXpreMEM_rd&&IFID_sw)begin
         data_hazard<=0;
         control_hazard<=0;//xxx-sw
        end 
        else if(preMEM_rd!=0&&IFID_rs2==preMEM_rd&&IFID_sw)begin
         data_hazard<=0;
         control_hazard<=0;//xxx-sw
        end 
        else if(EXpreMEM_addr >= 32'h80000000 && EXpreMEM_addr <= 32'h803fffff && (IDEX_MR|IDEX_MW))begin
         data_hazard<=0;
         control_hazard<=0;//structure hazard
        end
        else if(MEM_addr >= 32'h80000000 && MEM_addr <= 32'h803fffff && (EXpreMEM_MR|EXpreMEM_MW))begin
         data_hazard<=0;
         control_hazard<=0;//structure hazard
        end
//        else if(IDEX_rd!=0&&(IFID_rs1==IDEX_rd||IFID_rs2==IDEX_rd)&&IFID_lw)begin
//         data_hazard<=0;
//         control_hazard<=0;//xxx-lw
//        end 
//        else if(EXpreMEM_rd!=0&&(IFID_rs1==EXpreMEM_rd||IFID_rs2==EXpreMEM_rd)&&IFID_lw)begin
//         data_hazard<=0;
//         control_hazard<=0; //xxx-lw
//        end 
        else if(EXpreMEM_Branch||preMEM_Branch)begin//
         data_hazard<=0;
         control_hazard<=1'b1;
        end   
        else begin
         data_hazard<=1'b1;
         control_hazard<=1'b1;
       end
    end
endmodule
