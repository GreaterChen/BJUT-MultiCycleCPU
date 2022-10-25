module filter(
    input clk,rst,

    output reg clk_1k
);

    parameter NUM_DIV = 100000;
    reg [16:0] cnt;

    always@(posedge clk ,posedge rst)
    begin
        if(rst) begin cnt<=0; clk_1k<=0; end
        else begin
            if(cnt<NUM_DIV/2-1)
            begin
                cnt<=cnt+1;
                clk_1k<=clk_1k;
            end
            else
            begin 
                cnt<=0;
                clk_1k<=~clk_1k;
            end
        end
    end


endmodule
