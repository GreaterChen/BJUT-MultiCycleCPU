module bridge (
    input [31:0]PrAddr, //cpu传入的地址
    input [31:0]PrWD,   //cpu欲写入的内容
    input [31:0]dev0_rd,dev1_rd,dev2_rd, //外部设备欲写入的数据
    input IRQ, //计时器的中断信号
    input wecpu, //来自cpu的写使能
    
    output we_dev0,we_dev2,  //给计时器和输出设备的写使能
    output [5:0]HWInt, //6个中断信号
    output [31:0]PrRD,  //写入cpu的内容
    output [31:0]DEV_WD,
    output [1:0]DEV_addr
);

    //向外设分发写使能信号
    assign we_dev0 = wecpu && (PrAddr[31:4] == 'h0000_7F0);
    assign we_dev2 = wecpu && (PrAddr[31:4] == 'h0000_7F2);

    //向外设分发写入数据
    assign DEV_WD = PrWD;

    //选择PrRD的外设来源
    wire Hit_dev0,Hit_dev1,Hit_dev2;  
    assign Hit_dev0 = (PrAddr[31:4] == 'h0000_7F0);
    assign Hit_dev1 = (PrAddr[31:4] == 'h0000_7F1);
    assign Hit_dev2 = (PrAddr[31:4] == 'h0000_7F2);
    assign PrRD = (Hit_dev0)?dev0_rd:(Hit_dev1)?dev1_rd:(Hit_dev2)?dev2_rd:32'hffff_ffff;

    assign DEV_addr = PrAddr[3:2];

    //从Timer来的中断请求
    assign HWInt = {5'b0,IRQ};

    
endmodule