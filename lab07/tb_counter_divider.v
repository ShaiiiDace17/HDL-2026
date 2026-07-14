`timescale 1ns / 1ps

module tb_counter_divider;
    reg clk;
    reg reset;
    wire [3:0] count;
    wire slow_clk;

    counter_divider uut (.clk(clk), .reset(reset), .count(count), .slow_clk(slow_clk));

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("lab07_counter_divider.vcd");
        $dumpvars(0, tb_counter_divider);

        reset = 1'b1;
        #12;
        reset = 1'b0;
        #300;

        reset = 1'b1;
        #10;
        reset = 1'b0;
        #220;

        $finish;
    end
endmodule
