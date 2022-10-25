`timescale  1ns / 1ns

module tb_mach;

// mach Parameters
parameter PERIOD  = 10;


// mach Inputs
reg   clk                                  = 0 ;
reg   rst                                  = 0 ;
reg   [31:0]  in                           = 0 ;




initial
begin
    clk = 1;
    in = 32'h2009_0121;
    forever #(PERIOD/2)  clk=~clk;
end

mach  u_mach (
    .clk                    ( clk          ),
    .rst                    ( rst          ),
    .in                     ( in           )
);

initial
begin
    //$readmemh("D:/cpu/MultiCycle_cpu/p3/data/main.txt",u_mach.u_mips.u_im.im,'h1000);
    //$readmemh("D:/cpu/MultiCycle_cpu/p3/data/IntReq.txt",u_mach.u_mips.u_im.im,'h0180);
    //  $readmemh("D:/cpu/MultiCycle_cpu/p2/data/data_real/p2-test.txt",u_mach.u_mips.u_im.im,'h1000);
    $readmemh("D:/cpu/MultiCycle_cpu/p2/data/data_extra/bltzal/bltzal.txt",u_mach.u_mips.u_im.im,'h1000);
    rst=1;
    #1 rst=0;
    #20000 in=32'h1234_5678;

    
end

endmodule