module nPc(
    input rst,
    input [2:0]nPC_op,
    input [31:0]pc_now,
    input [15:0]imm_com,     //相对跳转
    input [25:0]imm_abs,     //绝对跳转
    input [31:0]pc_jr,       //来自rs寄存器的完整指令
    input [31:0]EPC,

    output reg [31:0] pc_next
);
    reg [31:0]t0;

    always@(*)
    begin
        if(rst) pc_next<=32'h0000_3004;
        else
        begin
            t0 = pc_now+4;
            case(nPC_op)
                3'b000 : pc_next <= t0;
                3'b001 : pc_next <= pc_now + { {14{imm_com[15]}} , imm_com , 2'b00 };
                3'b010 : pc_next <= { pc_now[31:28] , imm_abs , 2'b00 };
                3'b011 : pc_next <= pc_jr;
                3'b100 : pc_next <= 32'h0000_4180;
                3'b101 : pc_next <= EPC;
            endcase 
        end
    end
endmodule