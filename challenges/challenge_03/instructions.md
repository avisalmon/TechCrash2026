# Challenge 3: Speed Loopback (50 + 200/150/100 pts)
**Difficulty**: Hard
**Points**: 50 baseline + podium bonus (200 / 150 / 100)
**Category**: Combined (FPGA + ESP32)

## Description
The FPGA generates 10,000 pseudo-random bytes and sends them to the ESP32. The ESP32 must receive all bytes, compute the checksum (sum & 0xFF), and send it back. The FPGA verifies the checksum and displays the elapsed time in milliseconds on the 7-segment displays. Base code is in `challenges/speed-loopback/`.

## What You Get
- Working FPGA bitstream with fixed infrastructure (LFSR, sum, timer, comparator)
- Baseline ESP32 firmware using single 9600-baud UART (~10.4 seconds)
- Full HTML page explaining the architecture, rules, and optimization ideas

## Rules
- DO NOT modify the FPGA fixed infrastructure (LFSR, sum accumulator, timer, comparator, state machine, data count)
- You MAY replace the UART TX/RX modules, change baud rates, add parallel channels, switch to SPI, or use any communication method
- You MAY fully rewrite the ESP32 firmware
- You MAY use any GPIO pins on the JP1 header or Arduino header

## Grading
- 50 points: Achieve at least 4x improvement over baseline (complete in under 2,600 ms with correct checksum)
- Podium bonus (top 3 fastest correct times): 1st: +200, 2nd: +150, 3rd: +100
