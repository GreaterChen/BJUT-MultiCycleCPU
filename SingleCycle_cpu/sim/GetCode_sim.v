`timescale  1ns / 1ps

module tb_GetCode;

// GetCode Parameters
parameter PERIOD  = 10;


// GetCode Inputs
reg   [31:0]  code                         = 0 ;

// GetCode Outputs
wire  [5:0]  OpCode                        ;    
wire  [5:0]  func                          ;    
wire  [4:0]  shamt                         ;    
wire  [4:0]  rt                            ;    
wire  [4:0]  rd                            ;
wire  [4:0]  rs                            ;
wire  [15:0]  Imm                          ;



GetCode  u_GetCode (
    .code                    ( code    [31:0] ),

    .OpCode                  ( OpCode  [5:0]  ),
    .func                    ( func    [5:0]  ),
    .shamt                   ( shamt   [4:0]  ),
    .rt                      ( rt      [4:0]  ),
    .rd                      ( rd      [4:0]  ),
    .rs                      ( rs      [4:0]  ),
    .Imm                     ( Imm     [15:0] )
);

initial
begin
    code=32'h34100001;
    #50 $stop;

    
end

endmodule