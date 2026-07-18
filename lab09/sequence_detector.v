`timescale 1ns / 1ps

module sequence_detector(
    input clk,
    input reset,
    input bit_in,
    output reg detected
);
    localparam S0 = 3'd0;
    localparam S1 = 3'd1;
    localparam S11 = 3'd2;
    localparam S110 = 3'd3;
    localparam S1101 = 3'd4;

    reg [2:0] state;
    reg [2:0] next_state;

    always @(*) begin
        case (state)
            S0: next_state = bit_in ? S1 : S0;
            S1: next_state = bit_in ? S11 : S0;
            S11: next_state = bit_in ? S11 : S110;
            S110: next_state = bit_in ? S1101 : S0;
            S1101: next_state = bit_in ? S11 : S0;
            default: next_state = S0;
        endcase
    end

    always @(*) begin
        detected = (state == S1101);
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end
endmodule
