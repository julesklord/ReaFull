# ReaFull

A modular, production-grade digital audio workstation distribution and configuration framework for Cockos REAPER on Linux.

---

## 1. Overview

ReaFull is a fully automated, native Linux workstation environment for REAPER. It provides a standardized production, mixing, and mastering ecosystem featuring analog-modeled JSFX DSP suites, ergonomic workflow layouts, track and project templates, automated typography configuration, and intelligent audio engine tuning.

### Key Architecture Principles
- **Linux Native Path Sanitization**: All legacy Windows path formats (`C:\...`), reverse backslashes, user-specific directories, and dead plugin pointers have been eradicated and converted to dynamic POSIX environment standards.
- **Modular Component Installation**: Every subsystem (plugins, themes, templates, scripts, presets, fonts, audio tuning) can be selected independently via an interactive terminal interface or CLI flags.
- **Non-Destructive Configuration Merging**: Preserves existing hardware input/output assignments, ALSA/JACK/PipeWire routing, MIDI device mappings, licenses, and recent project history.
- **Automated Logging and Size Calculation**: Transparent real-time calculation of disk requirements and generation of detailed audit logs for every deployment.

---

## 2. Included Subsystems and Component Breakdown

### 2.1 Audio Processing Suites (JSFX)

#### ReaFull Analog FX Suite
Analog hardware emulations with custom graphical interfaces and factory presets:
- **SolidBus**: Classic British console VCA master bus compressor with variable auto-release and high-pass sidechain filtering.
- **DisTres-C / Distres**: Non-linear knee compressor emulation with selectable opto response curves, second/third harmonic distortion injection, and detector filtering.
- **Pulse-EQ**: Passive tube program equalizer based on classic Pultec topologies, featuring simultaneous low-frequency boost/attenuation and high-frequency band selection.
- **FET-76**: Ultra-fast FET peak limiter emulation with selectable ratio configurations (4:1, 8:1, 12:1, 20:1, and all-buttons mode).
- **Opto-2A**: Electro-optical attenuator emulation with frequency-dependent release dynamics and program-dependent leveling.
- **Vari-Mu**: Variable-mu vacuum tube compressor designed for glue compression and transparent dynamic control on complex stereo program material.
- **Retro-C**: Tube limiting amplifier modeled after vintage variable-gain audio levelers.
- **VCA Comp**: Hard-knee VCA dynamic processor providing punch and fast transient control for percussive sources.
- **Fat-Tape**: Analog magnetic tape recorder simulation with adjustable tape speed, bias level, saturation curve, and low-frequency head-bump resonance.
- **Tape-Dly**: Warm bucket-brigade and magnetic tape echo unit with flutter modulation and feedback filtering.
- **Tube-Pre**: Triode/pentode vacuum tube preamplifier simulation with harmonic saturation and drive control.
- **Mix-Chan / Mix-Bus / Sum-Desk / Sum-Strip**: Analog console channel and bus summing modules providing non-linear crosstalk, console saturation, and harmonic coloration.
- **ST-Bass / ST-Guitar**: Dedicated multi-stage analog channel processors tailored for direct-input bass and electric guitars.
- **VU Zeno / VU-TK**: Calibrated ballistic needle VU meters conforming to ANSI C16.5 standards (0 VU = -18 dBFS reference).

#### ReaFull Digital FX Suite
Precision digital processors designed for surgical mixing and mastering:
- **D-DynEQ**: Multi-band dynamic parametric equalizer offering threshold, ratio, attack, and release per band.
- **D-EQ**: High-precision minimum-phase parametric equalizer with clean filter responses and customizable Q factors.
- **D-Comp**: Transparent digital compressor with adjustable knee, feed-forward detection, and zero harmonic distortion.
- **D-MSComp**: Dedicated Mid/Side matrix compressor for independent dynamic control of mono sum and stereo difference information.
- **D-Limit**: Mastering true-peak brickwall limiter with inter-sample peak detection and lookahead buffers.
- **D-Multi**: Multiband dynamic processor with linear-phase crossover filters.
- **Reflex 1, Reflex 2, Reflex 3**: Algorithmic studio reverb suite delivering plate, room, and large hall simulations with diffusion, early reflection control, and damping filters.
- **D-Meter**: Comprehensive loudness analyzer complying with ITU-R BS.1770-4 / EBU R128 standards, displaying Integrated LUFS, Short-Term LUFS, Momentary LUFS, True Peak, and RMS levels.
- **T-FFT**: Real-time high-resolution Fast Fourier Transform spectrum visualizer with peak hold, smoothing, and slope tilt adjustments.
- **Calibration Suite (T-Tone, T-Pink, T-White, T-Phase, T-Quiet)**: Reference signal generators for room tuning, gain staging, and monitor alignment.

#### Integrated Community Processing Suites
Pre-configured and indexed selections from leading open-source DSP developers:
- **Saike Tools**: Advanced physical modeling synthesis, multi-band saturation, spectral shaping, and diffusion reverbs.
- **Sonic Anomaly**: SLAX, QuadraCom, Hybrid-C, SEGX2, and TriLeveler leveling tools.
- **tilr**: Minimalist modern mixing utilities.
- **Liteon, LOSER, Stillwell, Schwa, Mawi**: Essential mathematical algorithms for filtering, spatial enhancement, and dynamics.

