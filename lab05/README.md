# Lab 05: Comparators and ALU Basics

## Objective

Build a 4-bit comparator and a small arithmetic logic unit.

## Theory

An ALU performs selected arithmetic and logic operations. Control signals choose the operation, while flags describe the result.

## Commands

```bash
iverilog -o sim.out compare_alu.v tb_compare_alu.v
vvp sim.out
code lab05_compare_alu.vcd
# fallbacks:
surfer lab05_compare_alu.vcd
gtkwave lab05_compare_alu.vcd
```

## Waveform Checklist

- Watch `op` and confirm the ALU result changes by selected operation.
- Use `000` for add, `001` for subtract, `010` for AND, `011` for OR, and `100` for bitwise NOT of `a`.
- Compare `eq`, `gt`, and `lt` with `a` and `b`.
- Check the `zero` flag when the ALU result is `0000`.

## Challenge

The ALU includes a bitwise NOT operation for input `a` at `op = 3'b100`.

## Analysis Questions

7. In `compare_alu.v`, subtraction is performed when `op = 3'b001`. This is shown in the ALU `case` statement where `3'b001` sets `result = a - b`. This means that when the operation input is `001`, the ALU subtracts input `b` from input `a`.

8. The zero flag is `1` for `5 - 5` because the ALU subtracts `b` from `a`, giving a result of `0`. In the testbench, `a = 4'd5`, `b = 4'd5`, and `op = 3'b001`, so the operation is `5 - 5`. Since the code assigns `zero = (result == 4'b0000)`, the zero flag becomes `1` when the result is `0000`.

9. When `a = 9` and `b = 3`, the active comparator output is `gt`. In the `comparator4` module, `gt` becomes `1` when `a > b`. Since `9` is greater than `3`, the comparator outputs are `eq = 0`, `gt = 1`, and `lt = 0`.

## Challenge Activity

The bitwise NOT operation for input `a` is added in `compare_alu.v` using `op = 3'b100`. The statement `3'b100: result = ~a;` in the ALU reverses each bit of input `a`. For example, when `a = 9`, the 4-bit binary value is `1001`, and the bitwise NOT result is `0110`, which is decimal `6`.
