`timescale 1ns / 1ps
`include "head.vh"



module Controller_20090121(
    input [5:0]OpCode,func,
    output reg RegDst, ALUSrc,Mem_to_Reg,RegWrite,MemWrite,nPC_sel,J,jal,jr,
    output reg [1:0]Extop,ALUop
    );
    
    `define signal {RegDst,ALUSrc,Mem_to_Reg,RegWrite,MemWrite,nPC_sel,Extop,ALUop,J,jal,jr}   // define 不加分号

    // RegDst: 00为写入rt,01为写入rd,10为写入31号寄存器（jal）
    // ALUSrc: 0为rt运算,1为立即数运算
    // Mem_to_Reg: 0为ALU结果传入寄存器，1为DM内容传入寄存器
    // RegWrite: 写寄存器使能
    // MemWrite: 写存储器使能
    // nPC_sel: PC跳转使能
    // Extop: 00为零拓展，01为符号拓展，10为lui拓展
    // ALUop: 00为加，01为减，10为或
    // J: J指令使能
    // jal: jal指令使能
    // jr: jr指令使能

    always@(*)
    begin
        case(OpCode)
            6'b000000:
                begin
                    case(func)
                        `addu :     `signal = {1'b1,1'b0,1'b0,1'b1,1'b0,1'b0,2'b00,2'b00,1'b0,1'b0,1'b0};     
                        `subu :     `signal = {1'b1,1'b0,1'b0,1'b1,1'b0,1'b0,2'b00,2'b01,1'b0,1'b0,1'b0};  
                        `slt :      `signal = {1'b1,1'b0,1'b0,1'b1,1'b0,1'b0,2'b00,2'b01,1'b0,1'b0,1'b0};    
                        `jr :       `signal = {1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,2'b00,2'b00,1'b0,1'b0,1'b1};     
                    endcase
                end
            `ori :       `signal = {1'b0,1'b1,1'b0,1'b1,1'b0,1'b0,2'b00,2'b10,1'b0,1'b0,1'b0};                
            `lw :        `signal = {1'b0,1'b1,1'b1,1'b1,1'b0,1'b0,2'b01,2'b00,1'b0,1'b0,1'b0};                 
            `sw :        `signal = {1'b0,1'b1,1'b0,1'b0,1'b1,1'b0,2'b01,2'b00,1'b0,1'b0,1'b0};                 
            `beq :       `signal = {1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,2'b01,2'b01,1'b0,1'b0,1'b0};                
            `lui :       `signal = {1'b0,1'b1,1'b0,1'b1,1'b0,1'b0,2'b10,2'b00,1'b0,1'b0,1'b0};                
            `j :         `signal = {1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,2'b00,2'b00,1'b1,1'b0,1'b0};                 
            `addi :      `signal = {1'b0,1'b1,1'b0,1'b1,1'b0,1'b0,2'b01,2'b00,1'b0,1'b0,1'b0};               
            `addiu :     `signal = {1'b0,1'b1,1'b0,1'b1,1'b0,1'b0,2'b01,2'b00,1'b0,1'b0,1'b0};              
            `jal :       `signal = {1'b0,1'b0,1'b0,1'b1,1'b0,1'b1,2'b00,2'b00,1'b0,1'b1,1'b0};                
        endcase
    end
endmodule
