`timescale 1ns / 1ps

module comparator4(
    input [3:0] a,
    input [3:0] b,
    output eq,
    output gt,
    output lt
);
    assign eq = (a == b);
    assign gt = (a > b);
    assign lt = (a < b);
endmodule

module alu4(
    input [3:0] a,
    input [3:0] b,
    input [2:0] op,
    output reg [3:0] result,
    output zero
);
    always @(*) begin
        case (op)
            3'b000: result = a + b;
            3'b001: result = a - b;
            3'b010: result = a & b;
            3'b011: result = a | b;
            3'b100: result = ~a;
            default: result = 4'b0000;
        endcase
    end

    assign zero = (result == 4'b0000);
endmodule
