`timescale 1ns / 1ps
`include "instructions_define.vh"



module Controller_20090121(
    input [5:0]OpCode,func,
    output reg ALUSrc,Mem_to_Reg,RegWrite,MemWrite,nPC_sel,J,jal,jr,
    output reg [1:0]Extop,RegDst,
    output reg [2:0]ALUop
    );
    
    `define signal {RegDst,ALUSrc,Mem_to_Reg,RegWrite,MemWrite,nPC_sel,Extop,ALUop,J,jal,jr}   // define 不加分号

    // RegDst: 00为写入rt,01为写入rd,10为写入31号寄存器（jal）
    // ALUSrc: 0为rt运算,1为立即数运算
    // Mem_to_Reg: 0为ALU结果传入寄存器，1为DM内容传入寄存器
    // RegWrite: 写寄存器使能
    // MemWrite: 写存储器使能
    // nPC_sel: PC跳转使能
    // Extop: 00为零拓展，01为符号拓展，10为lui拓展
    // ALUop: 000为无符号加，001为无符号减，010为无符号或,011为slt有符号数比较,100为有符号数加法,101为lui运算,110为bgtz运算
    // J: J指令使能
    // jal: jal指令使能
    // jr: jr指令使能

    always@(*)
    begin
        case(OpCode)
            6'b000000:
                begin
                    case(func)
                        `addu :     `signal = {2'b01,1'b0,1'b0,1'b1,1'b0,1'b0,2'b00,3'b000,1'b0,1'b0,1'b0};  
                        `subu :     `signal = {2'b01,1'b0,1'b0,1'b1,1'b0,1'b0,2'b00,3'b001,1'b0,1'b0,1'b0};  
                        `slt :      `signal = {2'b01,1'b0,1'b0,1'b1,1'b0,1'b0,2'b00,3'b011,1'b0,1'b0,1'b0};    
                        `jr :       `signal = {2'b00,1'b0,1'b0,1'b0,1'b0,1'b1,2'b00,3'b000,1'b0,1'b0,1'b1};     
                    endcase
                end
            `ori :       `signal = {2'b00,1'b1,1'b0,1'b1,1'b0,1'b0,2'b00,3'b010,1'b0,1'b0,1'b0};                
            `lw :        `signal = {2'b00,1'b1,1'b1,1'b1,1'b0,1'b0,2'b01,3'b000,1'b0,1'b0,1'b0};                 
            `sw :        `signal = {2'b00,1'b1,1'b0,1'b0,1'b1,1'b0,2'b01,3'b000,1'b0,1'b0,1'b0};                 
            `beq :       `signal = {2'b00,1'b0,1'b0,1'b0,1'b0,1'b1,2'b01,3'b001,1'b0,1'b0,1'b0};                
            `lui :       `signal = {2'b00,1'b1,1'b0,1'b1,1'b0,1'b0,2'b10,3'b101,1'b0,1'b0,1'b0};                
            `j :         `signal = {2'b00,1'b0,1'b0,1'b0,1'b0,1'b0,2'b00,3'b000,1'b1,1'b0,1'b0};                 
            `addi :      `signal = {2'b00,1'b1,1'b0,1'b1,1'b0,1'b0,2'b01,3'b100,1'b0,1'b0,1'b0};               
            `addiu :     `signal = {2'b00,1'b1,1'b0,1'b1,1'b0,1'b0,2'b01,3'b000,1'b0,1'b0,1'b0};              
            `jal :       `signal = {2'b10,1'b0,1'b0,1'b1,1'b0,1'b1,2'b00,3'b000,1'b0,1'b1,1'b0};
            `bgtz:       `signal = {2'b00,1'b0,1'b0,1'b0,1'b0,1'b1,2'b00,3'b001,1'b0,1'b0,1'b0};                
        endcase
    end
endmodule
