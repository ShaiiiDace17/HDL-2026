`timescale 1ns / 1ps

module tb_shift_register;
    reg clk;
    reg reset;
    reg load;
    reg direction;
    reg serial_in;
    reg [3:0] parallel_in;
    wire [3:0] q;
    wire serial_out;

    shift_register4 uut (
        .clk(clk),
        .reset(reset),
        .load(load),
        .direction(direction),
        .serial_in(serial_in),
        .parallel_in(parallel_in),
        .q(q),
        .serial_out(serial_out)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("lab08_shift_register.vcd");
        $dumpvars(0, tb_shift_register);

        reset = 1'b1;
        load = 1'b0;
        direction = 1'b0;
        serial_in = 1'b0;
        parallel_in = 4'b1011;
        #12;

        reset = 1'b0;
        load = 1'b1;
        #10;

        load = 1'b0;
        serial_in = 1'b1;
        #20;

        serial_in = 1'b0;
        #20;

        serial_in = 1'b1;
        #20;

        // Load again, then demonstrate left shifting.
        load = 1'b1;
        parallel_in = 4'b1011;
        #10;

        load = 1'b0;
        direction = 1'b1;
        serial_in = 1'b0;
        #20;

        $finish;
    end
endmodule
