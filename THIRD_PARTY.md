# Third-Party Notices and Component Attribution

ReaFull is a modular distribution and configuration framework for Cockos REAPER on Linux, maintained and packaged by **Jules Martins** ([@julesklord](https://github.com/julesklord)).

ReaFull aggregates, integrates, and customizes works created by independent audio engineers, DSP developers, script authors, and typography designers. This document provides a complete and transparent inventory of all third-party components, original authors, copyright notices, and licensing terms.

---

## 1. Summary of Third-Party Works

| Subsystem / Component | Original Creator / Maintainer | Primary License | Upstream Reference |
| :--- | :--- | :--- | :--- |
| **ReArtist Pro Conceptual Design & Skins** | Edu Serra (AM Audio / Edu Serra Pro) | LGPL-3.0 / Freeware | [ReArtist](https://reartist.net) |
| **Analog & Digital JSFX DSP Suite** | John Matthews (Tukan Studios) | GPL-3.0 / Cockos JSFX | [Tukan Studios](https://github.com/TukanStudios) |
| **Sonic Anomaly JSFX Suite** | Stige T. (Sonic Anomaly) | GPL-3.0 / MIT | [Sonic Anomaly](https://github.com/Sonic-Anomaly) |
| **Saike Tools JSFX Suite** | Joep Vanlier (Saike) | GPL-3.0 / BSD | [Saike ReaScripts](https://github.com/JoepVanlier/JSFX) |
| **tilr DSP Utilities** | Tilman (tilr) | MIT / Public Domain | [tilr JSFX](https://github.com/tiagolr) |
| **REEQ / RESpectrum DSP Algorithms** | Justin Johnson (JustinRX) | Cockos JSFX / MIT | [REEQ Forum Thread](https://forum.cockos.com) |
| **REAPER DAW & Native JSFX Standards** | Cockos Incorporated (Justin Frankel, Schwa) | Proprietary / JSFX Open | [Cockos REAPER](https://www.reaper.fm) |
| **FTC Tools (MIDI Magic, Folder Magic, Freeze)** | Ilias-Timon Poulakis (FeedTheCat) | MIT | [FTC ReaPack Repository](https://github.com/ilias-t) |
| **HeDa Track Inspector 2 & Scripts** | Hector Corcin (HeDa) | Freeware / Donationware | [HeDaScripts](https://reaper.hector-corcin.com) |
| **Lokasenna GUI v2 Library** | Michael Schwerdtfeger (Lokasenna) | MIT | [Lokasenna GUI v2](https://github.com/MichaelSchwerdtfeger/Lokasenna_GUI) |
| **MPL ReaScripts Suite** | Michael Pilyavskiy (MPL) | GPL-3.0 | [MPL Scripts](https://github.com/MichaelPilyavskiy/ReaScripts) |
| **X-Raym Scripts & Web Remote** | Raymond Radet (X-Raym) | GPL-3.0 | [X-Raym ReaScripts](https://github.com/X-Raym/REAPER-ReaScripts) |
| **Zaibuyidao MIDI Editing Tools** | Zaibuyidao | MIT / GPL-3.0 | [Zaibuyidao Scripts](https://github.com/zaibuyidao/ReaScripts) |
| **Archie ReaScripts** | Archie | GPL-3.0 | [Archie ReaScripts](https://github.com/Archie317/Archie_ReaScripts) |
| **SWS / S&M Extension** | Tim Giles, Xenakios, Jeffos, Breeder, SWS Team | GPL-2.0+ | [SWS Extension](https://www.sws-extension.org) |
| **ReaPack Package Manager** | Christian Fillion (cfillion) | LGPL-3.0+ | [ReaPack](https://reapack.com) |
| **StripTease Modular Mixer Strip Suite** | Eric (ericdevcire) | Freeware / Open Architecture | [StripTease GitHub](https://github.com/julesklord/StripTease) |
| **Electrolize Typography** | Valery Zaveryaev (Gaslight) | SIL Open Font License 1.1 | [Google Fonts Electrolize](https://fonts.google.com/specimen/Electrolize) |
| **Orbitron Typography** | Matt McInerney | SIL Open Font License 1.1 | [The League of Moveable Type](https://www.theleagueofmoveabletype.com/orbitron) |
| **Roboto Typography** | Christian Robertson (Google) | Apache License 2.0 | [Google Fonts Roboto](https://fonts.google.com/specimen/Roboto) |
| **Open Sans Typography** | Steve Matteson | Apache License 2.0 | [Google Fonts Open Sans](https://fonts.google.com/specimen/Open+Sans) |

---

## 2. Detailed Component Attribution

### 2.1 Conceptual Design, Templates, and Workflow
- **Original Work**: ReArtist Pro 2025 by **Edu Serra** (AM Audio / Edu Serra Pro).
- **Contribution**:
  - Taxonomy and structure of the 17 TrackTemplate categories (`00 Default` to `16 Separators`).
  - Genre-specific project templates (*AAA Mastering, Bolero Cubano, Electronic & Urban, Jazz & Blues, Metal & Hard Rock, Popular & Mexican, Ranchera & Mariachi, Rock - Blues - Stoner, Salsa Song*).
  - Custom graphical skinning, knob layouts, and color palettes applied to the Tukan Studios and Sonic Anomaly JSFX suites.
  - SWS AutoColor & AutoIcon assignment rules.
- **ReaFull Linux Port**: All configuration files, SWS path references, and script triggers were refactored by Jules Martins to support native Linux directory trees and case-sensitive POSIX filesystems without hardcoded Windows drive letters.

---

### 2.2 Digital Signal Processing (JSFX Suites)

#### Tukan Studios (John Matthews)
The foundational DSP code powering the majority of the analog-modeled processing suite originated from **John Matthews (Tukan Studios)**:
- `SolidBus` (based on Tukan Bus Compressor / SSL G-Master style)
- `DisTres-C` / `Distres` (based on Tukan Dis-Tre-So / Empirical Labs Distressor style)
- `Pulse-EQ` (based on Tukan Pultec EQP-1A emulation)
- `Fat-Tape` & `Tape-Dly` (based on Tukan Tape Echo and tape saturation algorithms)
- `FET-76` & `Opto-2A` (based on Tukan 1176 and LA-2A dynamic processors)
- `Vari-Mu` (based on Tukan Variable-Mu tube compressor)
- `Retro-C` (based on Tukan Retro 176 limiter)
- `VCA Comp` (based on Tukan VCA compressor)
- `Mix-Chan`, `Mix-Bus`, `Sum-Desk`, `Sum-Mix`, `Sum-Strip` (console summing and channel strip saturation)
- `Reflex 1`, `Reflex 2`, `Reflex 3` (algorithmic reverb suite)
- `D-DynEQ`, `D-EQ`, `D-Comp`, `D-MSComp`, `D-Limit`, `D-Multi` (digital surgical processing suite)
- `T-FFT`, `T-Meter`, `T-Tone`, `T-Pink`, `T-White`, `T-Phase`, `T-Quiet` (metering and calibration tools)

*License*: Open Source (GPL-3.0 / Cockos JSFX License). John Matthews retains full copyright over the underlying DSP algorithms.

#### Sonic Anomaly (Stige T.)
- `SLAX` (Optical compressor and limiter)
- `QuadraCom` (4-band multiband compressor)
- `Hybrid-C` (Hybrid feedback/feedforward compressor)
- `SEGX2` (Dual-band gate and expander)
- `TriLeveler` / `TriLeveler2` (Broadcast voice leveler)
- `Bass Professor Mark II` (Bass DI and amplifier processor)
- `Leet-D` (Leet Delay)

*License*: GPL-3.0 / MIT. Stige T. retains full copyright over the original DSP code.

#### Saike Tools (Joep Vanlier)
- Granular reverbs (*Particler*), physical modeling synthesis (*Yutani, FM synth*), multiband distortion (*Squashman*), transient designers, spectral shapers, and pitch shifting units (*ToneZilla*).

*License*: GPL-3.0 / BSD. Joep Vanlier retains full copyright over Saike Tools.

#### tilr (Tilman)
- 808 sub-bass synthesizers, pitch delays, sidechain ducking filters, and minimalist monitoring utilities.

*License*: MIT / Public Domain.

#### StevieKeys
- Synthesizer modulation, keyboard channel strips, and MIDI utilities.

*License*: GPL-3.0 / MIT.

#### Scott Stillwell (sstillwell)
- Analog dynamic processors and tone shapers (*1175, Bad Connection, CMX, Dyno, Event Horizon, Fairly Child, Huge Booty, Major Tom*).

*License*: Cockos JSFX Open License / GPL-2.0.

#### Liteon & Michael Loser (LOSER)
- Mathematical DSP processors: *NP1136, Butterworth filters, Stereo Enhancers, 3-Band EQ/Comp, DVC, Master Limiter, Saturation, Zero Crossing*.

*License*: Public Domain / MIT.

#### Cockos Incorporated & Community DSP (IXix, remaincalm_org, Teej, Till, Mawi)
- Core JSFX modules: Floatydelay, MIDI routing matrix, parabolic shapers, and audio analysis meters.

*License*: Cockos JSFX License / BSD / MIT.

---

### 2.3 ReaScripts & Extensions

#### FeedTheCat (Ilias-Timon Poulakis)
- **MIDI Editor Magic**: Contextual auto-zoom, dynamic CC lane resizing, and MIDI velocity curves.
- **Folder Magic**: One-click collapsible track folder management.
- **Smart Freeze**: Intelligent rendering and freezing of multi-track buses with automatic tail detection.
- **Razor Edit Tools**: Advanced slicing, time-stretching, and envelope editing.
- **Lil Chordbox & Adaptive Grid**: Real-time harmonic detection and adaptive timeline snapping.

*License*: MIT License.

#### Hector Corcin (HeDa / HeDaScripts)
- **Track Inspector 2**: Comprehensive track monitoring dock with real-time LUFS integration, signal routing overviews, and tag-based channel filtering.
- **HeDaScripts Manager**: Configuration and package management system for HeDa extensions.

*License*: Free / Donationware. Hector Corcin retains full copyright.

#### Lokasenna (Michael Schwerdtfeger)
- **Lokasenna GUI v2**: Standardized UI framework used across advanced ReaScript interfaces (faders, canvas, buttons, windows, text inputs).

*License*: MIT License.

#### Goran Kovac (Sexan)
- **Pie3000 & ReaSpaghetti**: Radial action menus, modular node routing, and contextual FX management.

*License*: MIT / GPL-3.0.

#### Michael Pilyavskiy (MPL)
- Track alignment scripts, take volume envelopes, FX chain controllers, and interactive routing matrices.

*License*: GNU General Public License v3.0 (GPL-3.0).

#### Raymond Radet (X-Raym)
- Region and marker export utilities (DaVinci Resolve, Premiere EDL), web remote control templates (`reaper_www_root`), and advanced grouping actions.

*License*: GNU General Public License v3.0 (GPL-3.0).

#### Zaibuyidao
- High-performance MIDI editing actions, articulation switching, CC interpolation, and humanization tools.

*License*: MIT / GPL-3.0.

#### Archie & kawa
- Advanced track automation curves, envelope managers, and MIDI utility actions.

*License*: GPL-3.0 / MIT.

#### Community ReaTeam Contributors
- Contributions by *ACendan, Arthur McArthur, BirdBird, EUGENE27771, Lemerchand, me2beats, MonkeyBars, Neutronic, Odedd, Olshalom, Souk21, Stevie, Suzuki, Yannick*.

*License*: MIT / GPL-3.0 / Freeware.

#### SWS Extension Team
- SWS / S&M Extension binary (`reaper_sws-x86_64.so`), cycle action engine, and auto-coloring system.

*License*: GNU General Public License v2.0 or later (GPL-2.0+).

#### Christian Fillion (cfillion)
- ReaPack Package Manager binary (`reaper_reapack-x86_64.so`) and index repository synchronization protocols.

*License*: GNU Lesser General Public License v3.0 or later (LGPL-3.0+).

---

### 2.4 Typography & Fonts

1. **Electrolize**
   - Designer: Gaslight (Valery Zaveryaev)
   - License: SIL Open Font License, Version 1.1 (`OFL.txt`)
2. **Orbitron**
   - Designer: Matt McInerney
   - License: SIL Open Font License, Version 1.1 (`assets/Licences/OFL_Orbitron.txt`)
3. **Roboto**
   - Designer: Christian Robertson (Google)
   - License: Apache License, Version 2.0 (`assets/Licences/Roboto Font LICENSE.txt`)
4. **Open Sans**
   - Designer: Steve Matteson
   - License: Apache License, Version 2.0 / SIL Open Font License 1.1 (`assets/Licences/OFL_Open Sans.txt`)
5. **Frozen Crystal**
   - Designer: Ray Larabie (Typodermic Fonts)
   - License: Freeware Desktop Font License
6. **Alarm Clock**
   - Designer: David J. Patterson
   - License: 100% Free Font License

---

## 3. ReaFull Packaging and License Scope

- The **ReaFull installer engine** (`install.py`, `install.sh`, `uninstall.sh`, `scripts/*.py`) and specific Linux path translation layers developed by Jules Martins are licensed under the **MIT License** (see `LICENSE`).
- All bundled third-party JSFX DSP code, ReaScripts, fonts, and extensions remain under their respective original upstream licenses. Nothing in the ReaFull distribution is intended to override or restrict the rights granted by those original licenses.
