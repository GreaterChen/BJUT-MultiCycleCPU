
`timescale 1ns / 1ps

module ifu(clk,reset,npc_sel,zero,insout,j,t0,rs_in,jal,jr);
    input clk,reset,npc_sel,zero,j,jal,jr;
    output [31:0]insout;      //指令输出
    output [31:0]t0,rs_in;
    reg [31:0]pc;               //指针
    reg [7:0]im[1023:0];       //指令寄存器
    wire [31:0]pc_new,t2,t1,extout,temp;
    wire [15:0]imm;
    assign insout={im[pc[9:0]],im[pc[9:0]+1],im[pc[9:0]+2],im[pc[9:0]+3]};
    assign imm=insout[15:0];
    assign temp={ {16{imm[15]}} , imm };
    assign extout=temp<<2;

    assign t0=pc+4;
    assign t1=t0+extout;
    assign t2={t0[31:28],insout[25:0],2'b00};
    assign pc_new = jr? rs_in : ( (j||jal)? t2:( (npc_sel&&zero)?t1:t0 ) );
    
    always@(posedge clk,posedge reset)  
    begin
        if(reset) pc=32'h0000_3000;
        else pc=pc_new;
    end
    

 endmodule

 