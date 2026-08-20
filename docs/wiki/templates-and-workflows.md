# Studio Templates, Workflows, Themes & Screensets

> **Components**: TrackTemplates (200+ Strips) · ProjectTemplates (8 Genres) · Screensets (`F7-F9`) · Themes · SWS AutoColor

This guide details the workflow architecture, session templates, theme variants, and navigation ergonomics built into ReaFull.

---

## 1. Categorized Track Templates (17 Modules / 200+ Strips)

ReaFull organizes track templates into 17 numbered categories accessible via Right-Click on Track Panel → *Insert track from template*. Each template includes pre-configured gain staging, SWS auto-coloring, track icons, and FX chains.

```
TrackTemplates/
├── 00 Default/            ← Routing Buses, Aux Sends, MixBus, Monitoring/Headphones
├── 01 Electronic/         ← 808s, Sub Bass, Sidechain Triggers, Arpeggiators, Synth Leads
├── 02 Drums/              ← Kick In/Out/Sub, Snare Top/Bottom, HiHat, Toms, Overheads, Room
├── 03 Percussion/         ← Congas, Bongos, Timbales, Shakers, Tambourines, Claps
├── 04 Bass/               ← DI Bass, Amp Bass, Sub Bass, Upright Bass, Synth Bass
├── 05 AC Guitars/         ← Acoustic Guitars (Stereo Pair, Mic+DI, 12-String, Nylon)
├── 06 EL Guitars/         ← Electric Clean, Rhythm Crunch, Lead High-Gain, DIs
├── 07 Keyboards & Synths/ ← Grand Piano, Rhodes, Wurlitzer, B3 Organ, Analog Synths
├── 08 Brass/              ← Trumpets, Trombones, French Horns, Tuba, Brass Section Bus
├── 09 Winds/              ← Flute, Clarinet, Oboe, Saxophones (Soprano, Alto, Tenor, Baritone)
├── 10 Strings/            ← Violins I/II, Violas, Cellos, Double Bass, Full String Ensemble
├── 11 Vocals/             ← Lead Vocal, Doubles, Harmonies, Ad-libs, Vocal FX, Talkback
├── 12 Video Post/         ← Dialogue, Foley, Sound Effects (SFX), Ambience / Room Tone
├── 13 Podcasting/         ← Host 1-4, Guest (Remote/VoIP), Jingle Bus, Master Limiter
├── 14 FX Reverbs & Delays/← Short Room, Vocal Plate, Drum Chamber, Slapback, Ping-Pong Delay
├── 15 Stems/              ← Print Tracks for Drums, Bass, Guitars, Keys, Vocals, Master Mix
└── 16 Separators/         ← Color-coded visual spacer tracks for clean session organization
```

---

## 2. Genre-Tailored Project Templates

Accessible via *File → Project templates*, these complete session templates include calibrated buses, FX sends, VCA folders, and master bus processing for specific musical styles:

| Project Template | Workflow & Routing Architecture | Master Bus Chain |
| :--- | :--- | :--- |
| **AAA Mastering Suite** | Mid/Side monitoring, Reference track A/B switching, EBU R128 Loudness radar, True Peak limiter. | D-DynEQ → Pulse-EQ → Vari-Mu → D-Limit → D-Meter |
| **Rock / Stoner / Blues** | Parallel drum crush bus, dual-mic guitar buses, analog tape saturation on bass and master. | SolidBus (4:1) → Fat-Tape (15 IPS) → Pulse-EQ |
| **Salsa / Latin Orchestra** | High-transient percussion routing (Timbal, Conga, Bongo), horn section summing bus, bright vocal chains. | Mix-Bus → SolidBus → D-EQ → D-Limit |
| **Ranchera / Mariachi** | Guitarrón & Vihuela dedicated bus, trumpet dynamic tamers, wide stereo acoustic strings. | Vari-Mu → Pulse-EQ → D-Limit |
| **Metal / Hard Rock** | Fast FET-76 sidechained kick/bass, aggressive high-gain guitar grouping, parallel drum nuke. | FET-76 (All-Buttons) → SolidBus → D-Limit |
| **Jazz Ensemble** | Transparent acoustic dynamics, natural room reverb sends, minimal bus compression. | Opto-2A → D-DynEQ → D-Meter |
| **Urban / Trap / Electronic** | 808 sidechain ducking, pitch-bent vocal buses, aggressive clip saturation. | D-Multi → Fat-Tape → D-Limit |
| **Bolero Cubano** | Warm tube preamp emulation on lead vocal, acoustic nylon guitar clarity, lush plate reverbs. | Tube-Pre → Opto-2A → Reflex Plate |

