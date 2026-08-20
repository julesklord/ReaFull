# ReaFull System Architecture & Architecture Decision Records (ADRs)

> **Version**: `v2026.3.0`  
> **Status**: Approved  
> **Maintainer**: Jules Martins (`fearlesslymediagroup@gmail.com`)

This document defines the architectural components, configuration merge mechanics, asset delivery engine, and technical decisions governing ReaFull.

---

## 1. Architectural System Overview

ReaFull operates as a modular abstraction and deployment layer over Cockos REAPER on POSIX Linux environments. It bridges raw Linux audio subsystems (PipeWire / ALSA / JACK) with a fully configured studio console environment.

```
ReaFull Ecosystem
├── Deployment Core
│   ├── install.sh                  ← Shell bootstrap wrapper (TTY reconnect, deps verification)
│   ├── install.py                  ← Modular orchestration engine, INI merger, hardware tuner
│   └── uninstall.sh                ← Interactive backup restoration & component removal utility
├── Configuration Templates
│   ├── config_templates/*.template.ini ← Dynamic templates with {{REAPER_CONFIG_DIR}} expansion
│   └── config_templates/*.ini          ← Static configuration profiles
├── Asset Pipeline
│   ├── assets/ColorThemes/         ← ReaFull Pro, Dark, Gray, Light Themes & Splash
│   ├── assets/Effects/             ← JSFX Suites (Analog FX, Digital FX, Community FX)
│   ├── assets/TrackTemplates/      ← 17 Categorized Studio Strip Modules (200+ strips)
│   ├── assets/ProjectTemplates/    ← Genre-specific session templates
│   ├── assets/Fonts/               ← Studio typography for Linux fontconfig
│   ├── assets/Data/                ← SWS AutoColor rules, track icons, HiDPI toolbar icons
│   └── assets/Scripts/             ← StripTease, FTC, HeDa, Lokasenna, ReaFull Hub/Updater
└── Verification & Health Gate
    └── scripts/verify_installation.py ← Path auditor, placeholder verifier, syntax validator
```

---

## 2. Core Architectural Subsystems

### 2.1 Dynamic Template Variable Expansion Engine

REAPER configuration files frequently require absolute filesystem paths for splash screens, script definitions, track templates, and color theme archives.

To maintain cross-environment compatibility across Native (`~/.config/REAPER`), Flatpak (`~/.var/app/fm.reaper.Reaper/config/REAPER`), and custom directories, ReaFull employs a dynamic template engine:

- Templates with dynamic requirements use the `.template.ini` suffix (e.g. `reaper.template.ini`, `S&M.template.ini`, `reaper-extstate.template.ini`).
- The placeholder `{{REAPER_CONFIG_DIR}}` is evaluated at runtime during installation and replaced with the resolved absolute target directory path.
- Static `.ini` files (without variable dependencies) are deployed directly or merged without string replacement.
- Post-install health verification enforces zero unexpanded `{{...}}` tokens in the target directory.

### 2.2 Multi-Pass Configuration Merge Engine

When deploying over an existing REAPER installation (`Overlay` profile), ReaFull prevents destructive data loss by executing a multi-pass merge:

1. **Safety Keys Extraction**: Existing project paths, render patterns, recent files, audio hardware assignments, and window dimensions are parsed and protected.
2. **Dynamic Template Evaluation**: The ReaFull baseline configuration is rendered with the target path.
3. **Key Merging**: ReaFull introduces studio defaults while preserving user-defined hardware IDs (`alsa_indev`, `alsa_outdev`), window geometries, and custom options unless `--force` is invoked.
4. **ReaPack Remote Merging**: Existing user ReaPack repositories (`reapack.ini`) are parsed; new ReaFull repositories are appended incrementally without reordering or wiping existing remotes.
5. **Conflict Protection**: Existing user files (`reaper-kb.ini`, `reaper-menu.ini`, `reaper-mouse.ini`) are preserved in place; the ReaFull equivalents are saved with a `.reafull` extension for optional manual reference.

### 2.3 Remote Asset Delivery & Cryptographic Verification

To keep the core Git repository lightweight, large audio assets (audio plugins, themes, sample icons, track templates) can be fetched on demand via GitHub Releases:

- **Integrity Validation**: Downloaded tarballs and binary extensions (SWS, ReaPack) are hashed in memory via `hashlib.sha256()` and verified against `KNOWN_HASHES` dictionary tables.
- **Safe Extraction**: The `safe_extract_tar()` engine validates tar member paths, preventing directory traversal attacks (`../`), absolute paths, and symlink escapes outside the target destination.

---

## 3. Architecture Decision Records (ADRs)

### ADR 0001: Non-Destructive INI Overlay vs Destructive Overwrite

