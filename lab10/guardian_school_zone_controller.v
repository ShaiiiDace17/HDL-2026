`timescale 1ns / 1ps

// GUARDIAN Smart School-Zone Intersection Controller
// Individual capstone extension of the base Lab 10 traffic-light FSM
// =====================================================================
//
// This design intentionally departs from the base Lab 10 controller in
// naming, timing, and functionality, in three ways:
//
//   (1) SAFE ALL-STOP BUFFERS
//       ALL_STOP_A / ALL_STOP_B states insert a full red-red buffer
//       between every caution (yellow) phase and the next green phase,
//       so there is never a hard dependency on exact timing alignment
//       for safety.
//
//   (2) EMERGENCY-VEHICLE PREEMPTION (emergency_request)
//       When emergency_request is asserted, the FSM does NOT jump
//       straight to a main-road green. Instead it walks itself through
//       whatever safe intermediate states are required from its
//       CURRENT position before granting PREEMPT_HOLD (main green,
//       side red held indefinitely). This guarantees the side road is
//       always fully cleared (red) before the main road ever gets
//       priority green, no matter which state preemption was requested
//       from. When emergency_request drops, the controller resumes the
//       normal cycle safely (via a caution phase) rather than jumping
//       back into an arbitrary state.
//
//   (3) SCHOOL-HOURS FLASHING BEACON (school_hours / beacon_light)
//       An independent small counter drives a flashing beacon_light
//       whenever school_hours is asserted, modeling the flashing
//       reduced-speed warning beacon used at real school zones during
//       arrival/dismissal. This runs completely independently of the
//       intersection FSM.
//
// Pedestrian crossing behavior (ped_request / crossing_light):
//   ped_request is honored only while the FSM is in GO_MAIN: it
//   shortens that interval from 9 ticks to 5 ticks. Asserting it during
//   any other state has no effect (there is nothing to shorten), which
//   is demonstrated as an explicit edge case in the testbench.
//   crossing_light is asserted early, during ALL_STOP_A, and stays on
//   through GO_SIDE, giving pedestrians a head start once all vehicle
//   traffic has fully stopped.
// =====================================================================

module guardian_school_zone_controller(
    input  clk,
    input  reset,
    input  ped_request,
    input  emergency_request,   // priority override for emergency vehicles
    input  school_hours,        // asserted during arrival/dismissal windows
    output reg [2:0] main_signal,
    output reg [2:0] side_signal,
    output reg       crossing_light,
    output reg       beacon_light);

    // Signal-head encodings
    localparam RED    = 3'b100;
    localparam YELLOW = 3'b010;
    localparam GREEN  = 3'b001;

    // FSM states
    localparam GO_MAIN      = 3'd0;
    localparam CAUTION_MAIN = 3'd1;
    localparam ALL_STOP_A   = 3'd2;
    localparam GO_SIDE      = 3'd3;
    localparam CAUTION_SIDE = 3'd4;
    localparam ALL_STOP_B   = 3'd5;
    localparam PREEMPT_HOLD = 3'd6;   // emergency priority hold

    // Timing, in clock ticks (deliberately distinct from Lab 10 values)
    localparam GO_MAIN_NORMAL_TICKS = 4'd9;
    localparam GO_MAIN_PED_TICKS    = 4'd5;
    localparam CAUTION_TICKS        = 4'd3;
    localparam ALL_STOP_TICKS       = 4'd2;
    localparam GO_SIDE_TICKS        = 4'd7;

    reg [2:0] state;
    reg [3:0] timer;
    reg [3:0] limit;

    // -----------------------------------------------------------------
    // Output / limit decode (combinational)
    // -----------------------------------------------------------------
    always @(*) begin
        crossing_light = 1'b0;
        case (state)
            GO_MAIN: begin
                main_signal = GREEN;
                side_signal = RED;
                limit = ped_request ? GO_MAIN_PED_TICKS : GO_MAIN_NORMAL_TICKS;
            end
            CAUTION_MAIN: begin
                main_signal = YELLOW;
                side_signal = RED;
                limit = CAUTION_TICKS;
            end
            ALL_STOP_A: begin
                main_signal = RED;
                side_signal = RED;
                crossing_light = 1'b1;   // early crossing head-start
                limit = ALL_STOP_TICKS;
            end
            GO_SIDE: begin
                main_signal = RED;
                side_signal = GREEN;
                crossing_light = 1'b1;
                limit = GO_SIDE_TICKS;
            end
            CAUTION_SIDE: begin
                main_signal = RED;
                side_signal = YELLOW;
                limit = CAUTION_TICKS;
            end
            ALL_STOP_B: begin
                main_signal = RED;
                side_signal = RED;
                limit = ALL_STOP_TICKS;
            end
            PREEMPT_HOLD: begin
                main_signal = GREEN;    // held for the emergency vehicle
                side_signal = RED;
                limit = 4'd1;           // unused: exit is event-driven, not timer-driven
            end
            default: begin
                main_signal = GREEN;    // safe recovery on illegal state
                side_signal = RED;
                limit = GO_MAIN_NORMAL_TICKS;
            end
        endcase
    end

    // -----------------------------------------------------------------
    // State / timer register (sequential, asynchronous reset,
    // emergency_request has priority over normal timed transitions)
    // -----------------------------------------------------------------
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= GO_MAIN;
            timer <= 4'd0;
        end else if (emergency_request) begin
            // Priority path: always step toward a state where the side
            // road is fully RED before ever granting PREEMPT_HOLD.
            timer <= 4'd0;
            case (state)
                GO_SIDE:      state <= CAUTION_SIDE;  // side must clear through caution first
                CAUTION_SIDE: state <= ALL_STOP_B;     // then a full red-red buffer
                ALL_STOP_B:   state <= PREEMPT_HOLD;   // now safe: side is red
                CAUTION_MAIN: state <= ALL_STOP_A;     // main must clear its own caution first
                ALL_STOP_A:   state <= PREEMPT_HOLD;   // already all-red: safe
                GO_MAIN:      state <= PREEMPT_HOLD;   // side already red: safe immediately
                PREEMPT_HOLD: state <= PREEMPT_HOLD;   // hold for as long as requested
                default:      state <= ALL_STOP_A;
            endcase
        end else if (state == PREEMPT_HOLD) begin
            // Emergency just cleared: resume the normal cycle safely,
            // through a caution phase rather than jumping back in.
            state <= CAUTION_MAIN;
            timer <= 4'd0;
        end else if (timer >= limit - 4'd1) begin
            timer <= 4'd0;
            case (state)
                GO_MAIN:      state <= CAUTION_MAIN;
                CAUTION_MAIN: state <= ALL_STOP_A;
                ALL_STOP_A:   state <= GO_SIDE;
                GO_SIDE:      state <= CAUTION_SIDE;
                CAUTION_SIDE: state <= ALL_STOP_B;
                ALL_STOP_B:   state <= GO_MAIN;
                default:      state <= GO_MAIN;
            endcase
        end else begin
            timer <= timer + 4'd1;
        end
    end

    // -----------------------------------------------------------------
    // School-hours flashing beacon: fully independent of the main FSM
    // -----------------------------------------------------------------
    reg [3:0] beacon_counter;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            beacon_counter <= 4'd0;
            beacon_light   <= 1'b0;
        end else if (school_hours) begin
            if (beacon_counter >= 4'd4) begin
                beacon_counter <= 4'd0;
                beacon_light   <= ~beacon_light;
            end else begin
                beacon_counter <= beacon_counter + 4'd1;
            end
        end else begin
            beacon_counter <= 4'd0;
            beacon_light   <= 1'b0;
        end
    end

endmodule
