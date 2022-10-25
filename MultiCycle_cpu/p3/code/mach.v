module mach(
    input clk,rst,
    input [31:0] in
);

wire wecpu,we_output_equip,we_timer;
wire [1:0]DEV_addr;
wire [5:0]HWInt;
wire [31:0] PrRD,PrAddr,PrWD,data_timer,data_input_equip,data_output_equip,DEV_WD;

filter #(
    .NUM_DIV ( 100000 ))
 u_filter (
    .clk                     ( clk      ),
    .rst                     ( rst      ),

    .clk_1k                  ( clk_1k   )
);

mips  u_mips (
    .clk                     ( clk      ),
    .rst                     ( rst      ),
    .HWInt                   ( HWInt    ),
    .PrRD                    ( PrRD     ),

    .wecpu                   ( wecpu    ),
    .PrAddr                  ( PrAddr   ),
    .PrWD                    ( PrWD     )
);

bridge  u_bridge (
    .PrAddr                  ( PrAddr               ),
    .PrWD                    ( PrWD                 ),
    .dev0_rd                 ( data_timer           ),
    .dev1_rd                 ( data_input_equip     ),
    .dev2_rd                 ( data_output_equip    ),
    .IRQ                     ( IRQ                  ),
    .wecpu                   ( wecpu                ),

    .we_dev0                 ( we_timer           ),
    .we_dev2                 ( we_output_equip    ),
    .HWInt                   ( HWInt              ),
    .PrRD                    ( PrRD               ),
    .DEV_WD                  ( DEV_WD             ),
    .DEV_addr                ( DEV_addr           )
);

timer  u_timer (
    .clk                     ( clk             ),
    .clk_i                   ( clk_1k          ),
    .rst_i                   ( rst             ),
    .we_i                    ( we_timer        ),
    .addr_i                  ( DEV_addr        ),
    .data_in                 ( DEV_WD          ),

    .data_out                ( data_timer      ),
    .IRQ                     ( IRQ             )
);

input_equip  u_input_equip (
    .din                     ( in                    ),

    .dout                    ( data_input_equip      )
);

output_equip  u_output_equip (
    .clk                     ( clk                 ),
    .rst                     ( rst                 ),
    .WR_en                   ( we_output_equip     ),
    .addr                    ( DEV_addr[0]         ),
    .din                     ( DEV_WD              ),

    .dout                    ( data_output_equip   )
);




    
endmodule