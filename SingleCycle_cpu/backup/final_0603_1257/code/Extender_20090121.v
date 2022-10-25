`timescale 1ns / 1ps


module Extender_20090121(
    input [15:0]Imm,
    input [1:0]Extop,
    output reg [31:0]Ext_result
    );
    

    always@(*)
    begin
        case(Extop)
            2'b00: Ext_result <= { {16{1'b0}} , Imm };
            2'b01: Ext_result <= { {16{Imm[15]}} , Imm};
            2'b10: Ext_result <= {Imm , {16{1'b0}} };
        endcase
    end

endmodule
