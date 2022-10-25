`timescale 1ns / 1ps
`include "instructions_define.vh"
module Controller_Mul (
    input clk,reset,zero,overflow,lb_sign,sb_sign,
    input [5:0]OpCode,func,
    output  ALU_Src,Reg_Write,Mem_Write,Pc_Write,IR_Write,
    output  [1:0]Ext_op,Reg_Dst,nPC_op,
    output  [2:0]ALU_op,Mem_to_Reg
);
    reg [3:0] state;
    reg [3:0] next_state;
    parameter   IF        = 4'b0000;
    parameter   ID        = 4'b0001;
    parameter   EXE_ls    = 4'b0010;
    parameter   MEM_sa    = 4'b0011;
    parameter   MEM_ld    = 4'b0100;
    parameter   WB_dm     = 4'b0101;
    parameter   EXE_com   = 4'b0110;
    parameter   EXE_cal   = 4'b0111;
    parameter   WB_cal    = 4'b1000;
    parameter   WB_jal    = 4'b1001;
    parameter   EXE_jr    = 4'b1010;
    parameter   BRANCH    = 4'b1011;
    
    
    `define ins {OpCode,func}
    // Pc_Write: pc模块写使能
    // IR_Write: IR模块写使能 
    // ALUSrc: 0为rt运算,1为立即数运算
    // Mem_to_Reg: 000为ALU结果传入寄存器，001为DM内容传入寄存器,010为pc+4内容传入寄存器,011为1传入寄存器，
    // RegWrite: 写寄存器使能
    // MemWrite: 写存储器使能
    // RegDst: 00为写入rt,01为写入rd,10为写入31号寄存器（jal）,11为写入30号寄存器（overflow）
    // nPC_op: 00为+4跳转，01为相对跳转，10为绝对跳转，11为来自rs寄存器内容跳转
    // Extop: 00为零拓展，01为符号拓展，10为lui拓展
    // ALUop: 000为无符号加，001为无符号减，010为无符号或,011为slt有符号数比较,100为有符号数加法,101为lui运算,110为bgtz运算

    
    //取指->译码/寄存器读->执行->访存->寄存器写回

    always@(posedge clk,posedge reset)
    begin
        if(reset) state<=IF;
        else state<=next_state;
    end

    always@(*)
    begin
            case(state)
            IF:
            begin
                $display("state:IF");
                next_state = ID;    //无条件跳转s1
            end
            ID:
            begin
                $display("state:ID");
                casex(`ins)
                    `j:next_state=BRANCH;
                    `jal:next_state=WB_jal;
                    `jr:next_state=EXE_jr;             //绝对跳转型

                    `sw:next_state=EXE_ls;
                    `lw:next_state=EXE_ls;      //访问寄存器型
                    `sb:next_state=EXE_ls;
                    `lb:next_state=EXE_ls;

                    `beq:next_state=EXE_com;       //相对跳转型

                    default:next_state=EXE_cal;    //运算型 
                endcase
            end
            EXE_ls:
            begin
                $display("state:EXE_ls");
                casex (`ins)
                    `lw:next_state=MEM_ld;
                    `lb:next_state=MEM_ld;
                    `sw:next_state=MEM_sa;
                    `sb:next_state=MEM_sa; 
                endcase
            end
            MEM_ld:
            begin
                $display("state:MEM_ld");
                next_state=WB_dm;
            end
            MEM_sa:
            begin
                $display("state:MEM_sa");
                next_state=IF;
            end
            WB_dm:
            begin
                $display("state:WB_dm");
                next_state=IF;
            end
            EXE_com:
            begin
                $display("state:EXE_com");
                casex(`ins)
                    `beq:next_state=BRANCH;
                endcase
            end
            EXE_cal:
            begin
                $display("state:EXE_cal");
                next_state=WB_cal;
            end
            WB_cal:
            begin
                $display("state:WB_cal");
                next_state=IF;  
            end
            WB_jal:
            begin
                $display("state:WB_jal");
                next_state=BRANCH;
            end
            EXE_jr:
            begin
                $display("state:EXE_jr");
                next_state=BRANCH;
            end
            BRANCH:
            begin
                $display("state:BRANCH");
                next_state=IF;
            end

            endcase
    end


    assign ALU_Src       = (OpCode==`lb_o || OpCode==`sb_o ||OpCode==`ori_o || OpCode==`lw_o || OpCode==`sw_o || OpCode==`sb_o || OpCode==`lui_o || OpCode==`addi_o || OpCode==`addiu_o);
    assign Mem_to_Reg[2] = 0;
    assign Mem_to_Reg[1] = (OpCode==`jal_o || overflow);
    assign Mem_to_Reg[0] = (OpCode==`lw_o || OpCode==`lb_o || overflow);
    assign Reg_Dst[1]    = (OpCode==`jal_o || overflow);
    assign Reg_Dst[0]    = (OpCode==6'b0 && (func==`addu_f || func==`subu_f || func==`slt_f) || overflow);
    assign nPC_op[1]     = (state==BRANCH && (OpCode==`j_o || OpCode==`jal_o || (OpCode==6'b0 && func==`jr_f)));
    assign nPC_op[0]     = (state==BRANCH &&((OpCode==`beq_o && zero==1) || (OpCode==6'b0 && func===`jr_f)));
    assign Ext_op[1]     = (OpCode==`lui_o);
    assign Ext_op[0]     = (OpCode==`lw_o || OpCode==`sw_o || OpCode==`lb_o || OpCode==`sb_o || OpCode==`lw_o || OpCode==`addi_o || OpCode==`addiu_o);
    assign ALU_op[2]     = (OpCode==`addi_o || OpCode==`lui_o);
    assign ALU_op[1]     = (OpCode==`ori_o || (OpCode==0 && func==`slt_f));
    assign ALU_op[0]     = ((OpCode==6'b0 && func==`subu_f) || (OpCode==6'b0 && func==`slt_f) || OpCode==`lui_o || OpCode==`beq_o);
    assign lb_sign       = (OpCode==`lb_o);
    assign sb_sign       = (OpCode==`sb_o);
    
    assign Pc_Write      = (state==IF || (state==BRANCH && OpCode!=`beq_o) || (state==BRANCH && OpCode==`beq_o && zero));
    assign IR_Write      = (state==IF);
    assign Reg_Write     = (state==WB_jal || state==WB_cal || state==WB_dm);
    assign Mem_Write     = (state==MEM_sa);

    
endmodule