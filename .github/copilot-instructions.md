# Copilot Instructions — CrashTech VLSI 2026

## Project Overview

This is a VLSI hackathon project using **DE10-Lite FPGA** (Intel MAX 10) and **ESP32 DevKit** communicating over UART.

## Key Conventions

### Python Environment

- The project Python venv is at `env/` (NOT `.venv/`).
- Activate: `env\Scripts\activate` (Windows).
- Python 3.11.9.

### FPGA ↔ ESP32 Communication

- **Use the Arduino header** on the DE10-Lite, NOT the JP1 40-pin GPIO header.
- FPGA RX from ESP32: `ARDUINO_IO[0]` (PIN_AB5).
- FPGA TX to ESP32: `ARDUINO_IO[1]` (PIN_AB6).
- ESP32 TX: GPIO 16, ESP32 RX: GPIO 17.
- UART: 9600 baud, 8N1, 3.3V logic.
- All unused ARDUINO_IO pins must be set to high-Z (`1'bz`).

### Pin Definitions

- All ESP32 projects share `projects/common/esp32/pin_config.h`.
- Include it with the correct relative path from each project's `src/` folder.

### FPGA Toolchain

- Quartus Prime Lite 17.1 at `C:\intelFPGA_lite\17.1\`.
- Compile: `quartus_sh.exe --flow compile <project_name>`.
- Program: `quartus_pgm.exe -c "USB-Blaster [USB-0]" -m JTAG -o "P;output_files/<project>.sof"`.

### ESP32 Toolchain

- PlatformIO (VS Code extension or CLI).
- CLI path: `$env:USERPROFILE\.platformio\penv\Scripts\pio.exe`.
- Build: `pio run` from the project's `esp32/` folder.
- Upload: `pio run -t upload`.
- Monitor: `pio device monitor`.

### RTL Top Module Pattern

All FPGA projects use this port declaration:

```systemverilog
module project_top (
    input           MAX10_CLK1_50,
    input   [9:0]   SW,
    input   [1:0]   KEY,
    output  [9:0]   LEDR,
    output  [7:0]   HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
    inout   [15:0]  ARDUINO_IO,
    inout           ARDUINO_RESET_N
);
```

### Project Structure

Each challenge/demo has parallel `esp32/` and `fpga/` folders:
- `esp32/platformio.ini` + `esp32/src/main.cpp`
- `fpga/<project>.qpf` + `fpga/<project>.qsf` + `fpga/src/<top>.sv`

### What NOT to Do

- Do NOT use JP1 GPIO header pins. Always use Arduino header (`ARDUINO_IO[0..15]`).
- Do NOT use `.venv/` for the Python environment. Use `env/`.
- Do NOT hardcode COM port numbers. PlatformIO auto-detects.
- Do NOT install ESP32 toolchain manually. PlatformIO handles it.
