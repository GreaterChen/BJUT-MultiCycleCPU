`timescale 1ns / 1ps
module Temp_Reg_DM(
    input clk,
    input lb_sign,
    input [31:0]data_in,

    output reg [31:0]data_out
);
    reg lb_pos;

    always@(posedge clk)
    begin
        if(!lb_sign) data_out <= data_in;
        else         data_out <= { {24{data_in[7]}}  , data_in[7:0] };
    end


endmodule