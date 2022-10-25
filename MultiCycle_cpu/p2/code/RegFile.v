module RegFile(
    input reset,clk,Reg_Write,
    input [1:0]Reg_Dst,
    input [2:0]Mem_to_Reg,
    input [31:0]data_dm,
    input [31:0]t0, //pc+4
    input [31:0]data_alu,
    input [4:0]rs,rt,rd,
    output [31:0]rs_out,rt_out
);
    reg sign;
    initial begin
        sign = 0;
    end
    
    reg[31:0] regfile[31:0];
    integer i;


    always@(posedge clk,posedge reset)
    begin
        if(reset)
            for(i=0;i<32;i=i+1) regfile[i]<=32'h0000_0000;
        else
        begin   
            if(Reg_Write)       //写使能有效且不溢出且地址不错误时写入
            begin
                if(sign) begin regfile[30]<=0; sign<=0; end 
                case(Reg_Dst)    //RegDst 00 为写入rt，01 为写入rd,10写入31号,11写入30号
                    2'b00: 
                    begin
                        if(rt!=5'b0)
                        begin
                            case(Mem_to_Reg)       //Mem_to_Reg 0 为写入ALU运算结果， 1 为写入存储器内容
                                3'b000: regfile[rt]<=data_alu[31:0];
                                3'b001: regfile[rt]<=data_dm;
                            endcase
                        end
                    end   
                    2'b01:
                    begin
                        if(rd!=5'b0)
                        begin
                            case(Mem_to_Reg)
                                3'b000: regfile[rd]<=data_alu;
                                3'b001: regfile[rd]<=data_dm;
                            endcase
                        end
                    end    
                    2'b10: regfile[31]<=t0;
                    2'b11:
                    begin
                        case(Mem_to_Reg)
                        3'b011: begin regfile[30]<=1; sign<=1; end
                        endcase
                    end
                endcase
            end       
        end
    end

    assign rs_out = regfile[rs];   
    assign rt_out = regfile[rt];
endmodule