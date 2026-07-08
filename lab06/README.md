# Lab 06: Latches vs Flip-Flops

## Objective

Compare a level-sensitive D latch with an edge-triggered D flip-flop.

## Theory

A latch can change while its enable signal is active. A flip-flop changes only on a clock edge. This distinction is essential for stable sequential design.

## Commands

```bash
iverilog -o sim.out latch_flipflop.v tb_latch_flipflop.v
vvp sim.out
code lab06_latch_flipflop.vcd
# fallbacks:
surfer lab06_latch_flipflop.vcd
gtkwave lab06_latch_flipflop.vcd
```

## Waveform Checklist

- Watch `d`, `enable`, `clk`, `q_latch`, and `q_ff`.
- Confirm `q_latch` follows `d` while `enable` is high.
- Confirm `q_ff` updates only on the rising edge of `clk`.

## Challenge

Add an asynchronous active-low reset to the D flip-flop.
