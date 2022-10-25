module IR(
    input clk,IR_Write,
    input [31:0] ins,
    output reg[5:0]OpCode,func,
    output reg[4:0]shamt,rt,rd,rs,
    output reg[15:0]Imm,
    output reg[25:0]Imm_abs
);
    reg [31:0]ins_out;

    always@(posedge clk)
    begin
        if(IR_Write)
        begin
            ins_out<=ins;
            Imm<=ins[15:0];
            Imm_abs<=ins[25:0];
            func<=ins[5:0];
            shamt<=ins[10:6];
            rd<=ins[15:11];
            rt<=ins[20:16];
            rs<=ins[25:21];
            OpCode<=ins[31:26];
        end

    end



endmodule