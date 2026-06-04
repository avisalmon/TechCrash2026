# AI Agent Context: Challenge 8 (PC Retro Game)

## Overview & Architecture
- **FPGA Role**: Samples the status of `KEY[0]`, `KEY[1]`, and `SW[9:0]`. Encodes these values into a short UART message frame (e.g. `[0xFF, KEYS_STATE, SW_MSB, SW_LSB]`) and sends it over UART TX to the ESP32.
- **ESP32 Role**: Reads the packet from the FPGA via serial pin (`Serial2`). Directs the exact payload unmodified (or parses and reformats) to `Serial` (the USB connection to the PC).
- **PC Role (Python)**: Runs a game engine (such as Pygame) that reads from the serial port (using `pyserial`). Decodes the status of the keys and switches to control the game mechanics.

## Designing the Game
- Keep it simple: **Pong**, **Flappy Bird**, **Space Invaders**, or **Tetris**.
- Use Pygame on the PC side:
  - Install dependencies: `pip install pygame pyserial`
- Define switch mappings:
  - `SW[0]`: Enable/disable debug mode (draw bounding boxes).
  - `SW[1]`: Toggle background music / mute.
  - `SW[2..3]`: Adjust game speed or difficulty.
  - `SW[4..9]`: Custom colors, player skins, or configurations.
