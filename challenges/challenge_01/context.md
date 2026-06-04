# AI Agent Context: Challenge 1 (Volt-Meter)

## Overview & Architecture
- **ESP32 Role**: Reads analog voltage from a potentiometer on GPIO34 (ADC1_CH6). Converts the 12-bit ADC value (0-4095) to voltage (0.0V - 3.3V). Displays it on the SSD1306 I2C OLED display (SDA=GPIO21, SCL=GPIO22, address 0x3C). Sends the voltage as a text string (e.g., `"1.65\n"`) or binary data over UART TX (e.g., GPIO17/TX2) to the FPGA RX.
- **FPGA Role**: Receives the UART stream at the matching baud rate (e.g., 9600 or 115200). Parses the ASCII/binary value, decodes it into digits, and drives the 7-segment displays (HEX5-HEX0) to show the voltage (e.g. `1.65`). Drives the 10 red LEDs (`LEDR[9:0]`) proportionally based on the voltage level (0V = no LEDs, 3.3V = all LEDs).

## Useful Hardware Info & Pinout
- **Potentiometer**: Middle pin to ESP32 GPIO34, outer pins to ESP32 3V3 and GND.
- **ESP32 ↔ FPGA Wiring**:
  - ESP32 GND ↔ FPGA GND (Mandatory common ground!)
  - ESP32 UART TX (e.g., GPIO17) ↔ FPGA GPIO Rx Pin (e.g., JP1 Pin 1 / GPIO[0])
- **SSD1306 OLED**: I2C address is `0x3C`. SDA=GPIO21, SCL=GPIO22.

## Firmware & HDL Tips
- **ESP32 (C++/Arduino)**:
  - Use `analogRead(34)` to get the raw ADC value.
  - Convert: `float voltage = (raw_adc / 4095.0) * 3.3;`
  - Display using `<Adafruit_SSD1306.h>` and `<Adafruit_GFX.h>`.
  - Send: `Serial2.print(voltage); Serial2.print('\n');`
- **FPGA (SystemVerilog)**:
  - Implement a standard UART receiver module with a state machine to decode received characters (detecting digits and the decimal point, or expecting a fixed format like 3 characters: `1`, `6`, `5`).
  - Convert value to BCD/7-segment representations.
  - Proportionally light up `LEDR[9:0]`: e.g., mapping 0-330 to index 0-9.
