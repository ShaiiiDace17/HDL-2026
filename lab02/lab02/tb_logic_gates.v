`timescale 1ns / 1ps

module tb_logic_gates;
    reg a;
    reg b;
    wire and_y;
    wire or_y;
    wire not_a_y;
    wire xor_y;
    wire xnor_y;
    wire nand_y;
    wire nor_y;

    integer i;

    logic_gates uut (
        .a(a),
        .b(b),
        .and_y(and_y),
        .or_y(or_y),
        .not_a_y(not_a_y),
        .xor_y(xor_y),
        .xnor_y(xnor_y),
        .nand_y(nand_y),
        .nor_y(nor_y)
    );

    initial begin
        $dumpfile("lab02_logic_gates.vcd");
        $dumpvars(0, tb_logic_gates);

        $display("a b | and or not_a xor xnor nand nor");
        $display("------------------------------------");

        for (i = 0; i < 4; i = i + 1) begin
            {a, b} = i[1:0];
            #10;
            $display("%b %b |  %b   %b    %b    %b    %b    %b    %b",
                a, b, and_y, or_y, not_a_y, xor_y, xnor_y, nand_y, nor_y);
        end

        $finish;
    end
endmodule
