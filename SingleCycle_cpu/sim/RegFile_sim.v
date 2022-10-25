`timescale 1ns / 1ps

module Regfile_sim;
// RegFile_20090121 Parameters
parameter PERIOD  = 10;


// RegFile_20090121 Inputs
reg   reset                                = 0 ;
reg   clk                                  = 0 ;
reg   RegWrite                             = 0 ;
reg   RegDst                               = 0 ;
reg   Mem_to_Reg                           = 0 ;
reg   [31:0]  data_alu                     = 0 ;
reg   [31:0]  data_dm                      = 0 ;
reg   [4:0]  rs                            = 0 ;
reg   [4:0]  rt                            = 0 ;
reg   [4:0]  rd                            = 0 ;

// RegFile_20090121 Outputs
wire  [31:0]  rs_out                       ;
wire  [31:0]  rt_out                       ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end


RegFile_20090121  u_RegFile_20090121 (
    .reset                   ( reset              ),
    .clk                     ( clk                ),
    .RegWrite                ( RegWrite           ),
    .RegDst                  ( RegDst             ),
    .Mem_to_Reg              ( Mem_to_Reg         ),
    .data_alu                ( data_alu    [31:0] ),
    .data_dm                 ( data_dm     [31:0] ),
    .rs                      ( rs          [4:0]  ),
    .rt                      ( rt          [4:0]  ),
    .rd                      ( rd          [4:0]  ),

    .rs_out                  ( rs_out      [31:0] ),
    .rt_out                  ( rt_out      [31:0] )
);

initial
begin
    reset=1;
    RegWrite=1;
    RegDst=0;
    Mem_to_Reg=0;
    data_alu=32'h0000_1111;
    data_dm=32'h1111_0000;
    rs=5'b00010;
    rt=5'b00100;
    rd=5'b00101;
    #5 reset=0;
    #50 RegDst=1;
    Mem_to_Reg=1;
    

end
    
endmodule