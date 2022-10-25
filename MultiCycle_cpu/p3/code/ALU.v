module ALU(
    input ALU_Src,
    input [2:0]ALU_op,
    input [31:0]rs_in,rt_in,imm_in,
    output overflow,zero,bltzal_sign,
    output reg [32:0]result
    );

    always@(*)
    begin
        case(ALU_Src)  
            1'b0:       //与rt运算
            begin
                case(ALU_op)
                    3'b000: result<=rs_in + rt_in;    
                    3'b001: result<=rs_in - rt_in;
                    3'b010: result<=rs_in | rt_in;
                    3'b011: begin
                                if(rs_in[31]==1 && rt_in[31]==0 )     result<=1;
                                else if(rs_in[31]==0 && rt_in[31]==1) result<=0;
                                else if(rs_in[31]==0 && rt_in[31]==0) result<=(rs_in<rt_in)?1:0;
                                else if(rs_in[31]==1 && rt_in[31]==1) result<=(rs_in[30:0]<rs_in[30:0])?1:0;
                            end
                    3'b110: begin
                                if(rs_in[31] == 1) result<=1;
                                else result<=0;
                            end          
                endcase
            end
            1'b1:  //与立即数运算
            begin
                case(ALU_op)
                    3'b000: result<=rs_in + imm_in;
                    3'b001: result<=rs_in - imm_in;
                    3'b010: result<=rs_in | imm_in;
                    3'b100: result={rs_in[31],rs_in[31:0]}+imm_in;
                    3'b101: result<=imm_in; 
                endcase
            end
        endcase
    end

    assign zero=(result==0)?1:0;

    assign overflow=(ALU_op==3'b100)?( (result[32]!=result[31])?1:0 ):0;

    assign bltzal_sign = (ALU_op==3'b110 && result==1)?1:0;


endmodule