# Challenge 6: Frequency Detector (100 pts)
**Difficulty**: Medium-Hard
**Points**: 100 (all or nothing)
**Category**: Combined (ESP32 + FPGA)

## Description
The ESP32 reads a potentiometer and generates a digital sine wave at the corresponding frequency (100-2000 Hz). It sends 256 raw signed samples over UART to the FPGA. The FPGA must detect the frequency of the signal and display it on the 7-segment displays.

## Requirements
- ESP32 reads potentiometer (GPIO34 ADC) and maps 0-4095 to 100-2000 Hz
- ESP32 generates 256 samples of a sine wave at 8000 Hz sample rate
- Samples are sent as raw signed 8-bit bytes over UART (115200 baud) to FPGA via GPIO header
- FPGA receives the 256-byte frame and detects the signal frequency
- Detected frequency is displayed on HEX3..0 in Hz (e.g. "1085")
- Accuracy must be within 35 Hz of the ESP32's generated frequency (a 50-100 Hz deviation is acceptable and expected given the 31 Hz bin resolution)
- LED bar graph shows frequency band (more LEDs = higher frequency)
- SW[9] toggles debug mode (show raw detection internals)

## Hints
- Sample rate = 8000 Hz, window = 256 samples → frequency resolution ≈ 31 Hz
- Zero-crossing detection is the simplest approach (count sign changes)
- FFT is the "proper" approach but requires ROM for twiddle factors (watch out for MAX 10 configuration mode limitations)
- Frame synchronization: use a gap timeout between 256-byte bursts

## Grading
Go / No-Go. All requirements must work for full 100 points. No partial credit.
