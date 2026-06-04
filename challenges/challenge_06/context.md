# AI Agent Context: Challenge 6 (Frequency Detector)

## Overview & Architecture
- **ESP32 Role**: Reads the potentiometer. Translates the value to a target frequency in the `[100, 2000] Hz` range. Synthesizes a discrete sine wave using `y(n) = A * sin(2 * pi * f * n / Fs)` with `Fs = 8000 Hz` and `A = 127` (producing signed 8-bit values). Sends 256 consecutive samples as raw bytes over UART at 115200 baud, then pauses before sending the next burst to allow frame synchronization.
- **FPGA Role**: Receives the raw 8-bit signed stream. Detects the start of a frame (using a timer to detect UART idle gap of, e.g., > 5ms). Stores the 256 bytes or processes them on the fly. Applies an algorithm to estimate the fundamental frequency. Outputs the frequency on HEX3..0.

## Frequency Detection Algorithms
1. **Zero-Crossing Detector (Easiest)**:
   - Count the number of times the signal crosses the zero-line (changes sign from positive to negative or vice versa).
   - `frequency = (crossings / 2) * (Fs / N)` where `Fs = 8000 Hz` and `N = 256`. Or more simply: `frequency = (crossings * 8000) / (2 * 256) = crossings * 15.625`.
   - To make it robust, add a small hysteresis threshold around zero to prevent noise-induced crossings.
2. **Autocorrelation (Medium)**:
   - Calculate the dot product of the signal with itself shifted by a lag `tau`.
   - Find the first peak of the autocorrelation function after the zero lag.
   - The lag of this peak corresponds to the period of the signal. `f = Fs / peak_lag`.
3. **FFT (Hardest)**:
   - Implement a 256-point Radix-2 FFT or DFT in hardware.
   - Requires substantial FPGA resources (multipliers, memory blocks for twiddle factor ROM).
   - Not recommended unless you have pre-existing verified HDL modules.

## Tips
- Idle-gap detection: if no UART bytes are received for more than ~50,000 clock cycles (at 50 MHz), reset the sample counter to 0 to align with the next frame.
