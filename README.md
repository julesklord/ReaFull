# ReaFull 🎛️🐧

> **The Ultimate REAPER Production, Mixing & Mastering Suite for Linux.**  
> *100% Native, Fully Sanitized, Battery-Included, and Automated.*

---

## 🌟 Overview

**ReaFull** transforms Cockos REAPER into a comprehensive, analog-modeled digital audio workstation tailored specifically for **Linux**. 

Built upon the extensive features of *ReArtist Pro 2025*, ReaFull eliminates all Windows dependencies, sanitizes hundreds of hardcoded paths, fixes cross-platform separator bugs, bundles the complete custom JSFX plugin collection, and provides an intelligent non-destructive installer.

---

## ✨ Features & What's Included

### 🎚️ 1. Analog & Digital JSFX Suite (Battery-Included)
Emulations of legendary studio hardware with custom graphical interfaces and ready-to-use presets:
- **Compressors & Limiters:** SolidBus (SSL G-Bus style), DisTres-C (Distressor style), Vari-Mu, Retro-C, VCA Comp, FET-76, D-MSComp (Mid/Side), D-Multi (Multiband), D-Limit.
- **Equalizers & PreAmps:** Pulse-EQ (Pultec EQP-1A style), Tube-Pre, D-DynEQ (Dynamic EQ), D-EQ, Module-A / Module-B.
- **Tape & Analog Summing:** Fat-Tape, Sum-Desk, Sum-Mix, Sum-Strip, Mix-Chan (Console channel summing).
- **Reverbs & Spatial FX:** Reflex 1, Reflex 2, Reflex 3 (Lexicon-inspired room/plate/hall reverbs), D-Delay, Tape-Dly.
- **Measurement & Metering:** VU Zeno / VU-TK meters, Circles Meter, D-Meter (LUFS/RMS integrated for streaming and CD mastering), T-FFT spectrum analyzer, tone and pink noise generators.
- **Integrated Community Powerhouses:** Bundled selections from *Sonic Anomaly*, *Saike*, *Tilr*, *HeDa*, *Liteon*, *Loser*, *Stillwell*, and more.

### 🎨 2. Themes & Typography
- **4 Pro Themes:** `ReArtist 2.0 Pro`, `ReArtist 2.0 Dark`, `ReArtist 2.0 Gray`, and `ReArtist 2.0 Light`.
- **Automated Font Engine:** Installs required fonts (*Electrolize, Frozen Crystal, Orbitron, Roboto, OpenSans, Alarm Clock*) into `~/.local/share/fonts/ReArtist/` and automatically updates the Linux fontconfig cache.
- Custom High-Resolution Splash Screen and HiDPI (150% / 200%) toolbar icons.

### 📐 3. Workflow, Track & Project Templates
- **17 Track Template Categories:**
  - `00 Default` (Audio inputs, Auxiliaries, Sub-Buses, MixBus, Phones)
  - `01 Electronic`, `02 Drums`, `03 Percussion (Latin & Acoustic)`, `04 Bass`
  - `05 AC Guitars`, `06 EL Guitars`, `07 Keyboards & Synths`
  - `08 Brass`, `09 Winds`, `10 Strings`, `11 Vocals (Lead & Backing)`
  - `12 Video Post`, `13 Podcasting`, `14 FX Reverbs & Delays`, `15 Stems`, `16 Separators`
- **Complete Project Templates:** Pre-routed project bases for *Rock/Metal, Salsa, Ranchera/Mariachi, Bolero, Jazz/Blues, Urban/Electronic, and AAA Mastering*.

### ⚡ 4. Smart Automation & Scripts
- **SWS AutoColor & Icons:** Over 310 intelligent auto-color and auto-icon assignment rules (Linux forward-slash normalized).
- **Fast Screensets:** Dedicated workspace layouts for *Record Mode*, *Mix Mode*, and *Mastering*.
- **Integrated ReaScripts:** *FTC Tools (MIDI Editor Magic, Folder Magic, Smart Freeze, Razor Edits)*, *HeDa Track Inspector 2*, *Lokasenna GUI v2*, *Zaibuyidao*, *Archie*, *MPL*, and *X-Raym*.
- **In-DAW ReaFull Updater & Downloader:** One-click script in REAPER to check for updates, download external expansion packs, and sync ReaPack repositories.

---

## 🚀 Installation on Linux

### Prerequisites
- **Cockos REAPER** (Native Linux build or Flatpak).
- **Python 3** & **Bash**.
- Recommended: `sws` and `reapack` extensions (available via Arch/CachyOS AUR, Ubuntu PPA, or ReaPack installer).
- `fontconfig` (`fc-cache`) and `curl`.

### Quick Start

1. **Save your open projects and close REAPER.**
2. Clone the repository and run the installer:
   ```bash
   git clone https://github.com/julesklord/ReaFull.git
   cd ReaFull
   ./install.sh
   ```
3. Open REAPER. Everything is pre-configured and ready!

---

## 🛠️ Advanced Installer Options

The installer script (`install.py` / `install.sh`) is modular and provides multiple flags:

```bash
# Preview what would be installed without modifying any files
python3 install.py --dry-run

# Specify a custom REAPER directory (e.g. for portable or Flatpak installs)
python3 install.py --target ~/.var/app/fm.reaper.Reaper/config/REAPER

# Non-interactive silent installation
python3 install.py --quiet --no-backup

# Restore a previous backup if you ever want to revert
./uninstall.sh
```

---

## 🛡️ Non-Destructive Merging

Unlike manual copy-pasting that overwrites your hardware preferences, the **ReaFull Installer** performs an intelligent non-destructive configuration merge:
- **Preserved unconditionally:**
  - ALSA / JACK / Pipewire audio devices and channel mappings (`alsa_indev`, `alsa_outdev`, `linux_audio_bsize`, `srate`, etc.).
  - MIDI controller configurations.
  - License / registration key.
  - Recent project history.
- **Updated seamlessly:**
  - Toolbars, screensets, colors, docker positions, theme layouts, JSFX presets, and action registrations.

---

## 📁 Repository Structure

```text
ReaFull/
├── assets/                  # Complete asset payload (JSFX, Scripts, Themes, Data, Templates)
│   ├── ColorThemes/         # ReArtist 2.0 Theme variants
│   ├── Data/                # Toolbar icons, track icons, ReaImGui, ReaSonus
│   ├── Effects/             # ReArtist Analog FX, Digital FX, Saike, FTC, Liteon, etc.
│   ├── Fonts/               # TrueType & OpenType typography
│   ├── FXChains/            # Analog mastering and mixing FX chains
│   ├── ProjectTemplates/    # Genre-based session templates
│   ├── Scripts/             # Edu Serra, FTC Tools, HeDa, ReaTeam, ReaFull Updater
│   ├── TrackTemplates/      # 17 categories of pre-routed tracks
│   └── branding/            # Splash screen art
├── config_templates/        # 100% sanitized cross-platform configuration templates
│   ├── reaper-kb.ini        # Clean relative script actions
│   ├── sws-autocoloricon.ini# Linux-normalized icon rules
│   ├── reaper.template.ini  # UI & docker layout template
│   └── ...
├── scripts/                 # Maintenance, sanitization & verification utilities
├── install.sh               # User-friendly Bash installer wrapper
├── install.py               # Robust Python installation engine
├── uninstall.sh             # Backup restoration utility
├── .gitignore
├── LICENSE
└── README.md
```

---

## 📄 License

This repository and its automation scripts are released under the **MIT License**.  
Individual bundled JSFX effects and ReaScripts maintain their respective open-source licenses (MIT, GPL, Cockos, and Author-attributed).
