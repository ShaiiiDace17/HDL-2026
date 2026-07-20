# Lab 10: Traffic-Light Controller Capstone

## Objective

Design and verify a timed traffic-light controller using a finite state machine.

## Theory

A traffic-light controller combines state memory, timing counters, reset behavior, and output decoding. This is a practical example of control logic.

## Specification

- Main road starts green.
- Main road turns yellow before side road turns green.
- Side road turns yellow before returning to main green.
- If `ped_request` is active during main green, the controller shortens the main green interval.
- Reset returns the controller to main green.

## Commands

```bash
iverilog -o sim.out traffic_light_controller.v tb_traffic_light_controller.v
vvp sim.out
code lab10_traffic_light.vcd
# fallbacks:
surfer lab10_traffic_light.vcd
gtkwave lab10_traffic_light.vcd
```

## Waveform Checklist

- Add `clk`, `reset`, `ped_request`, `state`, `timer`, `main_light`, and `side_light`.
- Confirm reset returns the FSM to main green.
- Confirm the state order is main green, main yellow, side green, side yellow.
- Confirm `ped_request` shortens the main green timing.

## Challenge

Add a `walk_light` output that turns on only during the side-green state.

## After Lab 10: Capstone Requirement

**Smart School-Zone Traffic Controller** is the final individual problem-solving case. Extend this traffic-light controller into a school-zone intersection FSM with main-road lights, side-road lights, pedestrian request behavior, reset behavior, and timed state transitions.

Required deliverables:

- Verilog design file.
- Verilog testbench.
- VCD waveform file.
- Terminal output screenshot or copied output.
- VaporView waveform screenshot or written waveform observations.
- Short design report with state diagram or state table, timing explanation, and guide-question answers.

Functional requirements:

- Reset must return the controller to a safe starting state.
- Main road and side road must never be green at the same time.
- Yellow transition states must appear before switching right-of-way.
- `ped_request` must change behavior in a visible and explainable way.
- The testbench must cover reset, normal operation, pedestrian request, and at least one edge case.

100-point rubric:

- FSM design and safety behavior: 25 pts
- Correct Verilog implementation: 20 pts
- Testbench completeness: 20 pts
- Waveform verification using VaporView: 15 pts
- Printed output and simulation evidence: 10 pts
- Written explanation and problem-solving analysis: 10 pts
