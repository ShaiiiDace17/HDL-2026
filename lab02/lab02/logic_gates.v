`timescale 1ns / 1ps

module logic_gates(
    input a,
    input b,
    output and_y,
    output or_y,
    output not_a_y,
    output xor_y,
    output xnor_y,
    output nand_y,
    output nor_y
);
    assign and_y = a & b;
    assign or_y = a | b;
    assign not_a_y = ~a;
    assign xor_y = a ^ b;
    assign xnor_y = ~(a ^ b);
    assign nand_y = ~(a & b);
    assign nor_y = ~(a | b);
endmodule
