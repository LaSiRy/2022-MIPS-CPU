`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/04 15:46:09
// Design Name: 
// Module Name: DataPath
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
module DataPath(
//  `DBG_Core_Outputs
  output wire [31:0] debug_wb_pc,
  output wire [3:0]  debug_wb_rf_wen,
  output wire [4:0]  debug_wb_rf_wnum,
  output wire [31:0] debug_wb_rf_wdata,

  input wire clk,
  input wire rst,
  input wire [31:0]Data_in,
  input wire [31:0]inst_field_in,
  output wire isRead_inst,
  output wire isRead_data,
  output wire[3:0]mem_sel,
  output wire dmem_wen,
  output wire[31:0]Data_out,
  output wire[31:0]Din_addr,
  output wire[31:0]PC_out//
  );

//////////////////////////////////
  //PC
  wire  [31:0]pc;
  //preIF:
  wire  [31:0]pre_pc;
  reg stall_flag;
  reg jump_flag;
  reg [31:0]inst_field;
  reg [31:0]inst_store;
  //IFID
  reg [31:0]IFID_pc;//pc
  reg [31:0]IFID_inst;//inst;
  reg IFID_is_Delayslot;
  reg [4:0]rs1;
  reg [4:0]rs2;
  reg [4:0]rd;
  //IDEX
  reg [31:0]IDEX_pc;//pc 32 
  reg [31:0]IDEX_inst;//inst
  reg IDEX_is_Delayslot;
  reg [31:0]IDEX_Imm;//Imm 32
  wire [31:0]IDEX_rs1_val;//rs1 32
  wire [31:0]IDEX_rs2_val;//rs2 32
  reg [4:0]IDEX_rd;//rd 5
  reg IDEX_WB;
  reg IDEX_branch;
  reg IDEX_isjl;
  reg IDEX_isjr;
  reg [1:0]IDEX_MemRW;//read+write
  reg [3:0]IDEX_Aluop;
  reg [2:0]IDEX_Comop;
  reg [1:0]IDEX_mem_op;//0:lw, 1:sw, 2:lb, 3:sb
  reg IDEX_valid;
  reg IDEX_ALUSrcB;
  reg IDEX_ALUSrcA;
  reg [1:0]IDEX_RegWrite;
  //EXMEM
  reg [31:0]EXpreMEM_rs2;//rs2 32
  reg [4 :0]EXpreMEM_rd;//rd 5
  reg [31:0]EXpreMEM_Alu;//alu_res 32 
  reg [31:0]EXpreMEM_lui;//lui 
  reg [31:0]EXpreMEM_pc;//Jump:pc
  reg [31:0]EXpreMEM_inst;//inst
  reg EXpreMEM_is_Delayslot;
  reg [1:0]EXpreMEM_mem_op;
  reg EXpreMEM_branch;
  reg EXpreMEM_WB;
  reg [1:0]EXpreMEM_MemRW;//read+write
  reg [1:0]EXpreMEM_RegWrite;
  // reg EXpreMEM_isUart;
  reg EXpreMEM_valid;
  //preMEM:
  reg [31:0]preMEM_addr;
  reg [31:0]preMEM_data;//rs2
  reg [4 :0]preMEM_rd;//rd 5
  reg [31:0]preMEM_lui;//lui 
  reg [31:0]preMEM_pc;//Jump:pc
  reg [31:0]preMEM_inst;//inst
  reg [1:0]preMEM_mem_op;
  reg preMEM_WB;
  reg preMEM_branch;
  reg [1:0]preMEM_MemRW;//read+write
  reg [1:0]preMEM_RegWrite;
  // reg preMEM_isUart;
  // reg [31:0]preMEM_Datain;
  reg preMEM_valid;  
  //MEMWB
  reg [4 :0]MEMWB_rd;//rd 5
  reg [31:0]MEMWB_mem;//rd 32
  reg [31:0]MEMWB_Alu;//alu_res 32
  reg [31:0]MEMWB_lui;//lui
  reg [31:0]MEMWB_pc;//Jump:pc
  reg [31:0]MEMWB_inst;//inst
  reg [1:0]MEMWB_mem_op;
  reg MEMWB_WB;
  reg MEMWB_valid;
  reg [1:0]MEMWB_RegWrite;
