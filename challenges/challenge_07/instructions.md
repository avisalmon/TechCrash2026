# Challenge 7: FP8 Adder Race (80 + 150/100/50 pts)
**Difficulty**: Hard
**Points**: 80 for a valid 2x speedup + podium bonus (150 / 100 / 50)
**Category**: FPGA-only

## Description
Optimize an FP8 E4M3 adder core on the DE10-Lite to finish faster while still passing all 4096 reference tests. Starter code is in `challenges/fp8-adder/`.

## Starter Kit
- slow multi-cycle reference implementation in `fpga/src/fp8_adder.v`
- editable PLL in `fpga/src/challenge_pll.v`
- locked board harness measuring elapsed time in decimal microseconds
- ROM contents, Python reference model, simulation testbench

## Rules
- May modify `fpga/src/fp8_adder.v` and `fpga/src/challenge_pll.v`
- May add helper modules if instantiated from `fp8_adder.v`
- Must keep DUT interface: clk, rst_n, start, a, b, result, done, busy
- May not modify harness, display, ROM, pin assignments, etc.
- Tune PLL-driven DUT clock, but not 25 MHz measurement clock
- Correct if all 4096 tests pass (LEDR[0] = 1)

## Board Notes
- Displays elapsed time in decimal microseconds.
- Left two digits show EE during run, LEDs act as progress bar.

## PLL Tuning Tips
- Shipped starter uses 25 MHz (mult=1, div=2).
- Edit only PLL parameters in `fpga/src/challenge_pll.v`.
- Increase frequency in small steps. Back off if timing breaks or hardware fails.

## Grading
- 80 points: achieve at least 2x speedup vs starter with all tests passing
- Podium bonus: 1st: +150, 2nd: +100, 3rd: +50
