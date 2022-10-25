module sb (
    input sb_sign,
    input [1:0]addr,
    input [31:0]data_in,
    input [23:0]pre_dm,

    output reg[31:0]data_out
);

    always@(*)
    begin
        if(!sb_sign) data_out<=data_in;
        else data_out<={pre_dm,data_in[7:0] };
    end
    
endmodule