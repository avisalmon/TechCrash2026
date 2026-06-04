// ============================================================
// CrashTech VLSI-2026 — Challenge 1: Volt-Meter (ESP32 side)
// ============================================================
#include <Arduino.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include "../../../../projects/common/esp32/pin_config.h"

// ---- OLED Display ----
Adafruit_SSD1306 oled(OLED_WIDTH, OLED_HEIGHT, &Wire, -1);
bool oledOk = false;

// ---- UART to FPGA ----
HardwareSerial FpgaSerial(2);

// ---- Timing Throttles ----
unsigned long lastSendTime = 0;
const unsigned long SEND_INTERVAL_MS = 100; // Send voltage every 100ms

unsigned long lastDisplayTime = 0;
const unsigned long DISPLAY_INTERVAL_MS = 100; // Update display every 100ms

void setup() {
    // Debug serial output
    Serial.begin(115200);
    delay(1000);
    Serial.println("Challenge 1: Volt-Meter ESP32 Setup...");

    // OLED I2C Bus setup
    Wire.begin(PIN_OLED_SDA, PIN_OLED_SCL);

    // Scan I2C bus for the OLED address
    byte discoveredAddr = 0;
    Serial.println("Scanning I2C bus...");
    for (byte address = 1; address < 127; address++) {
        Wire.beginTransmission(address);
        byte error = Wire.endTransmission();
        if (error == 0) {
            Serial.printf("I2C device found at address 0x%02X\n", address);
            if (address == 0x3C || address == 0x3D) {
                discoveredAddr = address;
            }
        }
    }

    if (discoveredAddr == 0) {
        Serial.println("[!] No I2C display discovered! Trying default 0x3C...");
        discoveredAddr = OLED_I2C_ADDR;
    }

    oledOk = oled.begin(SSD1306_SWITCHCAPVCC, discoveredAddr);
    if (!oledOk) {
        Serial.printf("[!] OLED initialization failed at address 0x%02X!\n", discoveredAddr);
    } else {
        Serial.printf("[+] OLED successfully initialized at address 0x%02X\n", discoveredAddr);
        oled.clearDisplay();
        oled.setTextColor(SSD1306_WHITE);
        oled.setTextSize(1);
        oled.setCursor(0, 0);
        oled.println("Volt-Meter Init...");
        oled.display();
    }

    // Initialize UART to FPGA (9600 8N1)
    FpgaSerial.begin(FPGA_BAUD, SERIAL_8N1, PIN_FPGA_RX, PIN_FPGA_TX);
    Serial.println("UART initialized to FPGA at 9600 baud.");
}

void loop() {
    unsigned long now = millis();

    // Read potentiometer voltage (GPIO34)
    int adcRaw = analogRead(PIN_ANALOG_IN);
    float voltage = (adcRaw / 4095.0f) * 3.3f;

    // Send voltage over UART to FPGA every 100ms
    if (now - lastSendTime >= SEND_INTERVAL_MS) {
        lastSendTime = now;
        FpgaSerial.printf("%.2f\n", voltage);
        
        // Print to host PC Serial Monitor for debugging
        Serial.printf("ADC: %d | Voltage: %.2fV\n", adcRaw, voltage);
    }

    // Update OLED Display
    if (oledOk && (now - lastDisplayTime >= DISPLAY_INTERVAL_MS)) {
        lastDisplayTime = now;

        oled.clearDisplay();
        
        // Header
        oled.setTextSize(1);
        oled.setTextColor(SSD1306_WHITE);
        oled.setCursor(0, 0);
        oled.println("    VOLT-METER    ");
        oled.drawFastHLine(0, 10, 128, SSD1306_WHITE);

        // Large Voltage Display
        oled.setTextSize(2);
        oled.setCursor(20, 20);
        oled.printf("%.2f V", voltage);

        // Progress/Level Bar
        oled.drawRect(10, 48, 108, 10, SSD1306_WHITE);
        int barWidth = map(adcRaw, 0, 4095, 0, 106);
        oled.fillRect(11, 49, barWidth, 8, SSD1306_WHITE);

        oled.display();
    }
}
