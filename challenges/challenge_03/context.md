# AI Agent Context: Challenge 3 (Speed Loopback)

## Overview & Architecture
This challenge is a speed race. The core bottleneck is the connection link between the FPGA and the ESP32.
- **FPGA Structure**:
  - Generates 10,000 pseudo-random bytes using an LFSR.
  - Controls a timer measuring the communication duration.
  - Requires the ESP32 to sum all 10,000 bytes (modulo 256) and return the 8-bit checksum byte.
- **Bottleneck**: Baseline uses UART at 9600 bps, which takes over 10 seconds. You must optimize this.

## Optimization Strategies
1. **Increase UART Baud Rate**:
   - The easiest optimization. Raise the baud rate from 9600 to 115200, 921600, or even 2000000 (2 Mbps) or 3000000 (3 Mbps).
   - Ensure the FPGA clock division (typically divided from 50 MHz) matches the ESP32's baud rate configuration.
2. **Implement SPI**:
   - SPI is synchronous and can run much faster than UART (e.g., 10 MHz to 20 MHz SCLK).
   - Configure the FPGA as SPI master (or slave) and the ESP32 as slave (or master).
   - Speed improvement can reduce loopback time to under 100 ms.
3. **Parallel GPIO Direct Bus**:
   - Implement an 8-bit parallel bus with strobe/acknowledge handshaking.
   - Requires 8 data lines + 2 handshake control lines.
   - Extremely fast, but requires careful routing and timing synchronization.

## Pinout and Wiring
- Ensure you map pins to JP1 (GPIO[35:0]) or the Arduino header on the DE10-Lite.
- Use short, stable jumper wires to reduce noise at higher speeds.
- Check common grounds!
