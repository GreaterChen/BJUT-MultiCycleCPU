module output_equip(
    input clk,rst,WR_en,
    input addr,
    input [31:0]din,
    
    output [31:0]dout
);

    reg [31:0]regfile[1:0];

  //  assign dout = (addr == 1'b0)?regfile[0]:(addr == 1'b1)?regfile[1]:32'hffff_ffff;
    assign dout = (addr == 1'b1)?regfile[1]:32'h0;


    always@(posedge clk,posedge rst)
    begin
        if(rst) begin regfile[0]<=0;regfile[1]<=0; end
        else begin
            if(WR_en)
            begin
                case(addr)
                    1'b0: regfile[0]<=din;
                    1'b1: regfile[1]<=din;
                endcase
            end
        end
    end
    

endmodule

