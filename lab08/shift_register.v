`timescale 1ns / 1ps

module shift_register4(
    input clk,
    input reset,
    input load,
    input direction,
    input serial_in,
    input [3:0] parallel_in,
    output reg [3:0] q,
    output serial_out
);
    // direction = 0: shift right; direction = 1: shift left
    assign serial_out = direction ? q[3] : q[0];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 4'b0000;
        end else if (load) begin
            q <= parallel_in;
        end else if (direction) begin
            q <= {q[2:0], serial_in};
        end else begin
            q <= {serial_in, q[3:1]};
        end
    end
endmodule
