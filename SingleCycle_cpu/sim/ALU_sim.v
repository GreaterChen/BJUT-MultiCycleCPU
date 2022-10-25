module tb_ALU_20090121;

// ALU_20090121 Parameters
parameter PERIOD  = 10;


// ALU_20090121 Inputs
reg   ALUSrc                               = 0 ;
reg   [1:0]  ALUop                         = 0 ;
reg   [31:0]  rs_in                        = 0 ;
reg   [31:0]  rt_in                        = 0 ;
reg   [31:0]  imm_in                       = 0 ;
reg   [5:0]  OpCode                        = 0 ;
reg   [5:0]  func                          = 0 ;

// ALU_20090121 Outputs
wire  overflow                             ;
wire  zero                                 ;
wire  condition                            ;
wire  [32:0]  result                       ;




ALU_20090121  u_ALU_20090121 (
    .ALUSrc                  ( ALUSrc            ),
    .ALUop                   ( ALUop      [1:0]  ),
    .rs_in                   ( rs_in      [31:0] ),
    .rt_in                   ( rt_in      [31:0] ),
    .imm_in                  ( imm_in     [31:0] ),
    .OpCode                  ( OpCode     [5:0]  ),
    .func                    ( func       [5:0]  ),

    .overflow                ( overflow          ),
    .zero                    ( zero              ),
    .condition               ( condition         ),
    .result                  ( result     [32:0] )
);

initial
begin
    #5 reset=1
    $finish;
end

endmodule