`timescale  1ns / 1ps

module tb_Controller_20090121;

// Controller_20090121 Parameters
parameter PERIOD  = 10;


// Controller_20090121 Inputs
reg   [5:0]  OpCode                        = 0 ;
reg   [5:0]  func                          = 0 ;

// Controller_20090121 Outputs
wire  ALUSrc                               ;
wire  Mem_to_Reg                           ;
wire  RegWrite                             ;
wire  MemWrite                             ;
wire  nPC_sel                              ;
wire  J                                    ;
wire  [1:0]  RegDst                        ;
wire  [1:0]  Extop                         ;
wire  [1:0]  ALUop                         ;



Controller_20090121  u_Controller_20090121 (
    .OpCode                  ( OpCode      [5:0] ),
    .func                    ( func        [5:0] ),

    .ALUSrc                  ( ALUSrc            ),
    .Mem_to_Reg              ( Mem_to_Reg        ),
    .RegWrite                ( RegWrite          ),
    .MemWrite                ( MemWrite          ),
    .nPC_sel                 ( nPC_sel           ),
    .J                       ( J                 ),
    .RegDst                  ( RegDst      [1:0] ),
    .Extop                   ( Extop       [1:0] ),
    .ALUop                   ( ALUop       [1:0] )
);

initial
begin
    OpCode=6'b001101;
    #50 OpCode=6'b000100;
    #50 $stop;
    
end

endmodule