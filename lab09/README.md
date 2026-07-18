# Lab 09: Finite State Machines

## Objective

Build a Moore finite state machine that detects the serial pattern `1011`.

## Theory

An FSM stores a current state and moves to the next state based on input. A Moore output depends only on the current state.

## Commands

```bash
iverilog -o sim.out sequence_detector.v tb_sequence_detector.v
vvp sim.out
code lab09_sequence_detector.vcd
# fallbacks:
surfer lab09_sequence_detector.vcd
gtkwave lab09_sequence_detector.vcd
```

## Waveform Checklist

- Inspect `state` inside `uut` if your waveform viewer shows internal signals.
- Confirm `detected` pulses after the input sequence `1011`.
- Confirm overlapping sequences can still be detected.

## Challenge

Modify the FSM to detect `1101` instead of `1011`.
