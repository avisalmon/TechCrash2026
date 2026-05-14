# CrashTech VLSI 2026

**Technion VLSI hackathon** — DE10-Lite FPGA + ESP32 controller kit.

---

## Prerequisites

| Tool | Version | Download |
|------|---------|----------|
| **VS Code** | Latest | https://code.visualstudio.com/download |
| **Quartus Prime Lite** | 17.1 | [Intel FPGA downloads](https://www.intel.com/content/www/us/en/software-kit/669444/intel-quartus-prime-lite-edition-design-software-version-17-1-for-windows.html) |
| **PlatformIO IDE** | Latest | VS Code extension — search "PlatformIO IDE" |
| **CP210x USB driver** | Latest | https://www.silabs.com/developer-tools/usb-to-uart-bridge-vcp-drivers |
| **USB-Blaster driver** | (bundled) | `C:\intelFPGA_lite\17.1\quartus\drivers\usb-blaster` |
| **Git** | Latest | https://git-scm.com/downloads |

### Quartus installation notes

- Select **MAX 10 device support** during install (required for DE10-Lite).
- Include **ModelSim-Intel FPGA Edition** for simulation.
- Default install path: `C:\intelFPGA_lite\17.1\`

### PlatformIO installation notes

- Install the **PlatformIO IDE** extension in VS Code.
- PlatformIO auto-installs its own Python, ESP32 toolchain, and esptool. You do NOT need to install these separately.
- First build downloads ~500 MB of platform packages (needs internet).

---

## Clone and Setup

```powershell
git clone https://github.com/avisalmon/TechCrash2026.git
cd TechCrash2026
```

Open the folder in VS Code. PlatformIO will detect `platformio.ini` files automatically.

### Python environment (optional, for helper scripts)

```powershell
python -m venv env
env\Scripts\activate
pip install -r requirements.txt   # if present
```

The local Python venv lives at `env/` (not `.venv/`).

---

## Hardware Wiring

### ESP32 ↔ FPGA UART (Arduino Header)

| ESP32 Pin | Direction | FPGA Pin | Function |
|-----------|-----------|----------|----------|
| GPIO 16 | → | ARDUINO_IO[0] | ESP32 TX → FPGA RX |
| GPIO 17 | ← | ARDUINO_IO[1] | FPGA TX → ESP32 RX |
| GND | — | GND (Arduino header) | Common ground |

**UART config:** 9600 baud, 8N1, 3.3V logic.

> **Important:** We use the **Arduino header** on the DE10-Lite, NOT the JP1 40-pin GPIO header.

### Arduino Header Pin Map (DE10-Lite)

| Signal | FPGA Pin |
|--------|----------|
| ARDUINO_IO[0] | PIN_AB5 |
| ARDUINO_IO[1] | PIN_AB6 |
| ARDUINO_IO[2] | PIN_AB7 |
| ARDUINO_IO[3] | PIN_AB8 |
| ARDUINO_IO[4] | PIN_AB9 |
| ARDUINO_IO[5] | PIN_Y10 |
| ARDUINO_IO[6] | PIN_AA11 |
| ARDUINO_IO[7] | PIN_AA12 |
| ARDUINO_IO[8] | PIN_AB17 |
| ARDUINO_IO[9] | PIN_AA17 |
| ARDUINO_IO[10] | PIN_AB19 |
| ARDUINO_IO[11] | PIN_AA19 |
| ARDUINO_IO[12] | PIN_Y19 |
| ARDUINO_IO[13] | PIN_AB20 |
| ARDUINO_IO[14] | PIN_AB21 |
| ARDUINO_IO[15] | PIN_AA20 |
| ARDUINO_RESET_N | PIN_F16 |

### Shared ESP32 Pin Config

All ESP32 projects use `projects/common/esp32/pin_config.h` for pin definitions. Include it in your `main.cpp`:

```cpp
#include "../../../../projects/common/esp32/pin_config.h"
```

---

## Build and Program

### FPGA (Quartus CLI)

```powershell
# Compile (from the project's fpga/ folder)
cd demos\alive_test\fpga
& "C:\intelFPGA_lite\17.1\quartus\bin64\quartus_sh.exe" --flow compile alive_test

# List programmers (should show "USB-Blaster [USB-0]")
& "C:\intelFPGA_lite\17.1\quartus\bin64\quartus_pgm.exe" --list

# Program the FPGA (volatile — lost on power-off)
& "C:\intelFPGA_lite\17.1\quartus\bin64\quartus_pgm.exe" -c "USB-Blaster [USB-0]" -m JTAG -o "P;output_files\alive_test.sof"
```

### ESP32 (PlatformIO CLI)

```powershell
# From the project's esp32/ folder
cd demos\alive_test\esp32

# Build
pio run

# Upload to board (auto-detects COM port)
pio run -t upload

# Serial monitor
pio device monitor
```

If `pio` is not on PATH, use the full path: `$env:USERPROFILE\.platformio\penv\Scripts\pio.exe`

---

## Project Structure

```
TechCrash2026/
├── index.html                    # Main website
├── style.css
├── README.md                     # You are here
├── projects/
│   └── common/
│       └── esp32/
│           └── pin_config.h      # Shared ESP32 pin definitions
├── demos/                        # Practice projects (open, pre-competition)
│   ├── alive_test/               # Full kit smoke test
│   │   ├── esp32/                # PlatformIO project
│   │   └── fpga/                 # Quartus project
│   └── internet_clock/           # WiFi NTP clock on 7-segment
│       ├── esp32/
│       └── fpga/
├── challenges/                   # Competition challenges (gitignored)
├── images/
└── docs/
```

Each project has a parallel structure:
- `esp32/` — PlatformIO project with `platformio.ini` and `src/main.cpp`
- `fpga/` — Quartus project with `.qpf`, `.qsf`, and `src/*.sv`

---

## Alive Test — Quick Start

The alive test verifies your entire kit is working (LEDs, OLED, buttons, buzzer, analog input, FPGA UART echo).

1. **Program the FPGA:** compile and upload `demos/alive_test/fpga/`
2. **Flash the ESP32:** build and upload `demos/alive_test/esp32/`
3. **Wire:** ESP32 GPIO16 → ARDUINO_IO[0], ARDUINO_IO[1] → ESP32 GPIO17, GND ↔ GND
4. **Verify:** LEDs chase, OLED shows sensor data, buttons buzz, FPGA echoes UART

---

## Copilot Skills

This repo includes `.copilot/skills/` with detailed guides for the AI agent:

| Skill | Covers |
|-------|--------|
| `esp32-firmware` | PlatformIO setup, pin config, peripherals, build/flash |
| `de10lite-board-and-build` | Quartus setup, pin assignments, compile/program CLI |
| `de10lite-vga-graphics` | VGA display, sprites, text screen |
| `de10lite-addon-peripherals` | Joystick, buttons, LCD via Arduino header |

These skills let GitHub Copilot help you with hardware-specific tasks.
