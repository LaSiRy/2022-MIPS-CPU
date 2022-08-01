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


module HazardDetec(//在实现了forwarding之后，只有xxx-sd, xxx-ld, ld-use/ld-sd,sw-lw跳转指令需要nop
    input wire rst,
    //Date Hazard
    input wire[4:0]IFID_rs1,
    input wire[4:0]IFID_rs2,
    input wire IDEX_MR,//前面是否为lw型指令
    input wire IDEX_MW,//前面是否为sw型指令
    input wire IFID_sw,//后面是否为sw型指令
    input wire IFID_lw,//后面是否是lw指令
    input wire[4:0]IDEX_rd,
    input wire[4:0]EXpreMEM_rd,//only used in ... sw 
    input wire[4:0]preMEM_rd,//only used in ... sw 
    input wire EXpreMEM_MR,
    //Control Hazard
    input wire IFID_Branch,
    input wire IDEX_Branch,
    input wire IFID_Jump,
    input wire IDEX_Jump, 
    input wire EXpreMEM_Branch,
    input wire preMEM_Branch,
    //Output，为统一，有Hazard时把相关信号置0
    output wire PCWen,//1:可写
    output wire IFIDWen,//1：可写
    output wire Contrl_zero//1:不改变 0:将IDEX所有读写信号置零
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
//        else if(IFID_Branch|IDEX_Branch|IFID_Jump|IDEX_Jump|EXpreMEM_Branch|preMEM_Branch)begin//
//         data_hazard=0;
//         control_hazard=1'b1;
//        end
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
