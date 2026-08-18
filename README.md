<p align="center">
  <img src="docs/logo_mark.png" alt="ReaFull Logomark" width="160" height="160" />
</p>

<h1 align="center">ReaFull</h1>

<p align="center">
  <strong>A modular, production-grade workstation suite for Cockos REAPER on Linux.</strong>
</p>

ReaFull transforms Cockos REAPER on Linux into a studio-ready workstation for production, mixing, and mastering. It integrates analog-modeled JSFX consoles, surgical digital DSP, 200+ track templates, genres-based project templates, studio typography, and non-destructive Linux audio engine optimizations.

---

## 1. Overview

- **Linux Native & Clean**: 100% sanitized for POSIX standards, zero Windows drive letters, and dynamic path expansion for both Native and Flatpak installations.
- **Non-Destructive by Default**: In `Overlay` mode, ReaFull merges your configuration safely. It preserves your existing keyboard shortcuts (`reaper-kb.ini`), mouse modifiers (`reaper-mouse.ini`), custom menus, and non-destructively merges ReaPack repositories without deleting existing ones.
- **Smart Automated Backups**: Every install creates a complete timestamped backup (`~/.config/REAPER_backup_pre_reafull_YYYYMMDD_HHMMSS`) before applying changes.
- **Modular Component Selector**: Choose exactly what to install via an interactive CLI menu or command-line flags (~858 MB full suite down to ~20 MB minimal theme/audio core).
- **Post-Install Health Verification**: Includes an automated verification engine that checks for broken paths, missing assets, and unexpanded placeholders upon completion.

---

## 2. Studio Interface & Workflow Showcase

### 2.1 ReaFull Production Suite Showcase (Latest v2026.2)

