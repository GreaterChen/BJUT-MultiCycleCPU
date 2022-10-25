`timescale 1ns / 1ps


module GetCode(
    input [31:0]code,
    output[5:0]OpCode,func,
    output[4:0]shamt,rt,rd,rs,
    output[15:0]Imm
    );
    

    assign Imm=code[15:0];
    assign func=code[5:0];
    assign shamt=code[10:6];
    assign rd=code[15:11];
    assign rt=code[20:16];
    assign rs=code[25:21];
    assign OpCode=code[31:26];

endmodule