---

### 2.2 Themes and Typography

- **ReaFull Pro**: Flagship dark console theme optimized for low eye fatigue, high-contrast channel metering, and clean docker layouts.
- **ReaFull Dark**: Minimalist ultra-dark theme for nighttime production sessions.
- **ReaFull Gray**: Balanced neutral theme modeled after modern hardware consoles.
- **ReaFull Light**: High-contrast theme engineered for daylight environments.
- **Typography Engine**: Automated deployment and fontconfig registration of studio fonts (*Electrolize, Frozen Crystal, Orbitron, Roboto, OpenSans, Alarm Clock*) into `~/.local/share/fonts/ReaFull/`.
- **HiDPI Asset Support**: Fully scalable 100%, 150%, and 200% toolbar icons and custom track status indicators.

---

### 2.3 Workflow, Track, and Project Templates

#### Track Templates (17 Categorized Modules)
Pre-routed channel strips containing input routing, initial gain staging, coloring, and processing chains:
1. `00 Default` (Audio Inputs, Auxiliaries, Sub-Buses, MixBus, Monitoring/Phones)
2. `01 Electronic` (Synths, Basslines, Samplers, Sequences)
3. `02 Drums` (Kick In/Out, Snare Top/Bottom, Hi-Hat, Toms, Overheads, Room)
4. `03 Percussion` (Latin, Acoustic, Shakers, Congas, Bongos, Claves)
5. `04 Bass` (DI, Amp, Sub-Bass, Slap, Synth Bass)
6. `05 AC Guitars` (Direct, Mic Left/Right, Stereo Arrays)
7. `06 EL Guitars` (Clean, Rhythm, Crunch, Lead, Re-Amp)
8. `07 Keyboards & Synths` (Acoustic Piano, Electric Piano, Organ, Pads, Leads)
9. `08 Brass` (Trumpet, Trombone, Saxophones, Section Bus)
10. `09 Winds` (Flute, Clarinet, Oboe, Section Bus)
11. `10 Strings` (Violins, Violas, Cellos, Double Bass, Full Ensemble)
12. `11 Vocals` (Lead Vocal, Backing Vocals, Harmonies, Doubles, Vox Bus)
13. `12 Video Post` (Dialog, Foley, Sound Effects, Ambience, Music Stems)
14. `13 Podcasting` (Host, Guest 1-4, Soundboard, Master Leveler)
15. `14 FX Reverbs & Delays` (Short Spaces, Medium Plates, Long Halls, Stereo Delays)
16. `15 Stems` (Pre-configured stem export buses)
17. `16 Separators` (Visual divider tracks for project organization)

#### Project Templates
Pre-configured full-session templates with routing, buses, VCAs, and master chains for:
- AAA Mastering
- Rock, Blues, and Stoner
- Salsa and Latin Production
- Ranchera and Mariachi
- Popular and Mexican Styles
- Metal and Hard Rock
- Jazz and Blues
- Electronic and Urban
- Bolero Cubano

---

### 2.4 Automation, Scripts, and SWS Integration

- **SWS AutoColor & Icons**: 310+ rules for automated coloring and icon assignment based on track naming conventions.
- **FTC Tools (FeedTheCat)**: MIDI Editor Magic, Folder Magic, Smart Freeze, Razor Edits, and Quick Render.
- **HeDa Track Inspector 2**: Comprehensive track information, integrated metering, LUFS readouts, and FX navigation.
- **Lokasenna GUI v2**: Standardized script interface framework with Linux path resolution.
- **Zaibuyidao Tools**: Advanced MIDI manipulation, humanization, CC curve tools, and batch editors.
- **In-DAW ReaFull Updater**: ReaScript utility located at `Scripts/ReaFull/ReaFull_Updater.lua` for checking GitHub releases, triggering ReaPack synchronization, and reloading theme assets.

---

## 3. Installation

### 3.1 Requirements
- Cockos REAPER (Native Linux or Flatpak)
- Python 3.8+
- Bash
- Fontconfig (`fc-cache`)
- `curl`
- Recommended: SWS Extension and ReaPack

### 3.2 Interactive Installation

To launch the interactive terminal interface:

```bash
git clone https://github.com/julesklord/ReaFull.git
cd ReaFull
./install.sh
```

In the interactive menu:
- Enter numbers to toggle components on/off.
- Press `a` to select all components.
- Press `m` for minimal profile (Themes, Fonts, Shortcuts, Audio Tuning).
- Press `f` for audio plugins profile (Analog FX, Digital FX, Community FX, Presets).
- Press `Enter` to proceed.

---

## 4. Command Line Interface Reference

The installer can run non-interactively for automated deployments:

