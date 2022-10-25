module dm(addr,din,we,clk,dout,pre_dm);
    input [9:0] addr;
    input [31:0] din;   //rt内容
    input we;
    input clk;
    output [31:0] dout;
    output [23:0] pre_dm;
    reg [7:0] dm[1023:0];
    integer i;

    initial begin
        for(i=0;i<1024;i=i+1) dm[i]<=8'b0;
    end

    `define little_endian {dm[addr+3],dm[addr+2],dm[addr+1],dm[addr]}    //小端序存储
    assign dout = `little_endian;
    assign pre_dm = {dm[addr+3],dm[addr+2],dm[addr+1]};


    always@(posedge clk)
    begin
        if(we) `little_endian <= din;
    end
     
endmodule