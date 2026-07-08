# Lab 04: Multiplexers and Decoders

## Objective

Use `case` statements to build a 4-to-1 multiplexer and a 2-to-4 decoder.

## Theory

A multiplexer selects one input from many. A decoder activates one output line based on a binary input. These circuits are common in datapaths and control logic.

## Commands

```bash
iverilog -o sim.out mux_decoder.v tb_mux_decoder.v
vvp sim.out
code lab04_mux_decoder.vcd
# fallbacks:
surfer lab04_mux_decoder.vcd
gtkwave lab04_mux_decoder.vcd
```

## Waveform Checklist

- Confirm `mux_y` follows the input selected by `sel`.
- Confirm only one decoder output bit is high when `enable` is high.
- Confirm all decoder outputs are zero when `enable` is low.
- In the VaporView netlist panel, add `data`, `sel`, `enable`, `mux_y`, and `dec_y`.
- For the challenge activity, also add `data8`, `sel8`, and `mux8_y` to verify the 8-to-1 mux.

## Challenge

Create an 8-to-1 multiplexer using a 3-bit select input.
