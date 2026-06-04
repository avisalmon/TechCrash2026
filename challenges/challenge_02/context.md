# AI Agent Context: Challenge 2 (Accelerometer 3D Cube)

## Overview & Architecture
- **FPGA Role**: Acts as the SPI master communicating with the onboard ADXL345 digital accelerometer. Configures the ADXL345 registers (e.g., POWER_CTL, DATA_FORMAT). Periodically reads the 6 bytes of acceleration data (X_L, X_H, Y_L, Y_H, Z_L, Z_H). Sends these 6 raw bytes (optionally wrapped in a start/stop frame packet) over UART to the ESP32. Updates LEDs (`LEDR[9:0]`) to indicate which direction the board is tilted.
- **ESP32 Role**: Receives the raw 3-axis accelerometer data via UART. Performs 3D rotation calculations (pitch and roll angles). Computes the 3D projection onto the 2D OLED screen. Draws the rotated wireframe 3D cube using Adafruit GFX library line drawing functions.

## Useful Hardware Info & Pinout
- **Onboard ADXL345 SPI Pins on DE10-Lite**:
  - `GSENSOR_CS_N` (Pin `AB16` - Active Low CS)
  - `GSENSOR_SCLK` (Pin `AB15` - Serial Clock)
  - `GSENSOR_SDI` (Pin `Y14` - Master Out / Slave In)
  - `GSENSOR_SDO` (Pin `Y13` - Master In / Slave Out)
- **ESP32 ↔ FPGA Wiring**:
  - Common GND
  - FPGA UART TX (e.g., JP1 Pin 2 / GPIO[1]) ↔ ESP32 UART RX (e.g., GPIO16/RX2)

## Firmware & HDL Tips
- **FPGA (SystemVerilog)**:
  - Implement a basic SPI Master state machine operating at <= 5MHz SCLK.
  - Read from data registers: `0x32` (DATAX0) through `0x37` (DATAZ1).
  - Format packet: e.g., `[0xAA, X_H, X_L, Y_H, Y_L, Z_H, Z_L, 0x55]` for frame synchronization.
  - Set LEDs:
    - Forward tilt: light up `LEDR[9:8]`
    - Backward tilt: light up `LEDR[1:0]`
    - Left/Right tilt: light up appropriate segments of `LEDR[7:2]`
- **ESP32 (C++/Arduino)**:
  - Wait for the synchronization header (`0xAA`), read the 6 payload bytes, and verify the trailer (`0x55`).
  - Calculate pitch and roll:
    - `float pitch = atan2(-x, sqrt(y*y + z*z));`
    - `float roll = atan2(y, z);`
  - Define 8 vertices of a cube in 3D space `(x, y, z)`.
  - Rotate vertices using standard rotation matrices based on the calculated pitch and roll.
  - Project 3D points `(X, Y, Z)` to 2D `(x_screen, y_screen)` using simple orthographic or perspective projection:
    - `x_screen = center_x + X * (d / (d + Z))`
    - `y_screen = center_y + Y * (d / (d + Z))`
  - Clear OLED buffer, draw lines between connecting vertices, and push to display.
