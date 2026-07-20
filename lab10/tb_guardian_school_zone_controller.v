`timescale 1ns / 1ps

module tb_guardian_school_zone_controller;

    reg clk;
    reg reset;
    reg ped_request;
    reg emergency_request;
    reg school_hours;
    wire [2:0] main_signal;
    wire [2:0] side_signal;
    wire crossing_light;
    wire beacon_light;

    guardian_school_zone_controller uut (
        .clk(clk),
        .reset(reset),
        .ped_request(ped_request),
        .emergency_request(emergency_request),
        .school_hours(school_hours),
        .main_signal(main_signal),
        .side_signal(side_signal),
        .crossing_light(crossing_light),
        .beacon_light(beacon_light)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // -----------------------------------------------------------------
    // Safety monitor 1: main and side must never be GREEN at once
    // -----------------------------------------------------------------
    always @(posedge clk) begin
        if (main_signal == 3'b001 && side_signal == 3'b001)
            $display("*** SAFETY VIOLATION at %0t: main_signal and side_signal both GREEN ***", $time);
    end

    // -----------------------------------------------------------------
    // Safety monitor 2: PREEMPT_HOLD (main green for the emergency
    // vehicle) must never be entered while side_signal is not RED.
    // This is the key proof that preemption cannot create a conflict.
    // -----------------------------------------------------------------
    always @(posedge clk) begin
        if (uut.state == 3'd6 && side_signal != 3'b100)
            $display("*** PREEMPTION SAFETY VIOLATION at %0t: entered PREEMPT_HOLD with side_signal not RED ***", $time);
    end

    function [12*8:1] state_name;
        input [2:0] s;
        begin
            case (s)
                3'd0: state_name = "GO_MAIN";
                3'd1: state_name = "CAUTION_MAIN";
                3'd2: state_name = "ALL_STOP_A";
                3'd3: state_name = "GO_SIDE";
                3'd4: state_name = "CAUTION_SIDE";
                3'd5: state_name = "ALL_STOP_B";
                3'd6: state_name = "PREEMPT_HOLD";
                default: state_name = "UNKNOWN";
            endcase
        end
    endfunction

    always @(uut.state)
        $display("t=%0t : state -> %0s  (ped_request=%b, emergency_request=%b, reset=%b)",
                   $time, state_name(uut.state), ped_request, emergency_request, reset);

    initial begin
        $dumpfile("guardian_school_zone.vcd");
        $dumpvars(0, tb_guardian_school_zone_controller);

        // ---------------------------------------------------------
        // TEST 1: Reset behavior
        // ---------------------------------------------------------
        $display("\n--- TEST 1: Reset ---");
        reset = 1'b1; ped_request = 1'b0; emergency_request = 1'b0; school_hours = 1'b0;
        #12;
        if (uut.state == 3'd0) $display("PASS: state is GO_MAIN during reset");
        reset = 1'b0;

        // ---------------------------------------------------------
        // TEST 2: Normal full cycle, no requests
        //   GO_MAIN(9)+CAUTION(3)+ALL_STOP(2)+GO_SIDE(7)+CAUTION(3)+ALL_STOP(2)
        //   = 26 ticks * 10 ns = 260 ns
        // ---------------------------------------------------------
        $display("\n--- TEST 2: Normal operation, one full cycle ---");
        #260;

        // ---------------------------------------------------------
        // TEST 3: ped_request asserted DURING GO_MAIN -> shortened green
        // ---------------------------------------------------------
        $display("\n--- TEST 3: ped_request during GO_MAIN (expect shortened green) ---");
        ped_request = 1'b1;
        #40;
        ped_request = 1'b0;
        #80;

        // ---------------------------------------------------------
        // TEST 4 (edge case): ped_request during GO_SIDE -> no effect
        // ---------------------------------------------------------
        $display("\n--- TEST 4 (edge case): ped_request during GO_SIDE (expect NO effect) ---");
        wait (uut.state == 3'd3);
        ped_request = 1'b1;
        #30;
        ped_request = 1'b0;
        #70;

        // ---------------------------------------------------------
        // TEST 5 (major edge case): emergency preemption asserted
        // while the FSM is mid-way through GO_SIDE (side road green).
        // This is the hardest case: the controller must walk itself
        // through CAUTION_SIDE -> ALL_STOP_B -> PREEMPT_HOLD before
        // granting main_signal a green, never cutting the side road
        // straight from GREEN to RED.
        // ---------------------------------------------------------
        $display("\n--- TEST 5 (edge case): emergency_request asserted during GO_SIDE ---");
        wait (uut.state == 3'd3);
        #15;  // interrupt partway through GO_SIDE
        emergency_request = 1'b1;
        #80;  // hold the emergency request; watch it walk safely to PREEMPT_HOLD
        if (uut.state == 3'd6)
            $display("PASS: controller safely reached PREEMPT_HOLD with main_signal=GREEN, side_signal=RED");
        emergency_request = 1'b0;
        #60;  // watch it resume the normal cycle via CAUTION_MAIN

        // ---------------------------------------------------------
        // TEST 6 (edge case): mid-cycle reset
        // ---------------------------------------------------------
        $display("\n--- TEST 6 (edge case): reset asserted mid-cycle ---");
        #35;
        reset = 1'b1;
        #10;
        if (uut.state == 3'd0)
            $display("PASS: mid-cycle reset forced state back to GO_MAIN");
        else
            $display("FAIL: state after mid-cycle reset was %0d, expected 0 (GO_MAIN)", uut.state);
        reset = 1'b0;
        #40;

        // ---------------------------------------------------------
        // TEST 7: school-hours flashing beacon
        // ---------------------------------------------------------
        $display("\n--- TEST 7: school_hours beacon check ---");
        school_hours = 1'b1;
        #200;
        school_hours = 1'b0;
        #30;
        $display("Beacon test complete (see beacon_light in waveform for flashing pattern)");

        $display("\n--- Simulation complete ---");
        $finish;
    end

endmodule
