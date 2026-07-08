`timescale 1ns / 1ps

module mux4to1(
    input [3:0] data,
    input [1:0] sel,
    output reg y
);
    always @(*) begin
        case (sel)
            2'b00: y = data[0];
            2'b01: y = data[1];
            2'b10: y = data[2];
            2'b11: y = data[3];
            default: y = 1'b0;
        endcase
    end
endmodule

module decoder2to4(
    input [1:0] sel,
    input enable,
    output reg [3:0] y
);
    always @(*) begin
        if (enable) begin
            case (sel)
                2'b00: y = 4'b0001;
                2'b01: y = 4'b0010;
                2'b10: y = 4'b0100;
                2'b11: y = 4'b1000;
                default: y = 4'b0000;
            endcase
        end else begin
            y = 4'b0000;
        end
    end
endmodule

module mux8to1(
    input [7:0] data,
    input [2:0] sel,
    output reg y
);
    always @(*) begin
        case (sel)
            3'b000: y = data[0];
            3'b001: y = data[1];
            3'b010: y = data[2];
            3'b011: y = data[3];
            3'b100: y = data[4];
            3'b101: y = data[5];
            3'b110: y = data[6];
            3'b111: y = data[7];
            default: y = 1'b0;
        endcase
    end
endmodule