///////////////////////////////////

//Control
///////////////////////  
  //Hazard
  wire PCWen;
  wire IFIDWen;
  wire Ctrl_Z;
  //ID
  wire [31:0]Immediate;
  //ID_ctrl
  wire [3:0]ALU_Control;
  wire [2:0]Comp_ctrl;
  wire isBranch;
  wire [2:0]ImmSel;
  wire [1:0]MemtoReg;
  wire RegWrite;
  wire MemW;
  wire MemR;
  wire [1:0]mem_op;
  wire is_jl;
  wire is_jr;
  wire [31:0]rs1_val;
  wire [31:0]rs2_val;
  wire ALUSrc_B;
  wire ALUSrc_A;
  //EX
  wire [31:0]ALU_res;
  wire res_comp;
  //WB
  wire [31:0]rd_val;

  wire [31:0]Alu_rs1;
  wire [31:0]Alu_rs2;
  
wire IFID_Branch = (IFID_inst[31:26]==`BEQ || IFID_inst[31:26]==`BNE || IFID_inst[31:26]==`BGTZ)?1'b1:0;
wire IFID_Jump = (IFID_inst[31:26]==`J || IFID_inst[31:26]==`JAL ||
                (IFID_inst[31:26]==`OP && IFID_inst[5:0]==`OP_JR)||
                (IFID_inst[31:26]==`OP && IFID_inst[5:0]==`OP_JALR))?1'b1:0;
wire IFID_sw = (IFID_inst[31:26]==`SW || IFID_inst[31:26]==`SB)?1'b1:0;
wire IFID_lw = (IFID_inst[31:26]==`LW || IFID_inst[31:26]==`LB)?1'b1:0;
wire inst_j = inst_field[31:26] == `JAL? 1'b1:0;
wire IFID_j = IFID_inst[31:26] == `JAL? 1'b1:0;
wire inst_con = (inst_field[31:26] == `LW || inst_field[31:26] == `LB || inst_field[31:26] == `XORI || inst_field[31:26] == `ANDI||
          inst_field[31:26] == `LUI|| inst_field[31:26] == `ORI|| inst_field[31:26] == `ADDI|| inst_field[31:26] == `ADDIU)?1'b1:0;
wire IFID_con = (IFID_inst[31:26] == `LW || IFID_inst[31:26] == `LB || IFID_inst[31:26] == `XORI || IFID_inst[31:26] == `ANDI||
          IFID_inst[31:26] == `LUI|| IFID_inst[31:26] == `ORI|| IFID_inst[31:26] == `ADDI|| IFID_inst[31:26] == `ADDIU)?1'b1:0;
wire IDEX_B_con = (IDEX_branch & res_comp)|IDEX_isjl|IDEX_isjr;

assign debug_wb_pc = MEMWB_pc;       
assign debug_wb_rf_wen = {4{MEMWB_WB}};  
assign debug_wb_rf_wnum = MEMWB_rd;
assign debug_wb_rf_wdata = rd_val; 
assign IDEX_rs1_val=rs1_val;
assign IDEX_rs2_val=rs2_val;
assign isRead_inst = rst?0:1'b1;
assign isRead_data = rst?0:(|EXpreMEM_MemRW);
//debug
//    `DBG_Core_Assignments
//ending
 always @(posedge clk)begin
  if(rst==1'b1)begin
    IFID_pc           <=    0;
    IFID_inst         <=    0;
    IDEX_branch       <=    0;
    IDEX_isjl         <=    0;
    IDEX_isjr         <=    0;
    IDEX_WB           <=    0;
    IDEX_MemRW        <=    0;
    IDEX_valid        <=    1'b1;
    EXpreMEM_WB       <=    0;
    EXpreMEM_valid    <=    1'b1;
    EXpreMEM_MemRW    <=    0;
    EXpreMEM_branch   <=    0;
    preMEM_branch     <=    0;
    preMEM_WB         <=    0;  
    MEMWB_valid       <=    1'b1;
    MEMWB_WB          <=    0;
    stall_flag        <=    0;
    jump_flag         <=    0;
    IFID_is_Delayslot <=    0;
  end
  else begin
     stall_flag       <=    PCWen?0:1'b1;
     jump_flag        <=    preMEM_branch;
     inst_field       <=    PCWen?(jump_flag?inst_field_in:stall_flag?inst_store:inst_field_in):
                            preMEM_branch?inst_field_in:inst_field;
     inst_store       <=    PCWen?inst_store:stall_flag?inst_store:inst_field_in;
    //IF -> ID
     IFID_pc          <=    (IFIDWen)? pre_pc: IFID_pc;
     IFID_inst        <=    (IFIDWen)? inst_field: (Ctrl_Z?`NOP_INST:IFID_inst);
     IFID_is_Delayslot<=    (isBranch | is_jl | is_jr | IDEX_branch | IDEX_isjl | IDEX_isjr)? 1'b1:0;
     rs1              <=    (IFIDWen)? inst_field[25:21]: Ctrl_Z? 0:IFID_inst[25:21];
     rs2              <=    (IFIDWen)? inst_field[20:16]: Ctrl_Z? 0:IFID_inst[20:16];
     rd               <=    IFIDWen? (inst_con? inst_field[20:16]: ~inst_j? inst_field[15:11]: 5'd31):
                            Ctrl_Z? 0: IFID_con? IFID_inst[20:16]: ~IFID_j? IFID_inst[15:11]: 5'd31;
    //ID -> EX
      IDEX_branch     <=    ~IFID_is_Delayslot? isBranch:IDEX_B_con | EXpreMEM_branch? 0:isBranch;
      IDEX_isjl       <=    ~IFID_is_Delayslot? is_jl:IDEX_B_con | EXpreMEM_branch? 0:is_jl;
      IDEX_isjr       <=    ~IFID_is_Delayslot? is_jr:IDEX_B_con | EXpreMEM_branch? 0:is_jr;
      IDEX_inst       <=    (Ctrl_Z)? IFID_inst:`NOP_INST;
      IDEX_is_Delayslot<=   IFID_is_Delayslot;
      IDEX_WB         <=    RegWrite;
      IDEX_MemRW      <=    {MemR,MemW};
      IDEX_mem_op     <=    mem_op;
      IDEX_Imm        <=    Immediate;
      IDEX_Aluop      <=    ALU_Control;
      IDEX_Comop      <=    Comp_ctrl;
      IDEX_valid      <=    Ctrl_Z;
      IDEX_ALUSrcB    <=    ALUSrc_B;
      IDEX_ALUSrcA    <=    ALUSrc_A;
      IDEX_RegWrite   <=    MemtoReg;
      IDEX_pc         <=    Ctrl_Z? IFID_pc:IDEX_pc;
      IDEX_rd         <=    (Ctrl_Z)? rd: 0;
    //EX -> preMEM
      EXpreMEM_rd     <=    IDEX_rd;
      EXpreMEM_rs2    <=    IDEX_rs2_val;
      EXpreMEM_branch <=    ~IDEX_is_Delayslot? IDEX_B_con: (EXpreMEM_branch | preMEM_branch)? 0: IDEX_B_con;
      EXpreMEM_WB     <=    ~IDEX_is_Delayslot? IDEX_WB: (EXpreMEM_branch | preMEM_branch)? 0:IDEX_WB;
      EXpreMEM_Alu    <=    ALU_res;
//      EXpreMEM_isUart <=    (ALU_res == 32'hbfd003f8 || ALU_res == 32'hbfd003fc)? 1'b1:0;
      EXpreMEM_inst   <=    IDEX_inst;
      EXpreMEM_lui    <=    IDEX_Imm;
      EXpreMEM_pc     <=    IDEX_pc;
      EXpreMEM_valid  <=    IDEX_valid;
      EXpreMEM_MemRW  <=    ~IDEX_is_Delayslot? IDEX_MemRW: EXpreMEM_branch? 0:preMEM_branch? 0:IDEX_MemRW;
      EXpreMEM_mem_op <=    IDEX_mem_op;
      EXpreMEM_RegWrite<=   IDEX_RegWrite;
    //preMEM -> MEM
      preMEM_addr     <=    EXpreMEM_Alu;
      preMEM_data     <=    EXpreMEM_rs2;
//      preMEM_isUart   <=    EXpreMEM_isUart;
//      preMEM_Datain   <=    Data_in;
      preMEM_rd       <=    EXpreMEM_rd;
      preMEM_branch   <=    EXpreMEM_branch;
      preMEM_WB       <=    EXpreMEM_WB;
      preMEM_inst     <=    EXpreMEM_inst;
      preMEM_lui      <=    EXpreMEM_lui;
      preMEM_pc       <=    EXpreMEM_pc;
      preMEM_MemRW    <=    EXpreMEM_MemRW;
      preMEM_mem_op   <=    EXpreMEM_mem_op;
      preMEM_RegWrite <=    EXpreMEM_RegWrite;
    //MEM -> WB
      MEMWB_rd        <=    preMEM_rd;   
//      MEMWB_mem       <=    ~preMEM_isUart? Data_in: preMEM_Datain;  
      MEMWB_mem       <=    Data_in;      
      MEMWB_Alu       <=    preMEM_addr;   
      MEMWB_inst      <=    preMEM_inst;      
      MEMWB_lui       <=    preMEM_lui;
      MEMWB_valid     <=    Ctrl_Z;
      MEMWB_pc        <=    preMEM_pc;      
      MEMWB_WB        <=    preMEM_WB;   
      MEMWB_mem_op    <=    preMEM_mem_op;
      MEMWB_RegWrite  <=    preMEM_RegWrite;
    end
  end
//output
  assign PC_out = pc;
  assign dmem_wen = EXpreMEM_MemRW[0];
  assign Data_out = (EXpreMEM_mem_op==`mem_sel_SB)?{EXpreMEM_rs2[7:0],EXpreMEM_rs2[7:0],EXpreMEM_rs2[7:0],EXpreMEM_rs2[7:0]}:
                    (EXpreMEM_mem_op==`mem_sel_SW)? EXpreMEM_rs2:32'b0;
  assign Din_addr = EXpreMEM_Alu;

HazardDetec HD(//???????forwarding???xxx-sd, xxx-ld, ld-use,?????????nop
    .rst(rst),
    //Date Hazard
    .IFID_rs1(rs1),
    .IFID_rs2(rs2),
    .IDEX_MR(IDEX_MemRW[1]),//lw
    .IDEX_MW(IDEX_MemRW[0]),//sw
    .IFID_sw(IFID_sw),//sw
    .IFID_lw(IFID_lw),//lw
    .IDEX_rd(IDEX_rd),
    .EXpreMEM_rd(EXpreMEM_rd),
    .preMEM_rd(preMEM_rd),
    .EXpreMEM_MR(EXpreMEM_MemRW[1]),//lw
    //Control Hazard
    .IFID_Branch(IFID_Branch),
    .IDEX_Branch(IDEX_branch),
    .IFID_Jump(IFID_Jump),
    .IDEX_Jump(IDEX_isjl|IDEX_isjr), 
    .EXpreMEM_Branch(EXpreMEM_branch),
    .preMEM_Branch(preMEM_branch),
    //Output
    .PCWen(PCWen),//1:??§Õ
    .IFIDWen(IFIDWen),//1????§Õ
    .Contrl_zero(Ctrl_Z)//1:????? 0:??IDEX???§Ø?§Õ???????//???
    );

PCreg32 pcreg32(
    .clk(clk),
    .rst(rst),
    .PCWen(PCWen),//PC write enable
    .isjl(IDEX_isjl),//?????????
    .isjr(IDEX_isjr),//?????????
    .IDEX_Branch(IDEX_branch),//ID_EX???branch???
    .EXpreMEM_Branch(EXpreMEM_branch),//EX_preMem??????
    .preMEM_Branch(preMEM_branch),//preMem??????
    .jump_reg_pc(ALU_res),//jr??????
    .PC(IDEX_pc),//???PC
    .imm(IDEX_Imm),//??????
    .compres(res_comp), //?????
    .pre_pc(pre_pc), //?????pc
    .PC_out(pc)//????????
    );

SCPU_ctrl  scpu_ctrl(//????ID??¦Í???
//31...26:opcode 6bit
//5...0 func  6bit
    .Ctrl_Z(Ctrl_Z),
    .rst(rst),
    .OPcode(IFID_inst[31:26]),
    .Func6(IFID_inst[5:0]),
    .ImmSel(ImmSel),
    .ALUSrc_B(ALUSrc_B),//ALUB??????0:rs2,1:imm
    .ALUSrc_A(ALUSrc_A),//ALUA??????0:rs1,1:imm
    .MemtoReg(MemtoReg),//0:ALU,1:Mem,2:PC+4 3:Imm 4:pc+imm 
    //pc_jump
    .isBranch(isBranch),
    .is_jl(is_jl),
    .is_jr(is_jr),
    .RegWrite(RegWrite),//1:register??§Õ
    .MemW(MemW),
    .MemR(MemR),
    .mem_op(mem_op),
    .ALU_Control(ALU_Control),//ALU???????
    .Comp_ctrl(Comp_ctrl)
    );   
    
mem_sel memsel(//????dram§Õ??????
    .addr(EXpreMEM_Alu[1:0]),
    .mem_op(EXpreMEM_mem_op),
    .mem_sel(mem_sel)
    );
    
//?????????? 
immGen immgen(//ID
    .inst_field(IFID_inst),
    .ImmSel(ImmSel),
    .Imm_out(Immediate)
    );

//???REG§Õ???????        
Write2Reg wr(
    .pc(MEMWB_pc),
    .ALU(MEMWB_Alu),
    .Mem(MEMWB_mem),
    .lui(MEMWB_lui),//lui
    .MemtoReg(MEMWB_RegWrite),//0:ALU,1:Mem,2:PC+8 3:lui
    .mem_op(MEMWB_mem_op),
    .res(rd_val)
    );        
         
RegFile rf(
//    `DBG_RegFile_Arguments
    .clk(clk),
    .rst(rst),
    .wen(MEMWB_WB),
    .rs1(rs1),
    .rs2(rs2),
    .rd(MEMWB_rd),
    .i_data(rd_val),
    .rs1_val(rs1_val),
    .rs2_val(rs2_val)
    );
    
Alu alu(
    .a_val(Alu_rs1),
    .b_val(Alu_rs2),
    .ctrl(IDEX_Aluop),
    .result(ALU_res),
    .comp_ctrl(Comp_ctrl),
    .res_comp(res_comp)
    );

//////////////////////////
//Forwarding:
Forwarding fw(
    //ctrl signal
    .EXMEM_WB(EXpreMEM_WB),
    .MEMWB_WB(MEMWB_WB),
    .preMEM_WB(preMEM_WB),
    //result
    .ALUSrc_A(IDEX_ALUSrcA),
    .ALUSrc_B(IDEX_ALUSrcB),
    .IDEX_rs1(rs1_val),
    .IDEX_rs2(rs2_val),
    .Imm(IDEX_Imm),
    .EXMEM_Alu(EXpreMEM_Alu),//EX_alu:EXpreMEM_Alu
    .EXMEM_pc(EXpreMEM_pc),//EX_pc
    .EXMEM_lui(EXpreMEM_lui),//EX_lui
    .EXMEM_RegWrite(EXpreMEM_RegWrite),//choose which
    .preMEM_rdval(preMEM_addr),//premem_alu
    .preMEM_pc(preMEM_pc),//premem_pc
    .preMEM_lui(preMEM_lui),//premem_lui
    .preMEM_RegWrite(preMEM_RegWrite),//choose which
    .WB_rdval(rd_val),//WB
    //////////
    .rs1(IDEX_inst[25:21]),
    .rs2(IDEX_inst[20:16]),
    .EXMEM_rd(EXpreMEM_rd),
    .MEMWB_rd(MEMWB_rd),
    .preMEM_rd(preMEM_rd),
    .ALU_Scr1(Alu_rs1),
    .ALU_Scr2(Alu_rs2) 
    );
///////////////////////////

endmodule
