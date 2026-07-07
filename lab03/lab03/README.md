# Lab 03: Combinational Circuits

## Objective

Build a half adder, full adder, and 4-bit ripple-carry adder.

## Theory

Combinational circuits have outputs that depend only on present inputs. Adders are a classic example because they combine logic gates into arithmetic hardware.

## Commands

```bash
iverilog -o sim.out adders.v tb_adders.v
vvp sim.out
code lab03_adders.vcd
# fallbacks:
surfer lab03_adders.vcd
gtkwave lab03_adders.vcd
```

## Waveform Checklist

- Inspect `a`, `b`, `cin`, `sum`, and `cout` for the full adder.
- Inspect `a4`, `b4`, `cin4`, `sum4`, and `cout4` for the 4-bit adder.
- Check carry propagation from low bits to high bits.

## Challenge

Create an 8-bit ripple-carry adder by extending the same structure.
