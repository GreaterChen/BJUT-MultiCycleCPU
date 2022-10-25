module CP0(
    input clk,rst,
    input [31:0]din,    //写入cp0的输入
    input [31:0]PC,     //写入下一条pc
    input [5:0]HWInt,   //中断信号
    input [4:0]sel,     //选择4个寄存器中的一个
    input EPC_wr,CP0_wr,  //EPC写使能和CP0写使能
    input EXL_set,EXL_clr,  //EXL置入和清除
    output reg [31:0]EPC,       //将下一条指令还原
    output [31:0]dout,      //输出数据
    output IntReq           //最终的中断信号
);
    //SR寄存器 12
    reg [15:10]IM;  //中断屏蔽信号
    reg EXL,IE;     //进入中断标记以及全局中断信号
    wire [31:0]SR;
    assign SR={16'b0,IM,8'b0,EXL,IE};

    //Cause寄存器 13
    reg [15:10]HWInt_pend; //记录哪些中断有效
    wire [31:0]Cause;
    assign Cause = {16'b0,HWInt_pend,10'b0};

    //PRID寄存器 15
    reg [31:0]PRID;  //实现个性编码
    wire [31:0]prid;
    assign prid = PRID;
    
    //向通用寄存器输出数据
    assign dout = (sel==12)?SR:(sel==13)?Cause:(sel==14)?EPC:(sel==15)?prid:32'b0;

    //中断信号
    assign IntReq = (|HWInt[5:0] & IM[15:10]) & IE & !EXL; 

    always @(posedge clk,posedge rst)
    begin
        if(rst)
        begin
            IM<=0;EXL<=0;IE<=0;PRID<=0;EPC<=0;HWInt_pend<=0;
        end
        else
        begin
            if(EXL_set) EXL<=1;
            if(EXL_clr) begin EXL<=0; HWInt_pend<=0; end   // 在响应结束后要把中断信号置0
            else HWInt_pend<=HWInt;  //不断锁存

            if(CP0_wr) //从通用寄存器写入
            begin
                case(sel)
                    12:
                    begin
                        IM <=din[15:10];
                        EXL<=din[1];
                        IE <=din[0];
                    end
                    15: PRID<=din;
                endcase
                
            end

            if(EPC_wr) EPC<=PC;
        end
        
    end

endmodule