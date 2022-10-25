module input_equip(
    input [31:0] din,
    output [31:0] dout
);

    reg [31:0] data_in;

    always@(*)
    begin
        data_in = din;
    end

    assign dout = data_in;

endmodule