- **Status**: Accepted
- **Date**: 2026-08-10

#### Context
Audio engineers invest months customizing key shortcuts, mouse modifiers, custom toolbars, and project paths. Standard theme/config packages frequently overwrite the entire REAPER directory, causing catastrophic loss of personalized workflows.

#### Decision
ReaFull defaults to an `Overlay` profile:
1. Parse existing user configurations.
2. Preserve user-specific keys (`reaper-kb.ini`, `reaper-mouse.ini`, custom menus, project histories).
3. Merge ReaPack remotes non-destructively.
4. Provide a `--profile fresh` flag only for users desiring a clean factory slate.

#### Consequences
- **Positive**: Zero risk of workflow disruption for existing REAPER users; seamless trial experience.
- **Negative**: Requires complex multi-pass INI parsing and fallback `.reafull` conflict staging.

---

### ADR 0002: Remote Release CDN Asset Delivery with SHA-256 Checksums

- **Status**: Accepted
- **Date**: 2026-08-12

#### Context
Full studio suites with hundreds of JSFX plugins, high-resolution textures, and audio templates exceed 800 MB. Storing binary assets directly in Git bloats repository clone times and causes performance degradation.

#### Decision
Host large asset packages (`reafull-assets-v*.tar.gz`) on GitHub Releases CDN. The installer downloads assets to `~/.cache/reafull/`, verifies their SHA-256 checksums, and safely unpacks them.

#### Consequences
- **Positive**: Git repository remains sub-megabyte in size; fast clones; versioned asset caching.
- **Negative**: Requires internet connectivity on first install if local assets are omitted.

---

### ADR 0003: POSIX Sanitization & Flatpak Sandbox Path Normalization

- **Status**: Accepted
- **Date**: 2026-08-15

#### Context
Configurations originating from Windows installations frequently contain invalid drive letters (`C:\...`, `D:\...`) and backslash separators. Furthermore, Flatpak REAPER installations live inside isolated sandbox paths (`~/.var/app/fm.reaper.Reaper/config/REAPER`).

#### Decision
1. Sanitize all configuration templates to use standard relative POSIX paths.
2. Implement automated detection for Native (`~/.config/REAPER`) and Flatpak paths with `--target native|flatpak|<path>` CLI overrides.
3. Automatically configure font installations to `~/.local/share/fonts/ReaFull/` with `fc-cache` execution.

#### Consequences
- **Positive**: Universal compatibility across all Linux distributions (Arch, Ubuntu/Debian, Fedora, openSUSE) and installation methods.
- **Negative**: Must detect environment sandboxing for font registration and binary plugin loading.

---

### ADR 0004: Intelligent ReaPack Remote Merging

- **Status**: Accepted
- **Date**: 2026-08-16

#### Context
ReaPack manages third-party extension packages via `reapack.ini`. Overwriting `reapack.ini` deletes custom repositories added by the user (ReaTeam, MPL, Sexan, etc.), while not updating it prevents ReaFull community scripts from receiving updates.

#### Decision
Implement `merge_reapack_ini()` to parse `[remotes]`, extract existing repository URLs, filter out duplicates, and append ReaFull remotes incrementally while updating the `size=N` header.

#### Consequences
- **Positive**: All user repositories remain intact while ReaFull repositories are seamlessly activated.
- **Negative**: Custom parser required to handle INI formatting quirks in ReaPack's remote index.

---

### ADR 0005: Low-Latency Linux Audio Tuning & Hardware Heuristics

- **Status**: Accepted
- **Date**: 2026-08-17

#### Context
Linux audio performance depends heavily on thread scheduling, realtime priorities, buffer configurations, and memory locking (`mlockall`). Without optimized defaults, users experience buffer underruns (xruns) and audio dropouts.

#### Decision
Automate optimal audio engine parameters in `reaper.ini`:
1. Query system CPU cores to configure `workthreads = CPU_COUNT`.
2. Enable `linux_mlockall = 1` (lock audio buffers in physical RAM to prevent swap paging jitter).
3. Set `alsa_rtprio = 90` and `linux_disable_pm = 1` (disable power management throttling during playback).
4. Set default playback and render resampling to high-precision Sinc algorithms (`playresamplemode = 5`, `projrenderresample = 6`).
5. Detect connected hardware interfaces (e.g. Behringer UMC404HD 192k, Presonus AudioBox) to tune block size (`linux_audio_bsize = 256`), buffer count (`3`), and channel counts.

#### Consequences
- **Positive**: Out-of-the-box low-latency, glitch-free audio processing without manual kernel tuning.
- **Negative**: User must have standard `@audio` realtime permissions configured in `/etc/security/limits.d/` for optimal RT priority scheduling.