```bash
# Apply a predefined profile
./install.sh --preset full         # Complete deployment (~1.5 GB)
./install.sh --preset minimal      # Essential UI, fonts, and audio tuning (~20 MB)
./install.sh --preset fx-only      # JSFX plugin suites and presets (~1.2 GB)
./install.sh --preset themes-only  # Themes and icons only (~20 MB)

# Select specific components by ID
./install.sh --components themes,analog_fx,digital_fx,audio_tuning

# Perform a dry-run (simulation without modifying files)
./install.sh --dry-run --preset full

# Specify a custom REAPER directory (e.g., Flatpak)
./install.sh --target ~/.var/app/fm.reaper.Reaper/config/REAPER

# Non-interactive silent installation
./install.sh --quiet --no-backup
```

### Component Identifier Table

| Identifier | Description | Disk Size |
| :--- | :--- | :--- |
| `themes` | ReaFull Pro, Dark, Gray, Light Themes and Splash screen | ~15 MB |
| `analog_fx` | ReaFull Analog FX Suite (JSFX) | ~380 MB |
| `digital_fx` | ReaFull Digital FX Suite (JSFX) | ~220 MB |
| `community_fx` | Saike, Sonic Anomaly, Tilr, Liteon, Stillwell Suites | ~65 MB |
| `templates` | 17 TrackTemplate categories and ProjectTemplates | ~6.5 MB |
| `sws_autocolor` | SWS AutoColor rules, track icons, toolbar icons, ReaImGui | ~49 MB |
| `menus_toolbars` | Menu sets, floating toolbars, screensets, keymaps | ~4.3 MB |
| `scripts` | FTC Tools, HeDa, Lokasenna GUI v2, Zaibuyidao, ReaPack | ~156 MB |
| `presets` | Factory JSFX presets, FX chains, MIDI note maps | ~12 MB |
| `fonts` | Studio typography installed to `~/.local/share/fonts/ReaFull/` | ~1.1 MB |
| `audio_tuning` | Professional Linux audio engine configuration | 0 B |
| `docs` | REAPER User Guide and technical documentation PDF | ~29 MB |

---

## 5. Linux Audio Engine Tuning Specifications

When the `audio_tuning` component is active, the installer assesses the host environment and applies optimal parameters for low-latency, stable operation on Linux:

- **ALSA Hardware Direct Access**: Directly addresses physical sound cards (e.g., `hw:U192k` for Behringer UMC404HD) to avoid intermediate software layer latency.
- **Kernel Realtime Priority (`alsa_rtprio=90`)**: Assigns high realtime scheduling priority to the audio processing thread.
- **RAM Locking (`linux_mlockall=1`)**: Locks audio process memory pages in physical RAM, eliminating kernel page swaps during playback or recording.
- **Power Management Isolation (`linux_disable_pm=1`)**: Disables CPU core power-saving C-state transitions on active audio threads.
- **Audio Server Suspension (`linux_auto_pasuspend=1`)**: Automatically pauses background desktop audio servers (PulseAudio/PipeWire) during direct ALSA device access.
- **Mastering-Grade Resampling**: Configures real-time playback interpolation to `r8brain free / 512pt Sinc` and offline export to `r8brain / 768pt Sinc`.
- **Anticipative FX Processing (`afx=1`, `afxb=200`)**: Distributes plugin loads across all available CPU threads with a 200 ms anticipative buffer.
- **Monitor Protection (`audio_mute=1`, `audio_mute_db=18.0`)**: Automatically mutes the master output if positive feedback loops exceed +18 dBFS.

---

## 6. Backup and Recovery

Every installation run automatically creates a timestamped backup of the target REAPER configuration directory:

```text
~/.config/REAPER_backup_pre_reafull_YYYYMMDD_HHMMSS
```

To restore a previous configuration:
```bash
./uninstall.sh
```
The restoration utility will display an indexed list of available backups and restore the selected configuration upon user confirmation.

---

## 7. Credits and Attributions

ReaFull is packaged, maintained, and adapted for Linux by **Jules Martins** ([@julesklord](https://github.com/julesklord)).

### Original Work and Acknowledgments
- **Edu Serra** (*ReArtist Pro*): Original conceptual design, workflow structure, and custom JSFX DSP algorithms.
- **Cockos**: For REAPER and the JSFX development framework.
- **Community Developers**:
  - **FeedTheCat (FTC)**: MIDI Editor Magic, Folder Magic, Smart Freeze, Razor Edits.
  - **HeDa**: Track Inspector 2, HeDaScripts Manager.
  - **Lokasenna**: Lokasenna GUI v2 framework.
  - **Michael Pilyavskiy (MPL)**, **X-Raym**, **Archie**, **Zaibuyidao**, **Saike**, **Sonic Anomaly**, **tilr**, and **StevieKeys**.
- **SWS Extension Team** and **Christian Fillion (cfillion / ReaPack)**.

---

## 8. License

The ReaFull installation framework, configuration templates, and maintenance tooling are licensed under the [MIT License](LICENSE).  
Bundled JSFX plugins, ReaScripts, and third-party tools retain their original respective open-source licenses (MIT, GPL, Cockos, and Author-attributed).
