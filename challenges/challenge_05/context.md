# AI Agent Context: Challenge 5 (FPGA Volt-Meter)

## Overview & Architecture
- **FPGA Role**: Utilizes Intel's Altera Modular ADC IP Core (hard IP on MAX 10) to sample analog voltage from Arduino pin A0. Decodes the 12-bit ADC result into voltage. Displays the value as X.XX on three 7-segment displays. Drives LED bar graph `LEDR[9:0]`. Transmits the value over UART to the ESP32.
- **ESP32 Role**: Receives the UART stream, decodes it, and renders the voltage in large text on the OLED screen.

## Intel MAX 10 ADC IP Configuration
- Open Quartus IP Catalog. Search for "Altera Modular ADC".
- Instantiate the core with the following configurations:
  - **Core Configuration**: Single Channel / Sequencer mode.
  - **Sample Rate**: 1 MHz (standard).
  - **ADC channel**: Select Channel 1 (which maps to Arduino Analog Pin A0/pin `F5` / ADC_IN1).
- Drive the modular ADC interface signals (clk, reset, command, response).
- Note that the MAX 10 ADC has an internal reference voltage of 2.5V or depends on the board supply (DE10-Lite utilizes a 2.5V internal reference, but check the manual/schematics: analog input pins can measure up to 2.5V or 3.3V depending on the ADC configuration and scaling resistors on the board. The DE10-Lite schematic shows analog inputs are scaled via resistor dividers to 2.5V at the FPGA pin. The range on the header is 0 to 5.0V or 0 to 3.3V depending on the exact pin. Use the board manual for exact scaling factor).

## Pinout and Wiring
- **Analog Input**: Arduino header analog input A0 (pin name `ADC_IN1` or physical pin `F5`).
- **ESP32 ↔ FPGA Wiring**:
  - Common GND
  - FPGA TX Pin (GPIO header) ↔ ESP32 RX Pin (e.g. GPIO16)
