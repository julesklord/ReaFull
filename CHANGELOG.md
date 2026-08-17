# Changelog

All notable changes to **ReaFull** are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and this project follows [Semantic Versioning](https://semver.org/).

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
