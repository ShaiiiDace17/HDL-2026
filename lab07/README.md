# Lab 07: Counters and Clock Dividers

## Objective

Build a 4-bit binary counter and a clock divider output.

## Theory

Counters are sequential circuits that advance on clock edges. A divided clock can be made by toggling a register after a count reaches a terminal value.

## Commands

```bash
iverilog -o sim.out counter_divider.v tb_counter_divider.v
vvp sim.out
code lab07_counter_divider.vcd
# fallbacks:
surfer lab07_counter_divider.vcd
gtkwave lab07_counter_divider.vcd
```

## Waveform Checklist

- Confirm `count` increments on each rising edge.
- Confirm reset clears the counter.
- Confirm `slow_clk` toggles after the terminal count.

## Challenge

The terminal count was changed from `4'd9` to `4'd4`. With the testbench clock period of 10 ns, `slow_clk` toggles every 5 clock cycles, so it toggles every 50 ns. One full `slow_clk` period is two toggles, so the new measured period is 100 ns in VaporView.
