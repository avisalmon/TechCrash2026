# CrashTech VLSI 2026 — Website Specification

## 1. Event Overview

**Event name:** CrashTech VLSI 2026  
**Location:** Technion — Israel Institute of Technology  
**Format:** CrashTech hackathon (see CrashTech def.txt)  
**Duration:** 24 hours  
**Domain:** VLSI / Digital Design  
**Hardware platform:** DE10-Lite FPGA + ESP32 Controller Kit  

---

## 2. Event Structure

### 2.1 Pre-Event Phase (2 Weeks Before)

- Participants receive the DE10-Lite FPGA board and ESP32 kit
- Website opens with:
  - Example practice challenges (open, non-secret)
  - Downloadable skills and tools
  - Training materials and examples
  - Hardware setup references
- **Self-discovery model:** No tutorials, no live support, no instructions. Participants learn independently using the website, the internet, and AI tools
- VS Code + GitHub Copilot are recommended and encouraged

### 2.2 Competition Day (24 Hours)

- A pool of **secret challenges** — not revealed in advance
- Challenges are exposed **on demand** when a team requests one
- Many small challenges (not one large project)
- Teams accumulate points across completed challenges
- Judges validate completion and measure time

### 2.3 Challenge Scoring Models

Each challenge follows one of two scoring models:

| Model | Criteria | Description |
|---|---|---|
| **Completion** | Pass/Fail + Time | Binary completion. Points awarded for finishing; faster completion scores higher |
| **Performance** | Quantitative Metric + Time | Measured result (e.g., clock speed, area, throughput). Better metric and faster time score higher |

---

## 3. Website Purpose

The website is the **single source of truth** for the entire event. It serves three roles:

1. **Information hub** — Event details, schedule, rules, registration
2. **Resource center** — Pre-event materials, skills downloads, practice challenges, examples
3. **Competition platform** — Challenge delivery, scoring, leaderboard during the event

---

## 4. Site Structure

The site has a **persistent top navigation bar** with tabs. Each tab leads to a dedicated page. The structure is designed so that a participant can find everything they need through the tabs alone.

### Navigation Bar Tabs

```
[ Home ] [ The Event ] [ Hardware ] [ Get Started ] [ Practice Challenges ] [ AI Tools ] [ Event Day ] [ Leaderboard ] [ Register ]
```

---

### 4.1 Home (Landing Page)

The main page. Gives a high-level overview of the entire event in a single scroll.

**Content:**
- Hero banner with event name, date, location, visual identity
- Countdown timer to event start
- One-paragraph explanation: what CrashTech VLSI is
- The core philosophy in 3–4 bullet points:
  - 24-hour VLSI hackathon
  - Real FPGA hardware, real challenges
  - Self-discovery — no hand-holding
  - AI-assisted engineering encouraged
- Visual overview of the event flow (pre-event → event day → results)
- Quick links to each tab section for easy navigation
- Call-to-action: Register Now

---

### 4.2 The Event

Everything about how the event works.

**Content:**
- What is CrashTech — the concept (cross-discipline, fast prototyping)
- What is CrashTech VLSI 2026 specifically — VLSI focus, Technion context
- Self-discovery philosophy: no tutorials, no support, you figure it out
- Pre-event timeline (kit distribution, practice period)
- Event day flow (24 hours, challenge-based)
- Challenge mechanics:
  - Challenges are secret until event day
  - Revealed on demand when a team requests one
  - Many small challenges, not one big project
- Scoring system:
  - Completion-based: pass/fail + time
  - Performance-based: quantitative metric + time
- Judging process — judges validate and measure
- Rules and constraints
- Team size and composition

---

### 4.3 Hardware

The hardware platform used in the event.

**Content:**
- DE10-Lite FPGA board — overview, key specs, photo
- ESP32 Controller Kit — overview, key specs, photo
- What each participant/team receives
- When they receive it (2 weeks before the event)
- Kit pickup logistics

---

### 4.4 Get Started (Training & Setup)

How to prepare for the event. The self-guided training hub.

**Content:**
- Getting started checklist (step by step):
  1. Pick up your hardware kit
  2. Install development tools (Quartus, Arduino IDE, etc.)
  3. Set up VS Code with GitHub Copilot
  4. Run your first FPGA design on the DE10-Lite
  5. Run your first ESP32 program
  6. Try a practice challenge
- Training materials and examples:
  - Reference designs
  - Example projects
  - Datasheets and pinout references
- Downloadable skills files (tools, utilities, starter templates)
- Links to external resources (vendor docs, community forums, datasheets)
- Reminder: self-discovery — explore, experiment, learn

---

### 4.5 Practice Challenges

Open practice challenges available before the event. These are **not secret** — they are meant for training. Solutions are not provided — self-discovery applies here too.

Each challenge card on the website shows: title, difficulty, scoring model, description, requirements, and hints about what skills/tools are involved.

---

#### Practice Challenge 1: Real-Time Clock (FPGA + ESP32 + Web)

**Title:** Internet Clock  
**Difficulty:** Medium  
**Scoring model:** Completion + Time  
**Skills involved:** FPGA ↔ ESP32 communication, WiFi, web API, seven-segment display

**Description:**

Build a real-time clock powered by the internet. The ESP32 connects to a public time API over WiFi, retrieves the current time, and continuously transmits it to the DE10-Lite FPGA. The FPGA displays the live hours, minutes, and seconds on its six seven-segment displays.

**Requirements:**
- ESP32 fetches the current time from a web API (e.g., WorldTimeAPI, NTP server)
- ESP32 transmits time data to the FPGA over a wired interface (UART, SPI, or I2C via GPIO/Arduino header)
- FPGA displays the time on HEX5–HEX0 in `HH.MM.SS` format
- Clock updates in real time (at least once per second)
- The system must work autonomously after power-on (no PC required after programming)

