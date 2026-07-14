`timescale 1ns / 1ps

module counter_divider(
    input clk,
    input reset,
    output reg [3:0] count,
    output reg slow_clk
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'd0;
            slow_clk <= 1'b0;
        end else if (count == 4'd4) begin
            count <= 4'd0;
            slow_clk <= ~slow_clk;
        end else begin
            count <= count + 4'd1;
        end
    end
endmodule
