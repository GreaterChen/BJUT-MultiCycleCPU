`timescale 1ns / 1ps

module ifu_test;

reg clk,reset,npc_sel,zero,j;

wire [31:0]  insout;

ifu ifu_t(clk,reset,npc_sel,zero,insout,j);

initial
begin
    clk=1;
    reset=0;
    npc_sel=0;
    zero=0;
    j=0;
    #5 reset=1;
    #5 reset=0;
    #90 j=1;
    $readmemh("D:/Modelsim/SingleCycle_cpu/data/test01.txt",ifu_t.im);
    
end

always
    #30 clk=~clk;


endmodule