**What you'll learn:**
- Wiring and protocol between ESP32 and DE10-Lite
- WiFi and HTTP/NTP on ESP32
- Receiving serial data on FPGA
- Seven-segment display driving

---

#### Practice Challenge 2: Retro Game (ESP32 Screen + FPGA Controls)

**Title:** Retro Arcade  
**Difficulty:** Hard  
**Scoring model:** Completion + Time  
**Skills involved:** FPGA button/switch input, FPGA → ESP32 communication, ESP32 graphics/game engine

**Description:**

Create a playable retro-style game that runs on the ESP32 kit's screen, where the game controls (movement, actions) come from the DE10-Lite FPGA's buttons and switches. The FPGA reads the physical inputs and sends control commands to the ESP32, which renders the game.

**Requirements:**
- Game runs on the ESP32 kit's LCD screen (any retro game: Pong, Snake, Breakout, Space Invaders, etc.)
- Player controls are physically on the FPGA: buttons (KEY[0], KEY[1]), switches, or addon joystick
- FPGA reads inputs and transmits control commands to ESP32 over a wired interface
- Game must be playable — responsive controls, visible graphics, win/lose condition
- Bonus points for creativity, polish, and fun factor

**What you'll learn:**
- Bidirectional or unidirectional FPGA → ESP32 communication
- Reading buttons/switches on the FPGA
- Game loop and graphics rendering on ESP32
- Real-time input handling across two devices

---

#### Practice Challenge 3: Digital Volt Meter (FPGA ADC + ESP32 Display)

**Title:** Volt Meter  
**Difficulty:** Medium  
**Scoring model:** Completion + Time  
**Skills involved:** FPGA ADC, analog measurement, FPGA → ESP32 communication, ESP32 display

**Description:**

Turn your hardware kit into a digital volt meter. The DE10-Lite FPGA uses its onboard ADC to probe an external voltage source (e.g., a battery, a potentiometer divider, or a power supply output). It measures the voltage and sends the reading to the ESP32, which displays the voltage value on its screen in a clear, formatted display.

**Requirements:**
- FPGA reads voltage through its onboard ADC (MAX 10 ADC, channels available via GPIO/Arduino header)
- Measured voltage is transmitted from FPGA to ESP32 over a wired interface
- ESP32 displays the voltage on its LCD screen (e.g., "3.27 V") with at least 2 decimal places
- Display updates in real time (at least 2 updates per second)
- Measurement range: 0–3.3V (the ADC reference voltage)
- Safety: do NOT connect voltages above 3.3V to the ADC input

**What you'll learn:**
- Using the MAX 10 onboard ADC (Qsys IP, Avalon-MM interface)
- Analog signal conditioning and measurement
- FPGA → ESP32 data transmission
- Formatted numeric display on ESP32 screen

---

### 4.6 AI Tools (VS Code, GitHub Copilot & Skills)

How to leverage AI tools to compete effectively.

**Content:**
- Why AI tools matter in CrashTech — speed, exploration, learning
- VS Code setup for VLSI/FPGA development
- GitHub Copilot — what it is, how to use it for HDL / embedded code
- Copilot Skills — downloadable skills files specific to this event:
  - What skills are available
  - How to install and use them in VS Code
  - Download links
- Tips for effective AI-assisted engineering
- Reminder: using AI tools is encouraged and expected

---

### 4.7 Event Day (Competition — Live During Event)

The competition hub. Active only during the 24-hour event.

**Content:**
- Challenge catalog — revealed progressively on-demand
- Each challenge card shows:
  - Title
  - Scoring model (completion or performance)
  - Description and requirements
  - Point value
- Challenge request mechanism (how a team asks for the next challenge)
- Access control: challenges hidden until requested
- Schedule / timeline of the event day
- Key moments (opening ceremony, milestones, judging, awards)
- Contact info for judges (for validation only, not for help)

---

### 4.8 Leaderboard

Real-time competition standings.

**Content:**
- Live team rankings
- Points breakdown per challenge per team
- Time stamps for completions
- Updated in real-time during the event
- Post-event: final standings preserved

---

### 4.9 Register

Event registration.

**Content:**
- Team registration form:
  - Team name
  - Team members (names, emails, roles)
  - Contact person
- Kit pickup preference / logistics
- Terms and rules acknowledgment
- Confirmation flow

---

### 4.10 FAQ

**Content:**
- Common questions about the event, hardware, rules, scoring, tools
- Accessible from the footer or as a sub-section (not a main tab)

---

## 5. Key Design Principles

1. **Clean and modern** — Professional, tech-focused visual identity
2. **Mobile-friendly** — Participants will use phones during the event
3. **Fast** — Static site, minimal load times
4. **Self-contained** — All information findable without external help
5. **Event-state aware** — Content changes based on phase (pre-event → live → post-event)

---

## 6. Open Items (To Be Defined)

- [x] ~~Exact event date~~ → **April 30 – May 1, 2026 (tentative, may shift due to exam schedule)** — Per Tami Sasporta / Rotem Ben-Hur, Mar 16 2026
- [ ] Registration process details
- [ ] Number of challenges and point values
- [ ] Challenge categories / difficulty tiers
- [ ] Judge panel composition
- [ ] Team size limits
- [ ] Prize structure
- [ ] Branding / visual identity — note: event name uses dash: **CrashTech VLSI-2026**
- [x] ~~Hosting and deployment approach~~ → GitHub Pages (avisalmon.github.io/TechCrash2026)
- [x] ~~Tech stack for the website~~ → Static HTML/CSS/JS single-page app
- [ ] Authentication (if needed for challenge access)
- [ ] Admin panel for judges (challenge reveal, scoring input)
