// func
`define addu  12'b000000_100001
`define subu  12'b000000_100011
`define slt   12'b000000_101010
`define jr    12'b000000_001000
 
// Opcode
`define ori   12'b001101_xxxxxx
`define lw    12'b100011_xxxxxx
`define sw    12'b101011_xxxxxx
`define beq   12'b000100_xxxxxx
`define lui   12'b001111_xxxxxx
`define j     12'b000010_xxxxxx
`define addi  12'b001000_xxxxxx
`define addiu 12'b001001_xxxxxx
`define jal   12'b000011_xxxxxx
`define bgtz  12'b000111_xxxxxx
`define lb    12'b100000_xxxxxx
`define sb    12'b101000_xxxxxx




// func
`define addu_f    6'b100001
`define subu_f    6'b100011
`define slt_f     6'b101010
`define jr_f      6'b001000
   
// OpCode  
`define ori_o     6'b001101
`define lw_o      6'b100011
`define sw_o      6'b101011
`define beq_o     6'b000100
`define lui_o     6'b001111
`define j_o       6'b000010
`define addi_o    6'b001000
`define addiu_o   6'b001001
`define jal_o     6'b000011
`define bgtz_o    6'b000111
`define lb_o      6'b100000
`define sb_o      6'b101000
  
`define CP0_o     6'b010000
`define bgez_o    6'b000001
`define bltzal_o  6'b000001
  
//rs  
`define MTC0_rs   6'b00100
`define MFC0_rs   6'b00000
`define ERET_rs   6'b10000
  
  
//rt  
`define bgez_rt   6'b00001
`define bltzal_rt 6'b10000
