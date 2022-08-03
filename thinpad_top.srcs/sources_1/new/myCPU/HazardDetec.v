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


module HazardDetec(
    input wire rst,
    //Date Hazard
    input wire[4:0]IFID_rs1,
    input wire[4:0]IFID_rs2,
    input wire IDEX_MR,
    input wire IDEX_MW,
    input wire IFID_sw,
    input wire IFID_lw,
    input wire[4:0]IDEX_rd,
    input wire[4:0]EXpreMEM_rd,//only used in ... sw 
    input wire[4:0]preMEM_rd,//only used in ... sw 
    input wire EXpreMEM_MR,
    input wire EXpreMEM_MW,
    //Control Hazard
    input wire IFID_Branch,
    input wire IDEX_Branch,
    input wire IFID_Jump,
    input wire IDEX_Jump, 
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
        // else if(IDEX_MR|IDEX_MW|EXpreMEM_MR|EXpreMEM_MW)begin
        //  data_hazard<=0;
        //  control_hazard<=0;//lw-use
        // end
        else if(IDEX_rd!=0&&(IFID_rs1==IDEX_rd|IFID_rs2==IDEX_rd)&&IDEX_MR)begin
         data_hazard<=0;
         control_hazard<=0;//lw-use
        end
        else if(EXpreMEM_rd!=0&&(IFID_rs1==EXpreMEM_rd|IFID_rs2==EXpreMEM_rd)&&EXpreMEM_MR)begin
         data_hazard<=0;
         control_hazard<=0;//lw-use
        end
        else if(IDEX_rd!=0&&(IFID_rs1==IDEX_rd|IFID_rs2==IDEX_rd)&&IFID_sw)begin
         data_hazard<=0;
         control_hazard<=0;//xxx-sw
        end 
        else if(EXpreMEM_rd!=0&&(IFID_rs1==EXpreMEM_rd|IFID_rs2==EXpreMEM_rd)&&IFID_sw)begin
         data_hazard<=0;
         control_hazard<=0;//xxx-sw
        end 
        else if(preMEM_rd!=0&&IFID_rs2==preMEM_rd&&IFID_sw)begin
         data_hazard<=0;
         control_hazard<=0;//xxx-sw
        end 
        else if(IDEX_rd!=0&&(IFID_rs1==IDEX_rd|IFID_rs2==IDEX_rd)&&IFID_lw)begin
         data_hazard<=0;
         control_hazard<=0;//xxx-lw
        end 
        else if(EXpreMEM_rd!=0&&(IFID_rs1==EXpreMEM_rd|IFID_rs2==EXpreMEM_rd)&&IFID_lw)begin
         data_hazard<=0;
         control_hazard<=0; //xxx-lw
        end 
        else if(EXpreMEM_Branch|preMEM_Branch)begin//
         data_hazard<=0;
         control_hazard<=1'b1;
        end   
        else begin
         data_hazard<=1'b1;
         control_hazard<=1'b1;
       end
    end
endmodule