---

## 3. Screensets & Ergonomic Studio Workspaces

ReaFull assigns dedicated functional screensets to standard function keys for instant workflow transitions:

```
[F7] ARRANGEMENT / EDITING
├── Full-width Track Arrangement View
├── Bottom Floating Docker (Media Explorer / Actions)
└── Compact Track Control Panels

[F8] ANALOG MIXING CONSOLE
├── Large Mixer Control Panel (MCP) with StripTease modular strips
├── Channel Strip VU Meters and Live Dynamic GR Readouts
└── Bus & Master Faders on Right Dock

[F9] MASTERING & METERING SUITE
├── Dual-Pane High-Resolution Spectral FFT Visualizer
├── EBU R128 Loudness Radar (LUFS Integrated / Short-Term / True Peak)
└── Mid/Side Audio Analysis Matrix
```

---

## 4. Theme Ecosystem

ReaFull includes 4 customized studio themes based on high-contrast ergonomic principles:

- **ReaFull Pro** (*Default*): Deep slate navy (#0F172A) console aesthetic with teal/cyan accents. Optimized for extended studio sessions with minimal eye fatigue.
- **ReaFull Dark**: Ultra-dark charcoal matte finish for low-light studio environments.
- **ReaFull Gray**: Balanced neutral studio console aesthetic with classic fader styling.
- **ReaFull Light**: High-contrast theme engineered for daylight tracking and outdoor recording sessions.

### Switching Themes
Themes can be switched instantly via *Options → Themes → ReaFull Pro / Dark / Gray / Light*.

---

## 5. SWS AutoColor & Track Icons

ReaFull bundles over 310 SWS AutoColor rules (`Data/sws-autocoloricon.ini`). When you name a track, REAPER automatically assigns the standard studio color and track icon:

| Track Name Pattern | Auto-Assigned Color | Assigned Icon |
| :--- | :--- | :--- |
| `KICK*`, `BD*` | Crimson Red (#C0392B) | `kick.png` |
| `SNARE*`, `SD*` | Bright Red (#E74C3C) | `snare.png` |
| `BASS*`, `DI BASS*` | Electric Blue (#2980B9) | `bass.png` |
| `GTR*`, `E_GTR*` | Sunset Orange (#D35400) | `guitar.png` |
| `AC GTR*` | Amber Gold (#F39C12) | `acoustic_gtr.png` |
| `LEAD VOC*`, `VOX*` | Vibrant Emerald (#27AE60) | `mic_lead.png` |
| `BACK VOC*`, `BVOX*` | Forest Green (#2ECC71) | `mic_backing.png` |
| `STRINGS*`, `VLN*` | Royal Violet (#8E44AD) | `strings.png` |
| `HORNS*`, `BRASS*` | Bright Gold (#F1C40F) | `brass.png` |
| `BUS*`, `MIXBUS*` | Deep Obsidian (#34495E) | `console_bus.png` |
| `FX*`, `REVERB*` | Magenta / Pink (#E84393) | `reverb.png` |

---

## 6. Studio Typography (Fonts)

ReaFull automatically installs studio-grade typography into `~/.local/share/fonts/ReaFull/` and registers them with the system via `fc-cache -f`:

- **Electrolize**: Monospace and modern sans for track names and digital readouts.
- **Frozen Crystal & Orbitron**: Tech-styled typography for meter heads and status displays.
- **Roboto & Open Sans**: High-legibility sans-serif for menus and action lists.
- **Alarm Clock**: Retro LED/OLED digital counter typography for timecode displays.
