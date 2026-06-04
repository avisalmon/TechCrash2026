# Challenge 2: Accelerometer 3D Cube (30 pts)
**Difficulty**: Medium
**Points**: 30 (all or nothing)
**Category**: Combined (FPGA + ESP32)

## Description
Read the onboard ADXL345 accelerometer on the FPGA, send the raw acceleration data over UART to the ESP32, and draw a wireframe 3D cube on the OLED that rotates in real-time as you tilt the board.

## Requirements
- FPGA reads X, Y, Z acceleration from the onboard ADXL345 via SPI
- FPGA sends raw acceleration bytes to ESP32 over UART (GPIO header)
- ESP32 receives the data and computes tilt angles (pitch and roll)
- A wireframe 3D cube is rendered on the OLED display
- The cube rotates smoothly in response to tilting the DE10-Lite board
- FPGA LEDs show tilt direction (left/right/forward/back)

## Grading
Go / No-Go. All requirements must work for full 30 points. No partial credit.
