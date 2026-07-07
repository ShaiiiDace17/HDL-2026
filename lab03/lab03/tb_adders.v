`timescale 1ns / 1ps

module tb_adders;
    reg a;
    reg b;
    reg cin;
    wire ha_sum;
    wire ha_carry;
    wire sum;
    wire cout;

    reg [3:0] a4;
    reg [3:0] b4;
    reg cin4;
    wire [3:0] sum4;
    wire cout4;

    reg [7:0] a8;
    reg [7:0] b8;
    reg cin8;
    wire [7:0] sum8;
    wire cout8;

    integer i;

    half_adder ha (.a(a), .b(b), .sum(ha_sum), .carry(ha_carry));
    full_adder fa (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));
    adder_4bit add4 (.a(a4), .b(b4), .cin(cin4), .sum(sum4), .cout(cout4));
    adder_8bit add8 (.a(a8), .b(b8), .cin(cin8), .sum(sum8), .cout(cout8));

    initial begin
        $dumpfile("lab03_adders.vcd");
        $dumpvars(0, tb_adders);

        $display("Full adder truth table");
        $display("a b cin | sum cout");

        for (i = 0; i < 8; i = i + 1) begin
            {a, b, cin} = i[2:0];
            #10;
            $display("%b %b  %b  |  %b    %b", a, b, cin, sum, cout);
        end

        $display("");
        $display("4-bit adder checks");
        a4 = 4'd3;  b4 = 4'd5;  cin4 = 1'b0; #10;
        $display("%d + %d + %d = %d carry=%b", a4, b4, cin4, sum4, cout4);

        a4 = 4'd9;  b4 = 4'd7;  cin4 = 1'b0; #10;
        $display("%d + %d + %d = %d carry=%b", a4, b4, cin4, sum4, cout4);

        a4 = 4'd15; b4 = 4'd15; cin4 = 1'b1; #10;
        $display("%d + %d + %d = %d carry=%b", a4, b4, cin4, sum4, cout4);

        $display("");
        $display("8-bit adder checks");
        a8 = 8'd10;   b8 = 8'd20;   cin8 = 1'b0; #10;
        $display("%d + %d + %d = %d carry=%b", a8, b8, cin8, sum8, cout8);

        a8 = 8'd100;  b8 = 8'd55;   cin8 = 1'b0; #10;
        $display("%d + %d + %d = %d carry=%b", a8, b8, cin8, sum8, cout8);

        a8 = 8'd200;  b8 = 8'd150;  cin8 = 1'b0; #10;
        $display("%d + %d + %d = %d carry=%b", a8, b8, cin8, sum8, cout8);

        a8 = 8'd255;  b8 = 8'd255;  cin8 = 1'b1; #10;
        $display("%d + %d + %d = %d carry=%b", a8, b8, cin8, sum8, cout8);

        $finish;
    end
endmodule
