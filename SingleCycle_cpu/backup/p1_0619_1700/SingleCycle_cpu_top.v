`timescale 1ns / 1ps


module SingleCycle_cpu_top(
    input clk,reset
);
    wire nPC_sel,zero,J,ALUSrc,Mem_to_Reg,RegWrite,MemWrite,RegDst,overflow,jal,jr,AddressError,condition;
    wire [1:0]Extop;
    wire [2:0]ALUop;
    wire [31:0]code,data_dm,rs_out,rt_out,Ext_result,t0,pc_new;
    wire [32:0]data_alu;
    wire [5:0]OpCode,func;
    wire [4:0]rt,rd,rs,shamt;
    wire [15:0] Imm;
    

ifu  ifu_t (
    .clk                     ( clk       ),
    .reset                   ( reset     ),
    .npc_sel                 ( nPC_sel   ),
    .zero                    ( zero      ),
    .j                       ( J         ),
    .jal                     ( jal       ),
    .jr                      ( jr        ),
    .rs_in                   ( rs_out    ),
    .condition               ( condition ),

    .insout                  ( code      ),
    .t0                      ( t0        ),
    .pc_new                  ( pc_new    )
    

);
GetCode GetCode_t(
    .code                    ( code     ),

    .OpCode                  ( OpCode   ),
    .func                    ( func     ),
    .shamt                   ( shamt    ),
    .rt                      ( rt       ),
    .rd                      ( rd       ),
    .rs                      ( rs       ),
    .Imm                     ( Imm      )
);
Controller_20090121 Controller_t(
    .OpCode                  ( OpCode       ),
    .func                    ( func         ),

    .ALUSrc                  ( ALUSrc       ),
    .Mem_to_Reg              ( Mem_to_Reg   ),
    .RegWrite                ( RegWrite     ),
    .MemWrite                ( MemWrite     ),
    .nPC_sel                 ( nPC_sel      ),
    .J                       ( J            ),
    .RegDst                  ( RegDst       ),
    .Extop                   ( Extop        ),
    .ALUop                   ( ALUop        ),
    .jal                     ( jal          ),
    .jr                      ( jr           )
    
);
RegFile_20090121  RegFile_t (        
    .reset                   ( reset        ),
    .clk                     ( clk          ),
    .RegWrite                ( RegWrite     ),
    .RegDst                  ( RegDst       ),
    .Mem_to_Reg              ( Mem_to_Reg   ),
    .data_alu                ( data_alu     ),
    .data_dm                 ( data_dm      ),
    .rs                      ( rs           ),
    .rt                      ( rt           ),
    .rd                      ( rd           ),
    .overflow                ( overflow     ),
    .t0                      ( t0           ),
    .jal                     ( jal          ),
    .AddressError            ( AddressError ),

    .rs_out                  ( rs_out       ),
    .rt_out                  ( rt_out       )
);

Extender_20090121  Extender_t (      
    .Imm                     ( Imm          ),
    .Extop                   ( Extop        ),

    .Ext_result              ( Ext_result   ) 
);

ALU_20090121  ALU_t (
    .ALUSrc                  ( ALUSrc       ),
    .ALUop                   ( ALUop        ),
    .rs_in                   ( rs_out       ),
    .rt_in                   ( rt_out       ),
    .imm_in                  ( Ext_result   ),

    .zero                    ( zero         ),
    .result                  ( data_alu     ),
    .overflow                ( overflow     ),
    .condition               ( condition    )
);


DM_20090121  DM_t (
    .clk                     ( clk         ),
    .MemWrite                ( MemWrite    ),
    .reset                   ( reset       ),
    .pc_alu                  ( data_alu    ),
    .data_rt                 ( rt_out      ),
    .pc_new                  ( pc_new      ),

    .data_out                ( data_dm     ),
    .AddressError            ( AddressError)
);

endmodule
