`timescale  1ns / 1ps

module tb_DM_20090121;

// DM_20090121 Parameters
parameter PERIOD  = 10;


// DM_20090121 Inputs
reg   clk                                  = 0 ;
reg   MemWrite                             = 0 ;
reg   reset                                = 0 ;
reg   [31:0]  pc_alu                       = 0 ;
reg   [31:0]  data_rt                      = 0 ;

// DM_20090121 Outputs
wire  [31:0]  data_out                     ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

DM_20090121  u_DM_20090121 (
    .clk                     ( clk              ),
    .MemWrite                ( MemWrite         ),
    .reset                   ( reset            ),
    .pc_alu                  ( pc_alu    [31:0] ),
    .data_rt                 ( data_rt   [31:0] ),

    .data_out                ( data_out  [31:0] )
);

initial
begin
    clk=0;
    MemWrite=1;
    reset=0;
    pc_alu=32'h0000_0010;
    data_rt=32'h0000_1111;
    #30 reset=1;

    
end

endmodule