module nPc(
    input rst,
    input [1:0]nPC_op,
    input [31:0]pc_now,
    input [15:0]imm_com,     //相对跳转
    input [25:0]imm_abs,     //绝对跳转
    input [31:0]pc_jr,       //来自rs寄存器的完整指令

    output reg [31:0]t0,
    output reg [31:0] pc_next
);
    

    always@(*)
    begin
        if(rst) pc_next<=32'h0000_3004;
        else
        begin
            t0 = pc_now+4;
            case(nPC_op)
                2'b00 : pc_next <= pc_now + 4;
                2'b01 : pc_next <= pc_now + { {14{imm_com[15]}} , imm_com , 2'b00 };
                2'b10 : pc_next <= { t0[31:28] , imm_abs , 2'b00 };
                2'b11 : pc_next <= pc_jr;
            endcase 
        end
    end
endmodule