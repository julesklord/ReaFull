<p align="center">
  <img src="docs/Splash ReaFull.png" alt="ReaFull" width="760" />
</p>

<h1 align="center">ReaFull</h1>

<p align="center">
  <strong>Production-grade workstation suite for Cockos REAPER on Linux.</strong>
</p>

<p align="center">
  <a href="https://github.com/julesklord/ReaFull/actions"><img src="https://github.com/julesklord/ReaFull/actions/workflows/ci.yml/badge.svg" alt="CI Status" /></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License" /></a>
  <a href="CHANGELOG.md"><img src="https://img.shields.io/badge/version-2026.3.5-cyan.svg" alt="Version" /></a>
  <a href="https://github.com/julesklord/ReaFull/releases"><img src="https://img.shields.io/github/downloads/julesklord/ReaFull/total.svg" alt="Downloads" /></a>
</p>

---

ReaFull transforms Cockos REAPER on Linux into a complete studio environment for music production, mixing, and mastering. It deploys analog-modeled JSFX consoles, surgical digital DSP, 200+ track templates, genre-based project templates, studio typography, Pro Tools workflow emulation, and the ReaFull Hub in-DAW manager through a single automated installer.

## Table of Contents

- [System Requirements](#system-requirements)
- [Quick Start](#quick-start)
- [Installation Profiles & Presets](#installation-profiles--presets)
- [What's Included](#whats-included)
- [ReaFull Hub (In-DAW Manager)](#reafull-hub-in-daw-manager)
- [CLI Reference](#cli-reference)
- [Backup, Restoration & Uninstallation](#backup-restoration--uninstallation)
- [First 15 Minutes](#first-15-minutes)
- [Security & Integrity](#security--integrity)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [Credits & Attribution](#credits--attribution)
- [License](#license)

---

## System Requirements

| Requirement | Details |
| :--- | :--- |
| **Operating System** | Linux (x86_64 or aarch64) |
| **REAPER** | v7.x or later (Native or Flatpak) |
| **Python** | Python 3.8+ (required by the installer) |
| **Bash** | 4.0+ (installer wrapper) |
| **Disk Space** | 20 MB (minimal) to ~860 MB (full suite) |
| **Network** | Internet connection for first install (assets downloaded from GitHub Releases) |
| **Optional** | `fc-cache` (fontconfig) for font registration, `curl` or `wget` for asset download |

---

## Quick Start

**One-liner install (downloads and runs the installer):**

```bash
curl -fsSL https://raw.githubusercontent.com/julesklord/ReaFull/main/install.sh | bash
```

**Or clone and run locally:**

```bash
git clone https://github.com/julesklord/ReaFull.git
cd ReaFull
./install.sh
```

The interactive selector guides you through component selection. Defaults to the **ReaTooled** preset (Pro Tools workflow) in non-interactive mode.

---

## Installation Profiles & Presets

### Profiles

| Profile | Behavior |
| :--- | :--- |
| `overlay` (default) | Non-destructive merge. Preserves existing keyboard shortcuts, mouse modifiers, custom menus, and ReaPack repositories. |
| `fresh` | Clean studio configuration. Overwrites all configs with ReaFull defaults. |

### Presets

| Preset | Components | Size |
| :--- | :--- | :--- |
| `reatooled` | Themes, menus/toolbars, SWS AutoColor, fonts, extensions, Pro Tools mode | ~60 MB |
| `pro-tools` | Identical to `reatooled` | ~60 MB |
| `core` | Themes, analog + digital FX, templates, SWS, menus, fonts, extensions, docs | ~670 MB |
| `minimal` | Themes, fonts | ~20 MB |
| `fx-only` | Analog + digital + community FX, presets | ~640 MB |
| `themes-only` | Themes, fonts, SWS AutoColor | ~20 MB |
| `community` | Community FX suites, scripts, presets | ~195 MB |
| `full` | All 15 components | ~860 MB |

```bash
./install.sh --preset core --profile overlay
./install.sh --preset full --target flatpak
./install.sh --preset minimal --quiet
```

---

## What's Included

### Audio Processing Suites

JSFX are shipped inside functional category folders under `Effects/ReaFull Analog FX/` and
`Effects/ReaFull Digital FX/` -- the folder names mirror the REAPER FX-browser hierarchy, so the
purpose of each plugin is evident at a glance.

**ReaFull Analog FX** -- Hardware-modeled channel processing:

| Folder | Plugins | Emulation / Purpose |
| :--- | :--- | :--- |
| `Compressors/` | SolidBus, VCA-160, Retro-C, Vari-Mu, FET-76, Opto-2A, Opto-2A-AI, Distres | SSL/VCA/1176/LA-2A/Fairchild/opto bus & peak compressors |
| `Mixing & Summing/` | Mix-Bus, Mix-Chan, Sum-Desk, Sum-Mix, Sum-Strip | Console channel strips and summing with crosstalk |
| `Drive & Saturation/` | Fat-Tape, Tube-Pre | Analog tape simulation and tube preamplifier |
| `EQ/` | Pulse-EQ | Passive tube program EQ (Pultec-style) |
| `Delay/` | Tape-Dly | Vintage tape delay (Echotukan-style) |
| `Guitar & Bass/` | ST-Guitar, ST-Bass | Dedicated dual-stage instrument channel strips |
| `Meters & Analysis/` | VU Meter, VU Zeno | Ballistic needle VU meters (-18 / -14 dBFS) |
| `Modulation/` | VoKoder | Carrier vocoder |

**ReaFull Digital FX** -- Precision mixing and mastering:

| Folder | Plugins | Function |
| :--- | :--- | :--- |
| `EQ/` | D-DynEQ, D-EQ, D-ReEQ | Dynamic and multi-band parametric EQ with FFT display |
| `Compressors/` | D-Comp, D-MSComp, D-Multi, Basic Comp | Feed-forward, Mid/Side and multiband dynamics |
| `Dynamics/` | D-Limit, D-Gate, D-Esser, D-Noise, D-Shaper | Brickwall limiter, gate, de-esser, denoiser, transient shaper |
| `Reverb/` | Reflex 1, Reflex 2, Reflex 3 | Algorithmic reverb suite (plate, room, hall) |
| `Delay/` | D-Delay | Digital delay |
| `Modulation/` | Module-A, Module-B | LFO / modulation processors |
| `Meters & Analysis/` | T-Meter, T-Peak, T-FFT, T-Phase, T-Quiet | LUFS loudness, true-peak, FFT spectrum, phase, silence metering |
| `Generators/` | T-Tone, T-Pink, T-White | Tone, pink and white noise generators |
| `Utility/` | T-Tool | Utility signal tool |

**Community Suites** -- Saike Tools, Sonic Anomaly, tilr, Liteon, LOSER, Stillwell, Schwa, Mawi.

### Themes & Typography

| Theme | Description |
| :--- | :--- |
| ReaFull PT Dark | Pro Tools Dark modern styling (default) |
| ReaFull PT Classic | Classic Pro Tools signature colorway |
| ReaFull Pro | Flagship analog console aesthetic |
| ReaFull Dark | Deep high-contrast studio dark |
| ReaFull Gray | Neutral studio slate |
| ReaFull Light | Clean daylight high-visibility |

**Studio Fonts**: Electrolize, Frozen Crystal, Orbitron, Roboto, Open Sans, Alarm Clock -- installed to `~/.local/share/fonts/ReaFull/` with fontconfig registration.

### Workflow Templates

- **17 Track Template Categories** (200+ strips): Default, Electronic, Drums, Percussion, Bass, Guitars, Keyboards, Brass, Winds, Strings, Vocals, Video Post, Podcasting, FX, Stems, Separators.
- **Genre Project Templates**: AAA Mastering, Rock/Blues/Stoner, Salsa/Latin, Ranchera/Mariachi, Metal/Hard Rock, Jazz, Urban/Electronic, Bolero Cubano.

### StripTease Modular Mixer Strip

Embedded MCP channel strip suite with physical knobs, switches, and real-time Gain Reduction needle VU meters. Includes 12 pre-configured SSL, UAD, Vertigo, and mastering FX chains.

### Pro Tools Mode (ReaTooled)

Pro Tools-style editing workflow: ripple per-track, grid snap, smart tool emulation, PT keymaps.

### Components Reference

| Identifier | Description | Size |
| :--- | :--- | :--- |
| `themes` | ReaFull PT Dark, PT Classic, Pro, Dark, Gray, Light themes | ~15 MB |
| `analog_fx` | ReaFull Analog FX Suite (JSFX) | ~380 MB |
| `digital_fx` | ReaFull Digital FX Suite (JSFX) | ~221 MB |
| `community_fx` | Saike, Sonic Anomaly, tilr, Liteon, LOSER, Stillwell, Schwa, Mawi | ~34 MB |
| `templates` | 17 TrackTemplate categories & genre ProjectTemplates | ~6 MB |
| `sws_autocolor` | SWS AutoColor rules, track icons, data files | ~44 MB |
| `menus_toolbars` | Floating toolbars, screensets, keymaps, mouse modifiers | ~3 MB |
| `scripts` | FTC Tools, HeDa Inspector, Lokasenna GUI, Zaibuyidao, ReaPack repos | ~149 MB |
| `presets` | Factory JSFX presets, FX chains, grooves, note maps | ~11 MB |
| `fonts` | Studio typography (`~/.local/share/fonts/ReaFull/`) | ~1 MB |
| `striptease` | StripTease Modular Mixer Strip Suite | ~5 MB |
| `extensions` | SWS Extension & ReaPack binaries (`UserPlugins/`) | ~6 MB |
| `pro_tools_mode` | Pro Tools Mode keymaps & config (ReaTooled) | ~3 KB |
| `docs` | Resource guide and manual references | < 1 KB |

---

## ReaFull Hub (In-DAW Manager)

The ReaFull Hub is a graphical management console accessible from within REAPER:

- **Doctor & Health**: Live audio driver telemetry (sample rate, buffer, latency, backend detection), SWS/ReaPack extension status, per-component install verification.
- **Modules & Presets**: Interactive component selector with quick presets (ReaTooled, Core, Full, Minimal). Install or update directly from the DAW.
- **Workflow & Themes**: Instant theme switching without REAPER restart. Quick-access toggles for ripple editing, grid snap, and mixer view.
- **System Settings**: Profile integration, autostart configuration, documentation links.

Access via `Actions > Show action list > Scripts > ReaFull_Hub.lua`.

The **ReaFull Updater** (`ReaFull_Updater.lua`) provides background release checking, one-click updates, and ReaPack synchronization.

---

## CLI Reference

```bash
# Basic usage
./install.sh                          # Interactive mode with selector
./install.sh --preset core            # Core studio suite
./install.sh --preset full            # Complete installation
./install.sh --preset reatooled       # Pro Tools workflow (default)

# Profiles
./install.sh --profile overlay        # Non-destructive (default if reaper.ini exists)
./install.sh --profile fresh          # Clean overwrite

# Targets
./install.sh --target native          # ~/.config/REAPER
./install.sh --target flatpak         # ~/.var/app/fm.reaper.Reaper/config/REAPER
./install.sh --target /custom/path    # Custom directory

# Specific components
./install.sh --components themes,analog_fx,fonts

# Advanced
./install.sh --dry-run --preset core  # Simulate without modifying files
./install.sh --quiet                  # Non-interactive (defaults to reatooled)
./install.sh --force                  # Overwrite keyboard shortcuts and menus
./install.sh --no-backup              # Skip pre-install backup
./install.sh --allow-running-reaper   # Install while REAPER is running
./install.sh --assets-dir /path       # Use local assets instead of downloading
./install.sh --log-file /path         # Custom log file location

# Version
./install.sh --version
```

---

## Backup, Restoration & Uninstallation

Every installation creates a timestamped backup:

```
~/.config/REAPER_backup_pre_reafull_YYYYMMDD_HHMMSS
```

```bash
./uninstall.sh
```

Menu options:
1. **Restore Backup** -- Select and restore any timestamped pre-install backup.
2. **Uninstall ReaFull Components** -- Safely remove ReaFull themes, JSFX suites, and studio fonts.
3. **Clean Backups** -- Delete old backups to reclaim disk space.

---

## First 15 Minutes

1. **Launch REAPER** -- The ReaFull PT Dark theme loads automatically.
2. **Screensets**:
   - `F7` -- Edit & Arrangement View
   - `F8` -- Analog Mixing Console View
   - `F9` -- Mastering & Metering Suite
3. **Track Templates**: Right-click track panel > *Insert track from template* > Select from 17 categories.
4. **Console FX**: Open `ReaFull Analog FX` for channel modeling or `ReaFull Digital FX` for surgical processing.
5. **ReaFull Hub**: Open `Scripts/ReaFull/ReaFull_Hub.lua` from the Action List to manage modules, check health, and switch themes.
6. **ReaPack Sync**: Open `Scripts/ReaFull/ReaFull_Updater.lua` for release notifications and package synchronization.

---

## Security & Integrity

- **SHA-256 Hash Pinning**: Every release tarball and extension binary has a pinned SHA-256 hash. Downloads fail closed when no checksum is configured.
- **Path Traversal Protection**: Tar extraction validates all member paths against directory escape attacks.
- **Non-Destructive Overlay**: Existing user configurations are preserved with `.reafull` reference copies.
- **Post-Install Verification**: Automated health check validates POSIX paths, placeholder expansion, theme integrity, and extension presence.
- **CI Quality Gates**: Automated linting for Windows paths, Lua/Python syntax, template validation, license auditing, and dry-run installation tests.

---

## Troubleshooting

**REAPER is running during installation:**
Pass `--allow-running-reaper` or close REAPER first. The installer detects running instances and blocks to prevent config corruption.

**Assets download fails:**
Check your internet connection. You can pre-download the release tarball and pass `--assets-dir /path/to/assets` to use local files.

**Fonts not appearing:**
Run `fc-cache -fv` in your terminal, then restart REAPER or your session.

**Flatpak REAPER not detected:**
Use `--target flatpak` explicitly. The installer auto-detects Native first.

**Installation log:**
Check `~/.config/REAPER/reafull_install_YYYYMMDD_HHMMSS.log` for detailed installation output.

---

## Contributing

Contributions are welcome. Please:

1. Fork the repository and create a feature branch.
2. Follow the existing code style (no emojis in scripts, configs, or Lua/Python/shell files).
3. Run verification before submitting:
   ```bash
   python3 -m py_compile install.py
   python3 scripts/verify_installation.py config_templates
   luac -p assets/Scripts/ReaFull/ReaFull_Hub.lua
   ```
4. Open a pull request with a clear description of changes.

---

## Credits & Attribution

ReaFull is packaged and maintained by **Jules Martins** ([@julesklord](https://github.com/julesklord)).

### Creative Lineage

- **Edu Serra** (*ReArtist Pro*): Original workflow concept, track templates architecture, and analog console layouts (LGPL v3).
- **Cockos Incorporated**: REAPER DAW and the JSFX DSP environment.

### Community Contributors

Tukan Studios (John Matthews), Sonic Anomaly (Stige T.), Justin Johnson (ReEQ/ReEQ), Joep Vanlier (Saike), Tiago LR (tilr), Michael Pilyavskiy (MPL), Raymond Radet (X-Raym), FTC / FeedTheCat (Ilias-Timon Poulakis), Hector Corcin (HeDa), Goran Kovac (Sexan), Lokasenna (Michael Schwerdtfeger), SWS Extension Team, Christian Fillion (cfillion / ReaPack), Eric (ericdevcire / StripTease), Zaibuyidao, Archie.

For complete third-party component catalog, author credits, and license disclosures, see [NOTICE.md](NOTICE.md) and [THIRD_PARTY.md](THIRD_PARTY.md).

---

## License

The ReaFull installation engine, deployment scripts, and configuration templates are licensed under the [MIT License](LICENSE).

Bundled third-party JSFX audio effects, ReaScripts, themes, and fonts retain their original open-source licenses (GPL-3.0, LGPL-3.0, MIT, Apache 2.0, SIL Open Font License). See [THIRD_PARTY.md](THIRD_PARTY.md) for full details.
