module Extender(
    input [15:0]Imm,
    input [1:0]Ext_op,
    output reg [31:0]Ext_result
    );
    

    always@(*)
    begin
        case(Ext_op)
            2'b00: Ext_result <= { {16{1'b0}} , Imm };           // 零拓展
            2'b01: Ext_result <= { {16{Imm[15]}} , Imm};         // 符号拓展
            2'b10: Ext_result <= { Imm , {16{1'b0}} };           // lui拓展
        endcase
    end

endmodule