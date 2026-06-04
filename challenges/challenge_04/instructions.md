# Challenge 4: Press Right (20 pts)
**Difficulty**: Easy
**Points**: 20 (all or nothing)
**Category**: Combined (FPGA + ESP32)

## Description
A fast counter on the FPGA increments every 1/100th of a second (10ms), displayed on the 7-segment displays. Press KEY[0] to start the counter, then press KEY[0] again to stop it. The goal is to stop it exactly at 1000 (= 10.00 seconds). The stopped value is sent to the ESP32. If you stop within 1000 +/- 10 (i.e. 990 to 1010), the ESP32 plays a victory buzzer.

## Requirements
- FPGA counter increments every 10ms, shown on HEX3..0 as a 4-digit decimal number
- KEY[0] starts the counter, KEY[0] again stops it
- Stopped value is sent to ESP32 over UART
- ESP32 receives the value and plays the buzzer if within +/- 10 of 1000
- OLED shows the stopped value and whether you won or missed
- LEDs show how close you were (more LEDs = closer to 1000)

## Grading
Go / No-Go. All requirements must work for full 20 points. No partial credit.
