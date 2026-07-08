# Lab 04 Submission Notes

## Analysis Questions

7. `mux_y` still changes when decoder `enable` is `0` because the multiplexer and decoder are separate circuits. The decoder enable only controls `dec_y`; it does not disable the multiplexer. Since `mux_y` depends only on `data` and `sel`, it continues to follow the selected data bit.

8. A one-hot output means exactly one output bit is `1` at a time while all other output bits are `0`. For example, the decoder output `0100` is one-hot because only one bit is active.

9. For `data = 1010` and `sel = 01`, the 4-to-1 mux selects `data[1]`. In Verilog bit indexing, `data[0]` is the rightmost bit, so `data[1]` is `1`. Therefore, `mux_y = 1`.

## Console Output

```text
VCD info: dumpfile lab04_mux_decoder.vcd opened for output.
data sel enable | mux_y dec_y
1010  00    1    |   0   0001
1010  01    1    |   1   0010
1010  10    1    |   0   0100
1010  11    1    |   1   1000
1010  00    0    |   0   0000
1010  01    0    |   1   0000
1010  10    0    |   0   0000
1010  11    0    |   1   0000

8-to-1 mux challenge
data8    sel8 | mux8_y
10101100  000  |   0
10101100  001  |   0
10101100  010  |   1
10101100  011  |   1
10101100  100  |   0
10101100  101  |   1
10101100  110  |   0
10101100  111  |   1
tb_mux_decoder.v:51: $finish called at 160000 (1ps)
```

## Waveform Observations

- When `enable = 1`, `dec_y` changes one bit at a time: `0001`, `0010`, `0100`, then `1000`.
- When `enable = 0`, `dec_y` stays at `0000` for every `sel` value.
- `mux_y` continues to follow the selected bit of `data = 1010`, even when the decoder is disabled.
- For the 8-to-1 mux challenge, `mux8_y` follows the selected bit of `data8 = 10101100` from `sel8 = 000` through `sel8 = 111`.

## VaporView Netlist Signals

In the VaporView netlist panel, add the original lab signals `data`, `sel`, `enable`, `mux_y`, and `dec_y`. For the challenge activity, also add `data8`, `sel8`, and `mux8_y` so the 8-to-1 multiplexer can be verified in the waveform.

## Challenge Activity Result

Create an 8-to-1 multiplexer using a 3-bit select input.

The challenge was completed by adding module `mux8to1` in `mux_decoder.v`. It uses an 8-bit input named `data`, a 3-bit select input named `sel`, and a `case` statement to assign `y` from `data[0]` through `data[7]`. The testbench was updated to test all eight select values.

## 8-to-1 Multiplexer Truth Table

| `sel[2:0]` | Selected input | Output `y` |
| --- | --- | --- |
| `000` | `data[0]` | `data[0]` |
| `001` | `data[1]` | `data[1]` |
| `010` | `data[2]` | `data[2]` |
| `011` | `data[3]` | `data[3]` |
| `100` | `data[4]` | `data[4]` |
| `101` | `data[5]` | `data[5]` |
| `110` | `data[6]` | `data[6]` |
| `111` | `data[7]` | `data[7]` |

Using the test value `data8 = 10101100`, the output is:

| `data8` | `sel8` | `mux8_y` |
| --- | --- | --- |
| `10101100` | `000` | `0` |
| `10101100` | `001` | `0` |
| `10101100` | `010` | `1` |
| `10101100` | `011` | `1` |
| `10101100` | `100` | `0` |
| `10101100` | `101` | `1` |
| `10101100` | `110` | `0` |
| `10101100` | `111` | `1` |
