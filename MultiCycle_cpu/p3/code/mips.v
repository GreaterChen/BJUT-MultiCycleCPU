module mips(clk,rst,PrAddr,PrRD,PrWD,wecpu,HWInt);
    input clk;
    input rst;
    input [5:0] HWInt;
    input [31:0] PrRD;

    output wecpu;
    output [31:0]PrAddr,PrWD;

wire        zero,overflow,ALU_Src,Reg_Write,Mem_Write,Pc_Write,IR_Write,condition,lb_sign,sb_sign,IntReq,CP0_wr,EPC_wr,EXL_set,bltzal_sign;
wire [1:0]  Reg_Dst,Ext_op;
wire [2:0]  ALU_op,Mem_to_Reg,nPC_op;
wire [4:0]  shamt,rs,rt,rd;
wire [5:0]  OpCode,func;
wire [15:0] Imm;
wire [23:0] pre_dm;
wire [25:0] Imm_abs;
wire [31:0] t0,pc_now,pc_next,rs_out,rt_out,Ext_out,dout_ins,dout_dm,data_dm,data_alu,rs_into_A,rt_into_B,rt_out_pro,data_CP0,EPC;
wire [32:0] result_alu;

assign PrWD = rt_out;
assign PrAddr = data_alu; 

Controller_Mul #(
    .IF      ( 4'b0000 ),
    .ID      ( 4'b0001 ),
    .EXE_ls  ( 4'b0010 ),
    .MEM_sa  ( 4'b0011 ),
    .MEM_ld  ( 4'b0100 ),
    .WB_dm   ( 4'b0101 ),
    .EXE_com ( 4'b0110 ),
    .EXE_cal ( 4'b0111 ),
    .WB_cal  ( 4'b1000 ),
    .WB_jal  ( 4'b1001 ),
    .EXE_jr  ( 4'b1010 ),
    .BRANCH  ( 4'b1011 ),
    .INT     ( 4'b1100 ))
 u_Controller_Mul (
    .clk                     ( clk                ),
    .reset                   ( rst                ),
    .zero                    ( zero               ),
    .overflow                ( overflow           ),
    .OpCode                  ( OpCode             ),
    .func                    ( func               ),
    .rs                      ( rs                 ),
    .rt                      ( rt                 ),
    .IntReq                  ( IntReq             ),
    .addr                    ( data_alu           ),
    .bltzal_sign             ( bltzal_sign        ),

    .ALU_Src                 ( ALU_Src      ),
    .Reg_Write               ( Reg_Write    ),
    .Mem_Write               ( Mem_Write    ),
    .Pc_Write                ( Pc_Write     ),
    .IR_Write                ( IR_Write     ),
    .Ext_op                  ( Ext_op       ),
    .Reg_Dst                 ( Reg_Dst      ),
    .nPC_op                  ( nPC_op       ),
    .Mem_to_Reg              ( Mem_to_Reg   ),
    .ALU_op                  ( ALU_op       ),
    .lb_sign                 ( lb_sign      ),
    .sb_sign                 ( sb_sign      ),
    .wecpu                   ( wecpu        ), 

    .cp0_wr                  ( CP0_wr       ),
    .EPC_wr                  ( EPC_wr       ),
    .EXL_set                 ( EXL_set      ),
    .EXL_clr                 ( EXL_clr      )
);

CP0  u_CP0 (
    .clk                     ( clk       ),
    .rst                     ( rst       ),
    .din                     ( rt_out    ),
    .PC                      ( pc_now    ),
    .HWInt                   ( HWInt     ),
    .sel                     ( rd        ),
    .EPC_wr                  ( EPC_wr    ),
    .CP0_wr                  ( CP0_wr    ),
    .EXL_set                 ( EXL_set   ),
    .EXL_clr                 ( EXL_clr   ),

    .EPC                     ( EPC       ),
    .dout                    ( data_CP0  ),
    .IntReq                  ( IntReq    )
);

nPc  u_nPc (
    .rst                     ( rst       ),
    .nPC_op                  ( nPC_op    ),
    .pc_now                  ( pc_now    ),
    .pc_jr                   ( rs_out    ),
    .imm_com                 ( Imm       ),
    .imm_abs                 ( Imm_abs   ),
    .EPC                     ( EPC       ),

    .pc_next                 ( pc_next   )
);

Pc  u_Pc (
    .clk                     ( clk           ),
    .rst                     ( rst           ),
    .Pc_Write                ( Pc_Write      ),
    .pc_next                 ( pc_next       ),

    .pc                      ( pc_now        )
);

im  u_im (
    .addr                    ( pc_now[12:0]   ),

    .dout                    ( dout_ins      ) 
);

IR  u_IR (
    .clk                     ( clk              ),
    .IR_Write                ( IR_Write         ),
    .ins                     ( dout_ins         ),

    .OpCode                  ( OpCode           ),
    .func                    ( func             ),
    .shamt                   ( shamt            ),
    .rt                      ( rt               ),
    .rd                      ( rd               ),
    .rs                      ( rs               ),
    .Imm                     ( Imm              ),
    .Imm_abs                 ( Imm_abs          )
);

RegFile  u_RegFile (
    .reset                   ( rst            ),
    .clk                     ( clk            ),
    .Reg_Write               ( Reg_Write      ),
    .Mem_to_Reg              ( Mem_to_Reg     ),
    .Reg_Dst                 ( Reg_Dst        ),
    .data_dm                 ( data_dm        ),
    .t0                      ( pc_now         ),
    .data_alu                ( data_alu       ),
    .rs                      ( rs             ),
    .rt                      ( rt             ),
    .rd                      ( rd             ),
    .data_CP0                ( data_CP0       ),
    .data_PrRD               ( PrRD           ),

    .rs_out                  ( rs_into_A      ),
    .rt_out                  ( rt_into_B      )

);

Temp_Reg_A  u_Temp_Reg_A (
    .clk                     ( clk          ),
    .data_in                 ( rs_into_A    ),

    .data_out                ( rs_out       ) 
);

Temp_Reg_B  u_Temp_Reg_B (
    .clk                     ( clk          ),
    .data_in                 ( rt_into_B    ),

    .data_out                ( rt_out       ) 
);

Extender  u_Extender (
    .Imm                     ( Imm          ),
    .Ext_op                  ( Ext_op       ),

    .Ext_result              ( Ext_out      )
);

ALU  u_ALU (
    .ALU_Src                 ( ALU_Src      ),
    .ALU_op                  ( ALU_op       ),
    .rs_in                   ( rs_out       ),
    .rt_in                   ( rt_out       ),
    .imm_in                  ( Ext_out      ),

    .overflow                ( overflow     ),
    .zero                    ( zero         ),
    .result                  ( result_alu   ),
    .bltzal_sign             ( bltzal_sign  )
);

Temp_Reg_ALU  u_Temp_Reg_ALU (
    .clk                     ( clk                ),
    .data_in                 ( result_alu[31:0]   ),

    .data_out                ( data_alu           )
);

sb  u_sb (
    .sb_sign                 ( sb_sign             ),
    .data_in                 ( rt_out              ),
    .pre_dm                  ( dout_dm[31:8]       ),

    .data_out                ( rt_out_pro          )
);

dm  u_dm (
    .addr                    ( data_alu[13:0]   ),
    .din                     ( rt_out_pro       ),
    .we                      ( Mem_Write        ),
    .clk                     ( clk              ),

    .dout                    ( dout_dm          )
);

Temp_Reg_DM  u_Temp_Reg_DM (  
    .clk                     ( clk             ),
    .data_in                 ( dout_dm         ),
    .lb_sign                 ( lb_sign         ),

    .data_out                ( data_dm         )
);


endmodule