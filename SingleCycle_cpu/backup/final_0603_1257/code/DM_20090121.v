`timescale 1ns / 1ps


module DM_20090121(
    input clk,MemWrite,reset,
    input [31:0]data_rt,
    input [32:0]pc_alu,
    output [31:0]data_out
    );
    reg [7:0]im[1023:0];
    integer i;

    assign data_out = {im[pc_alu[9:0]+3],im[pc_alu[9:0]+2],im[pc_alu[9:0]+1],im[pc_alu[9:0]]};

    always@(posedge clk,posedge reset)
    begin
        if(reset)   for(i=0;i<1024;i=i+1) im[i]<=8'b0;
        else if(MemWrite)   {im[pc_alu[9:0]+3],im[pc_alu[9:0]+2],im[pc_alu[9:0]+1],im[pc_alu[9:0]]} <= data_rt; 
    end
endmodule
