# Lab 08: Shift Registers and Serial Data

## Objective

Build a 4-bit shift register with parallel load and serial input.

## Theory

Shift registers move data one bit at a time. They are used in serial communication, data delay, and bit manipulation circuits.

## Commands

```bash
iverilog -o sim.out shift_register.v tb_shift_register.v
vvp sim.out
code lab08_shift_register.vcd
# fallbacks:
surfer lab08_shift_register.vcd
gtkwave lab08_shift_register.vcd
```

## Waveform Checklist

- Confirm `load` copies `parallel_in` into `q`.
- Confirm `direction = 0` shifts `serial_in` into the left side.
- Confirm `direction = 1` shifts `serial_in` into the right side.
- Confirm `serial_out` shows the bit leaving the selected shift direction.

## Challenge

Add a direction input so the register can shift left or right.
