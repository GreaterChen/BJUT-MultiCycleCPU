`timescale 1ns / 1ps


module DM_20090121(
    input clk,MemWrite,reset,
    input [31:0]data_rt,pc_new,
    input [32:0]pc_alu,
    output AddressError,
    output [31:0]data_out
    );
    reg [7:0]im[1023:0];
    integer i;

    `define little_endian {im[pc_alu[9:0]+3],im[pc_alu[9:0]+2],im[pc_alu[9:0]+1],im[pc_alu[9:0]]}    //小端序存储 

   
    assign AddressError = (pc_new[1:0]==2'b00)?0:1;         //lw、sw中规定的地址错误
    assign data_out = AddressError ? 0:`little_endian;


    always@(posedge clk,posedge reset)
    begin
        if(reset)   for(i=0;i<1024;i=i+1) im[i]<=8'b0;
        else if(MemWrite&&!AddressError)   `little_endian <= data_rt; 
    end
endmodule
