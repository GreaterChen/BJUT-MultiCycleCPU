`timescale 1ns / 1ps

`include "head.vh"

module ALU_20090121(
    input ALUSrc,
    input [1:0]ALUop,
    input [31:0]rs_in,rt_in,imm_in,
    input [5:0]OpCode,func,
    output overflow,
    output reg zero,
    output reg [32:0]result

    );
    
    always@(*)
    begin
        if(OpCode==`lui) result<=imm_in;   
        case(ALUSrc)  
            1'b0:       //来自rt
            begin
                case(ALUop)
                    2'b00: result<=rs_in+rt_in;     //+
                    2'b01:      //-
                    begin
                        case(func)
                            `subu: result<=rs_in - rt_in;     
                            `slt:  // 有符号数进行比较
                            begin
                                if(rs_in[31]==1 && rt_in[31]==0 ) result<=1;
                                else if(rs_in[31]==0 && rt_in[31]==1) result<=0;
                                else if(rs_in[31]==0 && rt_in[31]==0) result<=(rs_in<rt_in)?1:0;
                                else if(rs_in[31]==1 && rt_in[31]==1) result<=(rs_in[30:0]<rs_in[30:0])?1:0;
                            end
                            `beq: result<=rs_in - rt_in;   //beq
                        endcase
                        if(rs_in - rt_in == 0) zero <= 1;
                        else zero <= 0;
                    end
                    2'b10: result<=rs_in | rt_in;      // 或
                endcase
            end
            1'b01:  //来自立即数
            begin
                case(ALUop)
                    2'b00: 
                    begin
                        case(OpCode)
                            `addi: result<={rs_in[31],rs_in[31:0]}+imm_in;     //addi文档表述
                            default: result<=rs_in+imm_in;                        //addiu
                            
                        endcase
                    end
                    2'b01: 
                    begin 
                        result<=rs_in - imm_in;
                        if(rs_in - imm_in == 0 ) zero <= 1;
                        else zero <= 0;
                    end 
                    2'b10: result<=rs_in | imm_in;
                endcase
            end
        endcase
    end

    assign overflow=(OpCode==6'b001000)?( (result[32]!=result[31])?1:0 ):0;

endmodule
