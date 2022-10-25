module Pc(
    input clk,rst,Pc_Write,
    input [31:0]pc_next,
    output reg[31:0] pc
);

    initial
    begin
        pc<=32'h0000_3000;
    end

    always@(posedge clk,posedge rst)
    begin
        if(rst) pc<=32'h0000_3000;
        else
        begin
            if(Pc_Write) pc<=pc_next;
            else pc<=pc;
        end
    end

endmodule