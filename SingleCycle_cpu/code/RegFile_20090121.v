`timescale 1ns / 1ps


module RegFile_20090121(
    input reset,clk,RegWrite,Mem_to_Reg,overflow,AddressError,
    input [1:0]RegDst,
    input [31:0]data_dm,
    input [31:0]t0, //pc+4
    input [32:0]data_alu,
    input [4:0]rs,rt,rd,
    output [31:0]rs_out,rt_out,
    reg sign
);

    initial begin
        sign = 0;
    end
    
    reg[31:0] regfile[31:0];
    integer i;


    always@(posedge clk,posedge reset)
    begin
        if(reset)
            for(i=0;i<31;i=i+1) regfile[i]<=32'h0000_0000;
        else
        begin
            if(RegWrite)
            begin
                if(overflow)  begin  regfile[30]<=32'h0000_0001;   sign=1; end    //$30写入溢出标志
                else regfile[30]<=0;
            end

            if(!overflow&&sign)  begin regfile[30]<=0; sign = 0 ; end
            
            if(RegWrite&&!overflow&&!AddressError)       //写使能有效且不溢出且地址不错误时写入
                case(RegDst)    //RegDst 00 为写入rt，01 为写入rd,10写入31号
                    2'b00: 
                    begin
                        if(rt!=5'b0)
                        begin
                            case(Mem_to_Reg)       //Mem_to_Reg 0 为写入ALU运算结果， 1 为写入存储器内容
                                1'b0: regfile[rt]<=data_alu[31:0];
                                1'b1: regfile[rt]<=data_dm;
                            endcase
                        end
                    end   
                    2'b01:
                    begin
                        if(rd!=5'b0)
                        begin
                            case(Mem_to_Reg)
                                1'b0: regfile[rd]<=data_alu;
                                1'b1: regfile[rd]<=data_dm;
                            endcase
                        end
                    end    
                    2'b10: regfile[31]<=t0;
                endcase

            
        end
    end

    assign rs_out = regfile[rs];   
    assign rt_out = regfile[rt];
endmodule
