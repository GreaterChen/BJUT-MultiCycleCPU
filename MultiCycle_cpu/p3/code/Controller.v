
`include "instructions_define.vh"
module Controller_Mul (
    input clk,reset,zero,overflow,lb_sign,sb_sign,IntReq,
    input [4:0]rs,rt,      
    input [5:0]OpCode,func,
    input [31:0]addr,
    output  ALU_Src,Reg_Write,Mem_Write,Pc_Write,IR_Write,cp0_wr,EPC_wr,EXL_set,EXL_clr,wecpu,bltzal_sign,
    output  [1:0]Ext_op,Reg_Dst,
    output  [2:0]ALU_op,nPC_op,Mem_to_Reg
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
    parameter   INT       = 4'b1100;
    
    
    `define ins {OpCode,func}
    // Pc_Write: pc模块写使能
    // IR_Write: IR模块写使能 
    // ALU_Src: 0为rt运算,1为立即数运算
    // Mem_to_Reg: 000为ALU结果传入寄存器，001为DM内容传入,010为pc+4内容传入,011为1传入，100为0传入,101为CP0内容传入,110为外设内容传入
    // Reg_Write: 写寄存器使能
    // Mem_Write: 写存储器使能
    // Reg_Dst: 00为写入rt,01为写入rd,10为写入31号寄存器（jal）,11为写入30号寄存器（overflow）
    // nPC_op: 000为+4跳转，001为相对跳转，010为绝对跳转，011为来自rs寄存器内容跳转,100为中断跳转,101为EPC跳转
    // Ext_op: 00为零拓展，01为符号拓展，10为lui拓展
    // ALU_op: 000为无符号加，001为无符号减，010为无符号或,011为slt有符号数比较,100为有符号数加法,101为lui运算,110为bltzal运算
    // cp0_wr: 写cp0使能
    // IntReq: 中断信号
    
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
                    `j  :next_state=BRANCH;
                    `jal:next_state=WB_jal;
                    `jr :next_state=EXE_jr;             //绝对跳转型

                    `sw:next_state=EXE_ls;
                    `lw:next_state=EXE_ls;             //访问存储体型
                    `sb:next_state=EXE_ls;
                    `lb:next_state=EXE_ls;

                    `beq:next_state=EXE_com;           //相对跳转型


                    default:
                    begin
                        if(OpCode == 6'b010000)        //CP0交互型
                        begin
                            case(rs)
                                `MTC0_rs:next_state=MEM_sa;
                                `MFC0_rs:next_state=MEM_ld;
                                `ERET_rs:next_state=BRANCH;
                            endcase
                        end

                        if(OpCode==`bltzal_o)
                        begin
                            case(rt)
                                `bltzal_rt:next_state=EXE_com;
                            endcase
                        end
                        else next_state=EXE_cal;       //运算型    
                    end
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
                    default:
                    begin
                        case(rs)
                            `MFC0_rs:next_state=MEM_ld;
                            `MTC0_rs:next_state=MEM_sa;
                        endcase
                    end 
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
                if(IntReq) next_state=INT;
                else next_state=IF;
            end
            EXE_com:
            begin
                $display("state:EXE_com");
                if(OpCode==`bltzal_o && rt==`bltzal_rt) next_state=WB_jal; 
                else next_state=BRANCH;
            end
            EXE_cal:
            begin
                $display("state:EXE_cal");
                next_state=WB_cal;
            end
            WB_cal:
            begin
                $display("state:WB_cal");
                if(IntReq) next_state=INT;
                else next_state=IF;

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
                if(IntReq) next_state=INT;
                else next_state=IF;
            end
            INT:
            begin
                $display("state:INT");
                next_state=IF;
            end

            endcase
    end

    assign ALU_Src       = (OpCode==`lb_o || OpCode==`sb_o || OpCode==`ori_o || OpCode==`lw_o || OpCode==`sw_o || OpCode==`sb_o || OpCode==`lui_o || OpCode==`addi_o || OpCode==`addiu_o);
    assign Mem_to_Reg[2] = ((OpCode==`CP0_o && rs==`MFC0_rs) || (state==WB_dm && addr>32'h7EFF));
    assign Mem_to_Reg[1] = (OpCode==`jal_o  || overflow || (state==WB_dm && addr>32'h7EFF) || (OpCode==`bltzal_o && rt==`bltzal_rt));
    assign Mem_to_Reg[0] = ((OpCode==`lw_o && addr<32'h0000_3000) || (OpCode==`lb_o && addr<32'h0000_3000) || overflow || (OpCode==`CP0_o && rs==`MFC0_rs));
    assign Reg_Dst[1]    = (OpCode==`jal_o || overflow || (OpCode==`bltzal_o && rt==`bltzal_rt));
    assign Reg_Dst[0]    = (OpCode==6'b0 && (func==`addu_f || func==`subu_f || func==`slt_f) || overflow);
    assign nPC_op[2]     = (state==INT || (OpCode==`CP0_o && rs==`ERET_rs));
    assign nPC_op[1]     = (state!=INT && state==BRANCH && (OpCode==`j_o || OpCode==`jal_o || (OpCode==6'b0 && func==`jr_f)));
    assign nPC_op[0]     = (state!=INT && ((state==BRANCH && ((OpCode==`bltzal_o && rt==`bltzal_rt) || (OpCode==`beq_o && zero==1) || (OpCode==6'b0 && func===`jr_f))) || (OpCode==`CP0_o && rs==`ERET_rs)));
    assign Ext_op[1]     = (OpCode==`lui_o);
    assign Ext_op[0]     = (OpCode==`lw_o || OpCode==`sw_o || OpCode==`lb_o || OpCode==`sb_o || OpCode==`lw_o || OpCode==`addi_o || OpCode==`addiu_o);
    assign ALU_op[2]     = (OpCode==`addi_o || OpCode==`lui_o || (OpCode==`bltzal_o && rt==`bltzal_rt));  //*******
    assign ALU_op[1]     = (OpCode==`ori_o || (OpCode==0 && func==`slt_f) || (OpCode==`bltzal_o && rt==`bltzal_rt));  //*******
    assign ALU_op[0]     = ((OpCode==6'b0 && func==`subu_f) || (OpCode==6'b0 && func==`slt_f) || OpCode==`lui_o || OpCode==`beq_o);
    assign lb_sign       = (OpCode==`lb_o);
    assign sb_sign       = (OpCode==`sb_o);
    assign EXL_clr       = (OpCode==`CP0_o && rs==`ERET_rs);
    
    assign Pc_Write      = (state==INT || state==IF || (state==BRANCH && OpCode!=`beq_o && OpCode!=`bltzal_o) || (state==BRANCH && OpCode==`beq_o && zero) || (state==BRANCH && OpCode==`bltzal_o && rt==`bltzal_rt && bltzal_sign));
    assign IR_Write      = (state==IF); 
    assign Reg_Write     = (state==WB_jal || state==WB_cal || state==WB_dm);
    assign Mem_Write     = (state==MEM_sa && OpCode!=`CP0_o && addr < 32'h0000_3000);
    assign cp0_wr        = ((state==MEM_sa && OpCode==`CP0_o) || state==INT);
    assign EPC_wr        = (state==INT);
    assign EXL_set       = (state==INT);
    assign wecpu         = (state==MEM_sa && addr > 32'h0000_7EFF);


    
endmodule