[![ReaFull Studio Console Demo v2](https://raw.githubusercontent.com/julesklord/ReaFull/main/docs/demo_preview.gif)](https://github.com/julesklord/ReaFull/raw/main/docs/demo.mp4)

> 🎬 **High-Definition Video:** [View / Download MP4 (`docs/demo.mp4`)](https://github.com/julesklord/ReaFull/raw/main/docs/demo.mp4) · [WebM Version (`docs/demo.webm`)](https://github.com/julesklord/ReaFull/raw/main/docs/demo.webm) · [Poster Frame](https://raw.githubusercontent.com/julesklord/ReaFull/main/docs/demo_poster.png)

### 2.2 Classic Analog Console Showcase (Archive v1)

[![ReaFull Classic Studio Console Demo](https://raw.githubusercontent.com/julesklord/ReaFull/main/docs/demo_v1_preview.gif)](https://github.com/julesklord/ReaFull/raw/main/docs/demo_v1.mp4)

> 🎬 **Archive Video:** [View / Download MP4 (`docs/demo_v1.mp4`)](https://github.com/julesklord/ReaFull/raw/main/docs/demo_v1.mp4) · [WebM Version (`docs/demo_v1.webm`)](https://github.com/julesklord/ReaFull/raw/main/docs/demo_v1.webm)

---

## 3. Included Subsystems & Component Breakdown

### 3.1 Audio Processing Suites (JSFX)

#### ReaFull Analog FX Suite
Analog hardware emulations with dedicated GUIs:
- **SolidBus**: British VCA master bus compressor with auto-release and high-pass detector filter.
- **DisTres-C / Distres**: Non-linear knee compressor with opto response and harmonic distortion injection.
- **Pulse-EQ**: Passive tube program EQ (Pultec-style) with simultaneous low-frequency boost/cut and high-frequency band selection.
- **FET-76**: Ultra-fast FET peak limiter with 4:1, 8:1, 12:1, 20:1, and all-buttons mode.
- **Opto-2A**: Electro-optical leveling amplifier with program-dependent dual-stage release.
- **Vari-Mu**: Variable-mu vacuum tube glue compressor for mixbuses and stereo buses.
- **Retro-C**: Vintage variable-gain tube leveler.
- **VCA-160 / VCA Comp**: Fast, punchy VCA dynamic processor for percussive transients.
- **Fat-Tape**: Analog magnetic tape recorder simulation with tape speed, saturation, and head-bump resonance.
- **Tape-Dly**: Bucket-brigade and tape delay unit with flutter and tone filtering.
- **Tube-Pre**: Triode/pentode tube preamplifier with harmonic drive.
- **Mix-Chan / Mix-Bus / Sum-Desk / Sum-Strip**: Analog console summing modules with crosstalk and harmonic coloration.
- **ST-Bass / ST-Guitar**: Dedicated analog channel strips for direct bass and electric guitars.
- **VU-TK / VU-Z**: Ballistic needle VU meters calibrated to -18 dBFS / -14 dBFS references.

#### ReaFull Digital FX Suite
Precision surgical mixing and mastering tools:
- **D-DynEQ**: Dynamic parametric equalizer with per-band threshold, ratio, attack, and release.
- **D-EQ / D-ReEQ**: Multi-band high-precision parametric equalizers with FFT curve displays.
- **D-Comp**: Transparent digital feed-forward compressor with variable knee.
- **D-MSComp**: Dedicated Mid/Side matrix compressor.
- **D-Limit**: Mastering true-peak brickwall limiter with lookahead buffers.
- **D-Multi**: Multiband dynamic processor with linear-phase crossovers.
- **Reflex 1, 2, 3**: Algorithmic reverb suite delivering plate, room, and hall simulations.
- **D-Meter / T-Meter**: EBU R128 / ITU-R BS.1770-4 LUFS loudness analyzer with True Peak and RMS.
- **T-FFT**: Real-time high-resolution FFT spectrum visualizer.
- **Calibration Tools (T-Tone, T-Pink, T-White, T-Phase, T-Quiet)**: Test signal generators and phase alignment utilities.

#### Integrated Community Suites
- **Saike Tools**: Physical modeling synthesis, dynamic saturation, and diffusion processors.
- **Sonic Anomaly**: SLAX-C, QuadraCom, Hybrid-C, SEGX2-G, and TriLeveler2.
- **tilr**: Step sequencers, envelope tools, and utility processors.
- **Liteon, LOSER, Stillwell, Schwa, Mawi**: Essential mathematical algorithms for filtering and stereo imaging.

---

### 3.2 Themes & Typography
- **ReaFull Pro**: Flagship dark console theme optimized for contrast, extended sessions, and clean dockers.
- **ReaFull Dark**: Ultra-dark theme for nighttime workflows.
- **ReaFull Gray**: Balanced neutral studio console theme.
- **ReaFull Light**: High-contrast theme engineered for daylight production.
- **Studio Typography**: Automated installation and fontconfig registration of studio fonts (*Electrolize, Frozen Crystal, Orbitron, Roboto, Open Sans, Alarm Clock*) in `~/.local/share/fonts/ReaFull/`.

---

### 3.3 Workflow Templates

#### 17 Categorized Track Template Modules (200+ Strips)
Pre-routed strips with coloring, icons, and gain staging:
1. `00 Default` (Inputs, Auxiliaries, Sub-Buses, MixBus, Monitoring/Phones)
2. `01 Electronic` · `02 Drums` · `03 Percussion` · `04 Bass`
3. `05 AC Guitars` · `06 EL Guitars` · `07 Keyboards & Synths`
4. `08 Brass` · `09 Winds` · `10 Strings` · `11 Vocals`
5. `12 Video Post` · `13 Podcasting` · `14 FX Reverbs/Delays` · `15 Stems` · `16 Separators`

#### Genre-Tailored Project Templates
Complete session routing, VCA groups, and master bus processing for:
- AAA Mastering, Rock/Blues/Stoner, Salsa/Latin, Ranchera/Mariachi, Metal/Hard Rock, Jazz, Urban/Electronic, Bolero Cubano.

---

### 3.4 StripTease Modular Mixer Strip Engine
- **Embedded MCP Strips**: Turns any REAPER track mixer into a modular console strip with live knobs, switches, and needle VU Gain Reduction meters directly inside the Mixer Control Panel (MCP).
- **Direct Link**: Seamlessly connects modular panel controls to any plugin parameter in real-time.
- **Auto GR Metering**: Automatically captures and renders gain reduction from compressors (SSL, VSC-2, DBX, 1176, LA-2A, ReaFull Analog FX).
- **Modular Panel Heights**: 7 fixed pixel-height modules (`50px`, `100px`, `150px`, `200px`, `300px`, `400px`, `600px`) with synchronized preset banks and custom color palettes.
- **Curated FX Chains**: Includes 12 ready-to-use SSL, UAD, Vertigo, and Mastering channel strips.

---

## 4. Installation & Terminal Experience

### 4.1 Quick Start

**Direct One-Liner Installation (cURL):**
```bash
curl -fsSL https://raw.githubusercontent.com/julesklord/ReaFull/main/install.sh | bash
```

*Or via Git:*
```bash
git clone https://github.com/julesklord/ReaFull.git
cd ReaFull
./install.sh
```

### 4.2 Interactive CLI Experience & Automated Verification

| 1. Interactive Modular Selector | 2. Deployment & Health Verification |
| :---: | :---: |
| ![Interactive Modular Selector](https://raw.githubusercontent.com/julesklord/ReaFull/main/docs/terminal_interactive.png) | ![Deployment & Health Verification](https://raw.githubusercontent.com/julesklord/ReaFull/main/docs/terminal_install.png) |

---

## 5. CLI Reference & Profiles

```bash
# Overlay Profile (Default: non-destructive, preserves user shortcuts, menus, and custom INIs)
./install.sh --profile overlay

# Fresh Studio Profile (Clean studio configuration: deploys all defaults)
./install.sh --profile fresh

# Preset Selections
./install.sh --preset core         # Core Studio Suite (<700 MB: Themes, Analog & Digital FX, Templates, SWS, Fonts)
./install.sh --preset full         # Complete installation including all community suites (~858 MB)
./install.sh --preset minimal      # Essential UI, fonts, and audio tuning (~20 MB)
./install.sh --preset fx-only      # JSFX plugin suites and presets (~640 MB)
./install.sh --preset themes-only  # Themes, icons, and SWS rules (~20 MB)
./install.sh --preset extras       # Community plugins and extra scripts (~180 MB)

# Target Resolution (Native, Flatpak, or Custom path)
./install.sh --target native       # Installs to ~/.config/REAPER
./install.sh --target flatpak      # Installs to ~/.var/app/fm.reaper.Reaper/config/REAPER
./install.sh --target /custom/dir  # Custom target directory

# Force overwrite of keyboard shortcuts and custom menus
./install.sh --force

# Simulation / Dry Run without modifying files
./install.sh --dry-run --preset core

# Silent non-interactive installation
./install.sh --quiet
```

### Component Breakdown Table

| Identifier | Description | Approx. Size |
| :--- | :--- | :--- |
| `themes` | ReaFull Pro, Dark, Gray, Light Themes & Splash Screen | ~8 MB |
| `analog_fx` | ReaFull Analog FX Suite (JSFX) | ~380 MB |
| `digital_fx` | ReaFull Digital FX Suite (JSFX) | ~221 MB |
| `community_fx` | Saike, Sonic Anomaly, Tilr, Liteon, Stillwell Suites | ~34 MB |
| `templates` | 17 TrackTemplate categories & ProjectTemplates | ~5.6 MB |
| `sws_autocolor` | SWS AutoColor rules, track icons, toolbar icons HiDPI | ~43.8 MB |
| `menus_toolbars` | Floating toolbars, screensets, keymaps, mouse modifiers | ~3.0 MB |
| `scripts` | FTC Tools, HeDa, Lokasenna GUI v2, Zaibuyidao, ReaPack | ~150 MB |
| `presets` | Factory JSFX presets, FX chains, grooves, note maps | ~11.2 MB |
| `fonts` | Studio typography (`~/.local/share/fonts/ReaFull/`) | ~1.1 MB |
| `audio_tuning` | PipeWire / ALSA realtime priority & thread optimization | 0 B |
| `docs` | Resource guide and official manual references | < 1 KB |

---

## 6. Backup, Restoration & Uninstallation

Every installation creates an automated timestamped backup:
```text
~/.config/REAPER_backup_pre_reafull_YYYYMMDD_HHMMSS
```

To restore a previous backup or uninstall ReaFull components:
```bash
./uninstall.sh
```

Menu options in `uninstall.sh`:
1. **Restore Backup**: Select and restore any timestamped pre-install backup.
2. **Uninstall ReaFull Components**: Safely remove ReaFull themes, JSFX suites, and studio fonts.
3. **Clean Backups**: Delete old backups to reclaim disk space.

---

## 7. Quick Start: First 15 Minutes

1. **Launch REAPER**: The ReaFull Pro theme will load automatically.
2. **Screensets & Workspaces**:
   - `F7`: Edit & Arrangement View.
   - `F8`: Analog Mixing Console View.
   - `F9`: Mastering & Metering Suite.
3. **Insert Track Templates**: Right-click track panel → *Insert track from template* → Select from 17 categories (Drums, Vocals, MixBus, Stems).
4. **Console FX Workflow**: In FX browser, open `ReaFull Analog FX` for channel modeling (`Mix-Chan`, `SolidBus`, `Fat-Tape`, `Pulse-EQ`) or `ReaFull Digital FX` for surgical processing (`D-DynEQ`, `D-ReEQ`, `D-Meter`).
5. **ReaFull Manager**: Access `Scripts/ReaFull/ReaFull_Updater.lua` from the Action List to synchronize ReaPack packages or reload views.

---

## 8. Credits & Legal Notice

ReaFull is packaged and maintained by **Jules Martins** ([@julesklord](https://github.com/julesklord)).

### Creative Lineage & Community Acknowledgments
- **Edu Serra** (*ReArtist Pro*): Original workflow concept, track templates architecture, and analog console layouts (licensed under LGPL v3).
- **Cockos**: For REAPER and the JSFX DSP environment.
- **DSP & Script Authors**: Tukan Studios, Sonic Anomaly, Justin Johnson (ReEQ), Joep Vanlier (Saike), Tiago LR (tilr), Michael Pilyavskiy (MPL), Raymond Radet (X-Raym), FTC (FeedTheCat), Hector Corcin (HeDa), Goran Kovac (Sexan), SWS Extension Team, and Christian Fillion (cfillion / ReaPack).

For full third-party component catalog, author credits, and license disclosures, see [NOTICE.md](NOTICE.md) and [THIRD_PARTY.md](THIRD_PARTY.md).

---

## 9. License

The ReaFull installation engine and deployment scripts are licensed under the [MIT License](LICENSE).  
Bundled JSFX audio effects, ReaScripts, and fonts retain their original open-source licenses (GPL-3.0, LGPL-3.0, MIT, Apache 2.0, SIL Open Font License).
