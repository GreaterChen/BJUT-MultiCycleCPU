module timer (
    input clk_i,rst_i,we_i,clk,
    input [3:2]addr_i,
    input [31:0]data_in,

    output [31:0]data_out,
    output reg IRQ
);
    reg [31:0]CTRL,PRESET,COUNT;

    always@(posedge clk)
    begin
        if(we_i)
           begin
               case(addr_i)  
                   2'b00: CTRL<=data_in;
                   2'b01: begin PRESET<=data_in;COUNT<=data_in; end
               endcase
           end
    end
    
    always @(posedge clk,posedge rst_i) 
    begin
        if(rst_i) begin CTRL<=0;PRESET<=0;IRQ<=0; COUNT<=0;end
        else
        begin
            if(CTRL[2:1]==2'b00)
            begin
                if(COUNT!=0 && CTRL[0]==1) COUNT<=COUNT-1;
                if(COUNT==0)
                begin
                    CTRL[0]<=0;
                    if(CTRL[3]==1)
                    begin
                        IRQ<=1;
                        CTRL[3]<=0;
                    end
                end
            end

            if(CTRL[2:1]==2'b01)
            begin
                if(COUNT!=0 && CTRL[0]==1) COUNT<=COUNT-1;
                if(COUNT==0)
                begin
                    COUNT<=PRESET;
                    if(CTRL[3]==1)  IRQ<=1;
                end
            end

            if(IRQ==1) IRQ<=0;
        end
        
    end
    
endmodule