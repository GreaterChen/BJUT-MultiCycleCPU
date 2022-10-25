`timescale 1ns / 1ps


module RegFile_20090121(
    input reset,clk,RegWrite,RegDst,Mem_to_Reg,overflow,jal,AddressError,
    input [31:0]data_dm,
    input [31:0]t0, //pc+4
    input [32:0]data_alu,
    input [4:0]rs,rt,rd,
    output [31:0]rs_out,rt_out
);
    
    reg[31:0] regfile[31:0];
    integer i;

    assign rs_out = regfile[rs];   // assign赋值的应为wire型
    assign rt_out = regfile[rt];

    always@(posedge clk,posedge reset)
    begin
        if(reset)
            for(i=0;i<31;i=i+1) regfile[i]<=32'h0000_0000;
        else
        begin
            if(jal) regfile[31]<=t0;    // jal $30写入顺序执行的下一条指令
            if(overflow)    regfile[30]<=32'h0000_0001;     //$30写入溢出标志
            if(RegWrite&&!overflow&&!AddressError)        //写使能有效且不溢出时写入
                case(RegDst)    //RegDst 0 为写入rt，1 为写入rd
                    1'b0: 
                    begin
                        if(rt!=5'b0)
                        begin
                            case(Mem_to_Reg)       //Mem_to_Reg 0 为写入ALU运算结果， 1 为写入存储器内容
                                1'b0: regfile[rt]<=data_alu[31:0];
                                1'b1: regfile[rt]<=data_dm;
                            endcase
                        end
                    end   
                    1'b1:
                    begin
                        if(rd!=5'b0)
                        begin
                            case(Mem_to_Reg)
                                1'b0: regfile[rd]<=data_alu;
                                1'b1: regfile[rd]<=data_dm;
                            endcase
                        end
                    end    
                endcase

            
        end
    end
endmodule
