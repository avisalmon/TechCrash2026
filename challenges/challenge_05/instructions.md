# Challenge 5: FPGA Volt-Meter (20 pts)
**Difficulty**: Medium
**Points**: 20 (all or nothing)
**Category**: Combined (FPGA + ESP32)

## Description
Read an analog voltage using the FPGA's internal ADC (MAX 10 ADC), display it on the 7-segment displays, and send the value to the ESP32 to show on the OLED screen. This is the reverse direction of Challenge 1.

## Requirements
- FPGA reads analog input from Arduino header pin A0 using the internal MAX 10 ADC
- Voltage (0-3.3V) is displayed on the 7-segment displays as X.XX with decimal point
- FPGA sends the voltage value over UART to the ESP32
- ESP32 displays the voltage on the OLED in large text
- LED bar graph on LEDR[9:0] shows voltage level proportionally
- Display updates live as the input voltage changes

## Grading
Go / No-Go. All requirements must work for full 20 points. No partial credit.
