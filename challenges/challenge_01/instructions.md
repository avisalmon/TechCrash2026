# Challenge 1: Volt-Meter (10 pts)
**Difficulty**: Easy
**Points**: 10 (all or nothing)
**Category**: Combined (ESP32 + FPGA)

## Description
Build a digital volt-meter that reads the potentiometer voltage and displays it on both the OLED screen and the FPGA 7-segment displays.

## Requirements
- ESP32 reads the potentiometer (GPIO34 ADC) and converts to voltage (0-3.3V)
- Voltage is displayed on the OLED screen in large text (e.g. "1.65V")
- ESP32 sends the voltage value over UART to the FPGA
- FPGA displays the voltage on the 7-segment displays as X.XX (with decimal point)
- LED bar graph on LEDR[9:0] shows voltage level proportionally

## Grading
Go / No-Go. All requirements must work for full 10 points. No partial credit.
