# AI Agent Context: Challenge 7 (FP8 Adder Race)

## Overview & Architecture
This challenge involves accelerating an 8-bit Floating Point (FP8 E4M3 format) adder.
- **E4M3 Format**: 1 sign bit, 4 exponent bits, 3 mantissa (fraction) bits.
  - Exponent bias is usually 7 (or depends on the specification in starter code).
- **Core Strategy**:
  1. **Algorithmic/Microarchitectural Optimization**:
     - The starter code is multi-cycle and slow. Rewrite the adder to be single-cycle (combinational) or fully pipelined, or at least run in fewer clock cycles.
     - A single-cycle combinational design allows finishing each addition in exactly 1 clock cycle (or 2 cycles with start/done handshaking).
  2. **Frequency (PLL) Optimization**:
     - Modify the PLL configuration in `challenge_pll.v` to run the module at the highest possible frequency (e.g. 50 MHz, 100 MHz, or even higher, depending on timing analysis slack).
     - Make sure that the compilation passes timing analyzer constraint requirements.

## Troubleshooting
- If the hardware shows error or incorrect results at higher PLL frequencies, scale back the frequency or add pipeline registers to divide long combinational paths.
