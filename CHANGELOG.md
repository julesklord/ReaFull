# Changelog

All notable changes to **ReaFull** are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and this project follows [Semantic Versioning](https://semver.org/).

---

## [2026.2.0] - 2026-08-18

### Added
- **StripTease Modular Channel Strip Engine**:
  - Embedded MCP channel strip suite with physical knobs, switches, and real-time Gain Reduction needle VU meters.
  - Background system script `StripTease System.lua` for Direct Link parameter binding, palette syncing, and preset management.
  - 12 pre-configured SSL, UAD, Vertigo, and mastering `.RfxChain` files.
  - Registered upstream repository in `reapack.ini` for continuous updates.
- **In-DAW Auto-Update Engine (`ReaFull_Updater.lua` & `__startup.lua`)**:
  - Background non-blocking 24h release check via GitHub API.
  - One-click safe update and backup application from within REAPER.
- **Automated Native Extension Retrieval & Zero-Friction Python**:
  - Auto-retrieval of SWS Extension and ReaPack Linux x86_64 binaries directly to `UserPlugins/`.
  - Auto-configuration of `libpython3` in `reaper.ini` for seamless ReaScript Python integration.
  - Multi-distribution package detection helper in `install.sh`.
- **Core Suite Profile (`--preset core`)**:
  - Standalone core studio profile under 700MB (~668MB), optimizing initial download and deployment.
  - Interactive selector menu command `k` / `core` for instant selection.
- **Enhanced Safe Overlay Protection**:
  - Non-destructive protection extended across all user `.ini` configurations (`sws-autocoloricon.ini`, `S&M.ini`, `reaper-extstate.ini`, `reaper-fxfolders.ini`, `reaper-defpresets.ini`, etc.).
  - Preserves user custom settings and creates `.reafull` reference copies.
- **Target Aliases & Resolution**:
  - Added support for `--target native` and `--target flatpak`.
- **Config Templates Validation Mode**:
  - Added template directory sanity gate to `scripts/verify_installation.py` (`--templates`).
- **Comprehensive Legal Disclosures**:
  - Exhaustive updates to `NOTICE.md` and `THIRD_PARTY.md` covering all community DSP suites, ReaTeam scripts, and font licenses.

### Changed
- **CI Test Pipeline**:
  - Added automated steps for templates verification, dry-run simulation, real core deployment, and overlay non-destructive testing.
- **Installer Wrapper (`install.sh`)**:
  - Fixed TTY reconnection in non-interactive / CI / piped environments.

---

## [2026.1.0] - 2026-08-17

### Added
- **Non-Destructive Installation Profile (`--profile overlay`)**:
  - Preserves intact user keyboard shortcuts (`reaper-kb.ini`), mouse modifiers (`reaper-mouse.ini`), and existing menus.
  - Smart merge of ReaPack repositories (`reapack.ini`), adding community repositories without deleting existing user ones.
- **ReaFull Analog FX & Digital FX Suite (JSFX)**:
  - Full analog console: `SolidBus`, `DisTres-C`, `Pulse-EQ`, `Fat-Tape`, `FET-76`, `Opto-2A`, `Vari-Mu`, `Tube-Pre`, `Sum-Desk`.
  - Surgical digital tools: `D-DynEQ`, `D-EQ`, `D-Comp`, `D-MSComp`, `D-Limit`, `D-Meter` (LUFS EBU R128), `T-FFT`.
- **Health Verification Engine (`scripts/verify_installation.py`)**:
  - Automated post-installation check of POSIX paths, themes, plugins, templates, and fonts.
- **Uninstaller & Backup Manager (`uninstall.sh`)**:
  - Automatic support for Native and Flatpak REAPER.
  - Menu to restore previous backups, uninstall ReaFull components, or purge old backups.
- **Legal Framework & Attributions**:
  - `NOTICE.md` and `THIRD_PARTY.md` with exhaustive license breakdown (MIT, GPL-3.0, LGPL-3.0, Apache 2.0, SIL OFL).
- **Continuous Integration (CI)**:
  - GitHub Actions workflow (`.github/workflows/ci.yml`) for path linting, syntax compilation, and automated installation tests.

### Changed
- **Full Template Sanitization**:
  - Removed all absolute Windows paths (`C:\`, `J:\`, `F:\`, etc.), recent projects, and personal session data from `config_templates/`.
  - Normalized all path separators to `/`.
- **Repository Optimization**:
  - Removed duplicate JSFX and ReArtist theme tree, reducing asset size from 2.1 GB to ~858 MB.
  - Removed redundant `Data/Grooves/` copy.
- **ReaFull Manager In-DAW (`ReaFull_Updater.lua`)**:
  - Disabled blind background runs without backup. Safe interface to query GitHub releases, sync ReaPack, and reload views.
- **Startup Script (`assets/Scripts/__startup.lua`)**:
  - Configurable toggles for auxiliary tools (`ENABLE_ADAPTIVE_GRID`, `ENABLE_LIL_CHORDBOX`, `ENABLE_GRIDBOX`).

### Removed
- Unnecessary Windows binaries (`7za.exe`, `curl.exe`, Windows `ogler.clap` DLL).
- Debug session logs (`HeDaScripts Manager.log`) and ReaImGui window `.ini` caches.
- Cockos copyrighted manuals, replaced with links to official online documentation.
