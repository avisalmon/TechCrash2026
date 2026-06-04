# AI Agent Context: Challenge 4 (Press Right)

## Overview & Architecture
- **FPGA Role**: Runs a 10ms clock pulse generator (derived from 50 MHz clock). When KEY[0] is pressed, a state machine shifts to the counting state, incrementing a 16-bit register every 10ms. A second press of KEY[0] stops the counter. The decimal value is decoded and displayed on HEX3-HEX0. The FPGA UART transmitter then transmits the stopped value (as ASCII characters or a 16-bit binary integer) to the ESP32.
- **ESP32 Role**: Reads the UART stream. Receives the stopped value. Evaluates if the value is within `[990, 1010]` (10.00 seconds +/- 100ms). If so, it outputs a PWM tone on GPIO23 to sound the passive buzzer. Displays the score and "WIN" or "LOSE" on the OLED display.

## Pinout and Wiring
- **ESP32 Buzzer**: Passive buzzer is on GPIO23.
- **ESP32 Button**: Push button is on GPIO4 (active LOW).
- **ESP32 ↔ FPGA Wiring**:
  - Common GND
  - FPGA TX Pin (GPIO header) ↔ ESP32 RX Pin (e.g. GPIO16)

## Firmware & HDL Tips
- **FPGA (SystemVerilog)**:
  - Generate a 100Hz clock enable signal from 50MHz:
    `count <= (count == 499999) ? 0 : count + 1;`
  - Implement a debouncer for KEY[0] input to prevent multiple triggers from a single press.
  - Convert binary count to 4-digit BCD to drive HEX3..HEX0.
  - Translate the distance to 1000 into LED representation: e.g., if diff is 0, light up all 10 LEDs. If diff is > 50, light up 0 LEDs.
- **ESP32 (C++/Arduino)**:
  - Configure the buzzer GPIO23 as output. Use `ledcWriteTone` or `tone(23, frequency, duration)` to play victory melody/beep.
  - Parse received value: `int stoppedValue = Serial2.parseInt();`
  - Determine distance: `int diff = abs(stoppedValue - 1000);`
  - Update SSD1306 OLED layout accordingly.
