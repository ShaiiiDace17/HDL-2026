`timescale 1ns / 1ps

module tb_mux_decoder;
    reg [3:0] data;
    reg [7:0] data8;
    reg [1:0] sel;
    reg [2:0] sel8;
    reg enable;
    wire mux_y;
    wire mux8_y;
    wire [3:0] dec_y;

    integer i;

    mux4to1 mux (.data(data), .sel(sel), .y(mux_y));
    mux8to1 mux8 (.data(data8), .sel(sel8), .y(mux8_y));
    decoder2to4 dec (.sel(sel), .enable(enable), .y(dec_y));

    initial begin
        $dumpfile("lab04_mux_decoder.vcd");
        $dumpvars(0, tb_mux_decoder);

        data = 4'b1010;
        data8 = 8'b10101100;
        sel = 2'b00;
        sel8 = 3'b000;
        enable = 1'b1;
        #1;

        $display("data sel enable | mux_y dec_y");
        for (i = 0; i < 4; i = i + 1) begin
            sel = i[1:0];
            #10;
            $display("%b  %b    %b    |   %b   %b", data, sel, enable, mux_y, dec_y);
        end

        enable = 1'b0;
        for (i = 0; i < 4; i = i + 1) begin
            sel = i[1:0];
            #10;
            $display("%b  %b    %b    |   %b   %b", data, sel, enable, mux_y, dec_y);
        end

        data8 = 8'b10101100;

        $display("");
        $display("8-to-1 mux challenge");
        $display("data8    sel8 | mux8_y");
        for (i = 0; i < 8; i = i + 1) begin
            sel8 = i[2:0];
            #10;
            $display("%b  %b  |   %b", data8, sel8, mux8_y);
        end

        $finish;
    end
endmodule
