`timescale 1ns / 1ps

module tb_traffic_light_controller;
    reg clk;
    reg reset;
    reg ped_request;
    wire walk_light;
    wire [2:0] main_light;
    wire [2:0] side_light;

    traffic_light_controller uut (
        .clk(clk),
        .reset(reset),
        .ped_request(ped_request),
        .main_light(main_light),
        .side_light(side_light),
        .walk_light(walk_light)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("lab10_traffic_light.vcd");
        $dumpvars(0, tb_traffic_light_controller);
        $display("walk_light will appear in the VCD and should be high only during side-green");

        reset = 1'b1;
        ped_request = 1'b0;
        #12;

        reset = 1'b0;
        #90;

        ped_request = 1'b1;
        #40;

        ped_request = 1'b0;
        #100;

        reset = 1'b1;
        #10;
        reset = 1'b0;
        #40;

        $finish;
    end
endmodule
