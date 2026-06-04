# Challenge 8: PC Retro Game (100 + 250/200/150 pts)
**Difficulty**: Medium
**Points**: 100 baseline + judge ranking bonus
**Category**: Combined (FPGA + ESP32 + PC)

## Description
Build any retro-style PC game controlled by the DE10-Lite board. FPGA samples KEY[0], KEY[1], SW[9:0], sends to ESP32, which forwards to a Python game on PC. No starter code provided.

## Requirements
- FPGA reads KEY[0], KEY[1], and all 10 switches.
- FPGA sends live control packet to ESP32 over UART (JP1).
- ESP32 bridges packet stream to PC over USB serial.
- Python PC game receives packets and uses them as controls.
- KEY[0] controls main action (e.g. flap/jump).
- KEY[1] controls secondary action (e.g. pause/restart).
- Switches must affect gameplay/visuals/difficulty/debug in a visible way.

## Grading
- 100 points: Go / No-Go (full chain works live).
- Judge ranking bonus: 1st: 250, 2nd: 200, 3rd-5th: 150.
