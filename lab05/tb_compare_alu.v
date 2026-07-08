`timescale 1ns / 1ps

module tb_compare_alu;
    reg [3:0] a;
    reg [3:0] b;
    reg [2:0] op;
    wire [3:0] result;
    wire zero;
    wire eq;
    wire gt;
    wire lt;

    integer i;

    comparator4 cmp (.a(a), .b(b), .eq(eq), .gt(gt), .lt(lt));
    alu4 alu (.a(a), .b(b), .op(op), .result(result), .zero(zero));

    initial begin
        $dumpfile("lab05_compare_alu.vcd");
        $dumpvars(0, tb_compare_alu);

        a = 4'd9;
        b = 4'd3;
        $display("a b op  | result zero eq gt lt");

        for (i = 0; i < 5; i = i + 1) begin
            op = i[2:0];
            #10;
            $display("%d %d %b |   %d     %b   %b  %b  %b",
                a, b, op, result, zero, eq, gt, lt);
        end

        a = 4'd5;
        b = 4'd5;
        op = 3'b001;
        #10;
        $display("%d %d %b |   %d     %b   %b  %b  %b",
            a, b, op, result, zero, eq, gt, lt);

        $finish;
    end
endmodule
