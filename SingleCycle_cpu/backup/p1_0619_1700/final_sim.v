`timescale  1ns / 1ps

module tb_SingleCycle_cpu_top;

// SingleCycle_cpu_top Parameters
parameter PERIOD  = 10;


// SingleCycle_cpu_top Inputs
reg   clk                                  = 0 ;
reg   reset                                = 0 ;

// SingleCycle_cpu_top Outputs

initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

SingleCycle_cpu_top  cpu (
    .clk                     ( clk     ),
    .reset                   ( reset   )
);

initial
begin
    $readmemh("D:/Modelsim/SingleCycle_cpu/data/test_bgtz/p1-test.txt",cpu.ifu_t.im);
    clk=1;
    reset=1;
    #1 reset=0;
    #700 $stop;
    $finish;
end

endmodule