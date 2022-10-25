`timescale 1ns / 1ps
module Temp_Reg_ALU(
    input clk,
    input [31:0]data_in,
    output reg [31:0]data_out
);

    always@(posedge clk)
    begin
        data_out<=data_in;
    end


endmodule