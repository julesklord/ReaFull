# ReaFull 🎛️🐧

> **The Ultimate REAPER Production, Mixing & Mastering Suite for Linux.**  
> *100% Native, Fully Sanitized, Battery-Included, and Automated.*

![ReaFull Splash](assets/branding/Splash%20ReaFull.png)

---

## 🌟 Overview

**ReaFull** is a comprehensive, analog-modeled digital audio workstation distribution and configuration suite tailored specifically for **Cockos REAPER on Linux**.

It transforms REAPER into an out-of-the-box studio workstation:
- **100% Linux Native**: All Windows paths (`C:\...`), backslashes, user-specific caches, and broken VST references are completely eradicated and replaced with dynamic variables.
- **Battery-Included**: Ships with full analog and digital JSFX processing suites, complete GUI assets, and curated presets.
- **Smart Non-Destructive Installer**: Backs up your existing environment and preserves your ALSA, JACK, and Pipewire audio device hardware settings, buffer sizes, licenses, and recent projects.
- **Automated Typography**: Automatically installs studio-grade fonts into fontconfig.

---

## 🎨 Themes & Aesthetics

ReaFull features 4 curated theme flavors:
- **ReaFull Pro** — Flagship dark studio console aesthetic with high-contrast metering and refined channel strips.
- **ReaFull Dark** — Ultra-dark obsidian theme for long nighttime mixing sessions.
- **ReaFull Gray** — Balanced neutral gray theme inspired by modern analog hardware.
- **ReaFull Light** — Clean, high-visibility daylight editing theme.

---

## 🎛️ Included Processing Suites (JSFX)

### 📻 ReaFull Analog FX
- **SolidBus:** Classic British SSL G-Master Bus compressor emulation.
- **DisTres-C / Distres:** Empirical Labs Distressor-style punch compressor with detector curves.
- **Pulse-EQ:** Pultec EQP-1A style passive tube equalizer with simultaneous boost/attenuation.
- **Fat-Tape / Tape-Dly:** Analog magnetic tape saturation, head bump, and warm tape delay.
- **Tube-Pre:** Warm tube preamp harmonic saturation.
- **FET-76 & Opto-2A:** 1176-style peak limiter and LA-2A optical leveling amplifier.
- **Sum-Desk / Sum-Mix / Sum-Strip / Mix-Chan:** Console channel and bus summing modules.
- **VU Zeno & VU-TK:** Calibrated analog needle VU meters.

### 💻 ReaFull Digital FX
- **D-Comp & D-MSComp:** Modern precision digital compressor with Mid/Side matrixing.
- **D-DynEQ & D-EQ:** Dynamic surgical parametric equalizer.
- **Reflex 1, 2, 3:** Studio reverb suite (Plates, Rooms, and Large Halls).
- **D-Meter:** Integrated LUFS, RMS, and Peak loudness metering for streaming and broadcast standards.
- **T-FFT Analyzer:** High-resolution real-time spectrum visualizer.
- **Test Tone & Calibration Tools:** Pure tone, pink noise, and white noise signal generators.

---

## 🚀 Quick Installation (Linux)

### 1. Requirements
- **REAPER for Linux** (Native build or Flatpak).
- **Python 3** & **Bash**.
- Recommended: `sws` and `reapack` extensions.
- `fontconfig` (`fc-cache`) & `curl`.

### 2. Install

```bash
# 1. Clone the repository
git clone https://github.com/julesklord/ReaFull.git
cd ReaFull

# 2. Run the installer (Make sure REAPER is closed)
./install.sh
```

Open REAPER and enjoy your complete ReaFull studio workstation!

---

## ⚙️ Advanced CLI Options

```bash
# Dry run simulation (checks what would be changed without writing)
python3 install.py --dry-run

# Target a custom REAPER directory (e.g. Flatpak)
python3 install.py --target ~/.var/app/fm.reaper.Reaper/config/REAPER

# Silent non-interactive installation
python3 install.py --quiet --no-backup

# Restore previous backup
./uninstall.sh
```

---

## 🔄 In-DAW Updater

ReaFull includes an in-DAW script located in `assets/Scripts/ReaFull/ReaFull_Updater.lua` to check for GitHub updates, trigger ReaPack synchronization, and refresh themes on the fly.

---

## 🙏 Credits & Acknowledgments

**ReaFull** is maintained, packaged, and adapted for Linux by **Jules Martins** ([@julesklord](https://github.com/julesklord)).

Special recognition and full credit to:
- **Edu Serra** (*ReArtist Pro*): Original conceptual design, workflow structure, and custom JSFX DSP DSP algorithms.
- **Cockos**: For the incredible REAPER DAW and JSFX language.
- **The REAPER Community**:
  - **FeedTheCat (FTC)** (*MIDI Editor Magic, Folder Magic, Smart Freeze, Razor Edits*).
  - **HeDa** (*Track Inspector 2, HeDaScripts*).
  - **Lokasenna** (*Lokasenna GUI v2*).
  - **Michael Pilyavskiy (MPL)**, **X-Raym**, **Archie**, **Zaibuyidao**, **Saike**, **Sonic Anomaly**, **Tilr**, and **StevieKeys**.
- **SWS Extension Team** and **Christian Fillion (cfillion / ReaPack)**.

---

## 📄 License

This repository and its installation tooling are released under the [MIT License](LICENSE).  
Bundled JSFX and ReaScripts maintain their respective open-source licenses and author attributions.
