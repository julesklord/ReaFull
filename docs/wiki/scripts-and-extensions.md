# ReaScripts, Extensions & Automation Catalog

> **Runtimes**: Lua 5.3+, Python 3.10+, EEL2  
> **Native Extensions**: SWS Extension v2.14.0.7 & ReaPack v1.2.6  
> **Location**: `Scripts/` & `UserPlugins/`

ReaFull integrates an extensive suite of workflow scripts, GUI toolkits, MIDI editing macros, and native Linux extensions to supercharge productivity and session management in REAPER.

---

## Table of Contents

1. [ReaFull Hub & Manager](#1-reafull-hub--manager)
2. [Native Binary Extensions (SWS & ReaPack)](#2-native-binary-extensions-sws--reapack)
3. [Studio Workflow & Inspection Scripts (HeDa, FTC)](#3-studio-workflow--inspection-scripts-heda-ftc)
4. [Community Script Suites (MPL, Sexan, X-Raym, Zaibuyidao, Edu Serra)](#4-community-script-suites)
5. [Automated Mastering & Render Preset Macros](#5-automated-mastering--render-preset-macros)
6. [GUI Frameworks (Lokasenna GUI v2, ReaImGui)](#6-gui-frameworks-lokasenna-gui-v2-reaimgui)

---

## 1. ReaFull Hub & Manager

ReaFull provides built-in Lua tools accessible directly from REAPER's Action List (`?` key):

### 1.1 ReaFull Hub (`Scripts/ReaFull/ReaFull_Hub.lua`)
- **Purpose**: Interactive studio control panel inside REAPER.
- **Features**:
  - Displays currently installed ReaFull modules and version telemetry.
  - One-click access to ReaPack repository synchronization.
  - Links to official offline documentation and release notes.
  - Quick reload of screensets, theme assets, and audio engine diagnostics.

### 1.2 ReaFull Updater / Manager (`Scripts/ReaFull/ReaFull_Updater.lua`)
- **Purpose**: Checks for upstream ReaFull releases and updates.
- **Features**:
  - Automatically queries GitHub API for new version releases.
  - Notifies the user of new features, bug fixes, or asset updates.
  - Triggers non-destructive asset refreshes.

---

## 2. Native Binary Extensions (SWS & ReaPack)

Installed to `~/.config/REAPER/UserPlugins/`:

### 2.1 SWS Extension (`reaper_sws-x86_64.so` / `reaper_sws-aarch64.so`)
- **Version**: `v2.14.0.7` (Official Verified Binary)
- **Key Capabilities**:
  - **SWS AutoColor / AutoIcon**: Dynamically colors tracks and assigns icons based on track naming rules.
  - **SWS Cue Buses**: Automatically creates cue monitor mixes and headphone feeds with independent fader levels.
  - **SWS Loudness Analyzer**: Standalone offline LUFS / RMS / True-Peak batch analyzer.
  - **SWS Cycle Actions**: Macro engine allowing conditional and toggleable chained actions.
  - **SWS Snapshots**: Saves and recalls track mix states, fader levels, and mute/solo matrices.

### 2.2 ReaPack (`reaper_reapack-x86_64.so` / `reaper_reapack-aarch64.so`)
- **Version**: `v1.2.6` (Official Verified Binary)
- **Key Capabilities**:
  - Package manager for REAPER scripts, JSFX, and extensions.
  - Non-destructively pre-configured with ReaFull community repositories:
    * ReaTeam (Scripts, JSFX, Extensions, Themes)
    * MPL Scripts Repository
    * X-Raym Scripts Repository
    * FeedTheCat (FTC) Tools Repository
    * HeDaScripts Repository
    * Saike Tools Repository
    * Sexan Scripts Repository
    * Zaibuyidao MIDI Scripts Repository

---

## 3. Studio Workflow & Inspection Scripts (HeDa, FTC)

### 3.1 HeDa Track Inspector 2 (`Scripts/HeDaScripts/`)
- **Purpose**: Dedicated track analytics and monitoring panel.
- **Key Features**:
  - Live RMS, Peak, and LUFS momentary loudness readout per selected track.
  - Integrated FX Slot Inspector with one-click bypass, freeze, and chain reordering.
  - Track Notes, Color Palette, and Delay compensation readouts.
  - Master Bus monitoring with true peak warnings.

### 3.2 FTC Tools by FeedTheCat (`Scripts/FTC Tools/`)
- **Smart Duplicate**: Context-aware item duplication respecting grid, loop selections, and time signatures.
- **Quick Add FX**: Instant search dialog to insert JSFX, VST, or FX chains via hotkey.
- **Volume Envelope Tools**: Interactive multi-track volume automation and trim fader macros.
- **Arrange View Navigation**: Smooth horizontal and vertical arrange view zooming and track centering.

---

## 4. Community Script Suites

### 4.1 MPL Scripts (by Michael Pilyavskiy)
- Located in `Scripts/MPL Scripts/`:
  - **MPL Mapping Panel**: Unified hardware MIDI controller mapping engine.
  - **MPL Quantize Tool**: Advanced groove quantization with swing extraction.
  - **MPL Send Assistant**: Quick send routing matrix between tracks.
  - **MPL Interactive Toolbar**: Dynamic dockable contextual toolbar.

### 4.2 Sexan Scripts (by Goran Kovac)
- Located in `Scripts/Sexan_Scripts/`:
  - **Auto Routing**: Automatic bus creation and parent folder routing.
  - **Track Exchanger**: Swap track positions and FX chains without breaking existing routing matrices.
  - **Paranoia Auto-Saver**: Intelligent non-intrusive background session backup system.

### 4.3 X-Raym Scripts (by Raymond Radet)
- Located in `Scripts/X-Raym Scripts/`:
  - Advanced item selection tools (select mute, select overlapping, select by color).
  - Region & Marker management tools (batch rename, export timecode, auto-region from items).
  - Color gradient generators for track hierarchies.

### 4.4 Zaibuyidao Scripts (MIDI Automation)
- Located in `Scripts/zaibuyidao Scripts/`:
  - MIDI CC curve scalers, humanizers, and legato smoothers.
  - Articulation and expression management for orchestral sample libraries.
  - Quick chord voicings and strumming delay simulators.

### 4.5 Edu Serra Studio Suite (272 Specialized Scripts)
- Located in `Scripts/Edu Serra Scripts/`:
  - One-click track strip gain staging presets (-18 dBFS calibration).
  - Automatic VCA group assigners.
  - Monitor mix toggles and reference track A/B comparisons.
  - Specialized console fader group linkers.

---

## 5. Automated Mastering & Render Preset Macros

Located at the root of `Scripts/`:

| Script Name | Target Loudness | Output Format | Purpose |
| :--- | :--- | :--- | :--- |
| `Apply render preset - Spotify Master -14 LUFS Integrated.lua` | **-14.0 LUFS** (Peak -1.0 dBTP) | 44.1kHz / 24-bit WAV | Streaming compliance for Spotify, YouTube Music, and Tidal. |
| `Apply render preset - Spotify Master -12 LUFS Integrated.lua` | **-12.0 LUFS** (Peak -1.0 dBTP) | 44.1kHz / 24-bit WAV | Competitive modern pop/rock streaming master. |
| `Apply render preset - Spotify Master -8 LUFS Integrated (LOUD).lua` | **-8.0 LUFS** (Peak -0.3 dBTP) | 44.1kHz / 24-bit WAV | Ultra-loud club, EDM, and modern Trap master. |
| `Apply render preset - CD Master -12 LUFS.lua` | **-12.0 LUFS** | 44.1kHz / 16-bit WAV + Dither | Standard Red Book CD audio mastering. |
| `Apply render preset - CD Master -8 LUFS.lua` | **-8.0 LUFS** | 44.1kHz / 16-bit WAV + Dither | High-energy CD mastering. |
| `Apply render preset - Render Mix for Mastering.lua` | 32-bit Float | 48kHz / 32-bit FP WAV | Pre-master mix export with infinite headroom. |
| `Apply render preset - Render at full speed.lua` | Max CPU Speed | User Defined | Offline multi-threaded bounce. |

---

## 6. GUI Frameworks (Lokasenna GUI v2, ReaImGui)

ReaFull bundles modern script graphical rendering libraries:

- **Lokasenna GUI v2** (`Scripts/Modules/`): Lua object-oriented UI toolkit providing buttons, knobs, sliders, lists, and canvas elements for custom scripts.
- **ReaImGui Integration** (`ReaImGui/`): High-performance GPU-accelerated Dear ImGui bindings for responsive floating analytics tools and mixers.
