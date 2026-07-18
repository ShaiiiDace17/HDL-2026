`timescale 1ns / 1ps

module tb_sequence_detector;
    reg clk;
    reg reset;
    reg bit_in;
    wire detected;

    reg [15:0] stream;
    integer i;

    sequence_detector uut (
        .clk(clk),
        .reset(reset),
        .bit_in(bit_in),
        .detected(detected)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("lab09_sequence_detector.vcd");
        $dumpvars(0, tb_sequence_detector);

        reset = 1'b1;
        bit_in = 1'b0;
        stream = 16'b1011_0110_1011_1011;
        #12;
        reset = 1'b0;

        for (i = 15; i >= 0; i = i - 1) begin
            bit_in = stream[i];
            #10;
            $display("bit=%b detected=%b", bit_in, detected);
        end

        $finish;
    end
endmodule
