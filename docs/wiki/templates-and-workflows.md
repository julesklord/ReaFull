# Studio Templates, Workflows, Themes & Screensets

> **Components**: TrackTemplates (200+ Strips) · ProjectTemplates (19 Projects / 8 Genres) · Screensets (`F7-F9`) · Themes · SWS AutoColor · Grooves · MIDI Maps

This guide provides an exhaustive breakdown of the workflow architecture, session templates, theme variants, and navigation ergonomics built into ReaFull.

---

## Table of Contents

1. [17 Categorized Track Template Modules (200+ Strips)](#1-17-categorized-track-template-modules-200-strips)
2. [Genre-Tailored Project Templates (19 Projects)](#2-genre-tailored-project-templates-19-projects)
3. [Studio FX Chains (Mastering, Mixbus & Instruments)](#3-studio-fx-chains)
4. [Screensets & Ergonomic Studio Workspaces (`F7`, `F8`, `F9`)](#4-screensets--ergonomic-studio-workspaces)
5. [Theme Ecosystem & Contrast Engineering](#5-theme-ecosystem--contrast-engineering)
6. [SWS AutoColor & Track Icon Mappings](#6-sws-autocolor--track-icon-mappings)
7. [Grooves & MIDI Note Maps](#7-grooves--midi-note-maps)

---

## 1. 17 Categorized Track Template Modules (200+ Strips)

Located in `TrackTemplates/` (Right-Click Track Panel → *Insert track from template*):

### `00 Default` (Routing & Master Infrastructure)
- `00 AUDIO INPUT CHANNEL`: Calibrated direct tracking strip.
- `00 AUDIO`: Standard audio playback track.
- `00 AUXILIARY`: Effect return track with default reverb/delay sends.
- `00 BUS`: Group bus with SWS auto-routing.
- `00 MIXBUS`: Master mix summing bus with `SolidBus` and `Fat-Tape`.
- `00 MONITORING - PHONES`: Dedicated control room / headphone monitor feed.
- `00 VCA`: VCA master group control fader.

### `01 Electronic` (Synths & Urban Beats)
- `01 BEAT`: Drum machine master bus.
- `01 BOOMBOX`: Retro lofi hip-hop beat strip.
- `01 DEEP BASS`: Sub-heavy 808 with sidechain ducking.
- `01 DJ SET`: 2-deck crossfader routing track.
- `01 ELECTRO BASS`: Aggressive modulated synth bass.
- `01 ELECTRO LEAD`: Wide stereo saw lead with delay.
- `01 PAD`: Ambient polyphonic synth pad with lush chorus.
- `01 SUB BASS`: Pure 30Hz-80Hz sub-sine generator with saturation.

### `02 Drums` (Acoustic & Studio Drum Kits)
- `02 AC DRUMS`: Complete 12-channel acoustic drum kit folder.
- `02 KICK IN`, `02 KICK OUT`, `02 KICK SUB`: Multi-mic kick drum channels.
- `02 SNARE TOP`, `02 SNARE BOTTOM`: Snare wire and top head phase-aligned channels.
- `02 HI HAT`: Crisp condenser hi-hat channel with high-pass filter.
- `02 TOM 1`, `02 TOM 2`, `02 TOM 3`, `02 FLOOR TOM`: Gated and tuned tom channels.
- `02 OVERHEADS L/R`: Matched stereo pair overhead channels.
- `02 ROOM STEREO`, `02 ROOM MONO`: Crushed room ambient channels (`FET-76`).
- `02 COWBELL`, `02 CRASH CYM`, `02 RIDE CYM`: Individual cymbal and percussion spots.

### `03 Percussion` (Latin, Ethnic & Hand Drums)
- `03 BONGO`, `03 CONGA`, `03 TIMBAL`: Afro-Cuban percussion section.
- `03 CAJON PERUANO`: Dual-mic Peruvian cajon (front soundhole + rear slap).
- `03 CAJA VALLENATA`, `03 GUACHARACA`: Colombian vallenato rhythm section.
- `03 BOMBO ANDINO`, `03 CUICA`, `03 PANDEIRO`, `03 SURDO`: Latin American folk and samba kit.
- `03 CABASA`, `03 CLAVES`, `03 GUIRO`, `03 MARACAS`, `03 SHAKER`, `03 TAMBOURINE`, `03 TRIANGLE`: Auxiliary percussion spots.

### `04 Bass` (Electric, Acoustic & Synth)
- `04 BASS 1`, `04 BASS 2`, `04 BASS 3`: Studio electric bass presets (Clean, Grit, Slap).
- `04 BABY BASS`: Electric upright baby bass for salsa and Latin jazz.
- `04 CONTRABAJO`: Acoustic double bass with natural resonance control.
- `04 FRETLESS BASS`: Smooth mwah fretless tone with chorus.

### `05 AC Guitars` (Acoustic & Folk Strings)
- `05 AC GUITAR 1/2`: Steel-string acoustic guitars (Stereo pair & DI+Mic).
- `05 NYLON GUITAR`: Classical nylon guitar with warm tube preamp.
- `05 12 STRINGS GUITAR`: Bright, jangly 12-string guitar with stereo widening.
- `05 BAJO QUINTO`, `05 BANDOLA`, `05 BANJO`, `05 CHARANGO`, `05 CAVAQUINHO`, `05 CUATRO`, `05 GUITARRON`, `05 MANDOLIN`, `05 REQUINTO`, `05 TIIPLE`, `05 VIHUELA`: Traditional Latin and American folk instruments.

### `06 EL Guitars` (Electric Guitar Racks)
- `06 CLEAN GUITAR 1/2`: Fender-style clean chime with spring reverb.
- `06 CHUNK GUITAR 1/2`: British crunch rhythm guitars with tight low-end.
- `06 LEAD GUITAR 1/2`: High-gain singing sustain lead with tape delay.
- `06 ACOUSTIC SIM`: Electric guitar acoustic pickup simulator.
- `06 DIRECT INJECT (DI)`: Raw DI guitar ready for amp modeling.
- `06 DISTORTION GTR`, `06 OVERDRIVE GTR`, `06 ROCKABILLY GTR`, `06 SURF GTR`, `06 WAH WAH GTR`: Stylistic guitar pedal channels.

### `07 Keyboard` (Pianos, Organs & Synths)
- `07 GRAND PIANO`: Dynamic stereo concert grand piano.
- `07 RHODES`, `07 WURLITZER`: Vintage electric pianos with tremolo.
- `07 B3 ORGAN`: Rotary Leslie speaker organ with drive.
- `07 CLAVINET`: Funky auto-wah clavinet channel.
- `07 HARPSICHORD`, `07 HONKY TONK`, `07 MELLOTRON`: Specialty keys.
- `07 ACORDION BUTTONS`, `07 ACORDION KEYS`, `07 BANDONEON`: Accordion and tango reed keys.
- `07 BLUES HARP`: Overdriven harmonica channel.

### `08 Brass` & `09 Winds`
- `08 TRUMPET`, `08 TROMBONE`, `08 HORN`, `08 TUBA`: Brass solo spots and section bus.
- `08 ALTO SAX`, `08 TENOR SAX`, `08 BARITONE SAX`, `08 SOPRANO SAX`: Saxophone family.
- `09 FLUTE`, `09 CLARINET`, `09 OBOE`, `09 BASOON (FAGOT)`, `09 ENGLISH HORN`, `09 PICCOLO`, `09 RECORDER`: Woodwinds section.

### `10 Strings`
- `10 VIOLIN 1`, `10 VIOLIN 2`, `10 VIOLA`, `10 CELLO`, `10 DOUBLE BASS`: String quartet and solo instruments.
- `10 STRINGS SECTION`, `10 ORCHESTRA`: Full symphonic string ensemble buses.

### `11 Vocals`
- `11 LEAD VOCAL FEMALE`, `11 LEAD VOCAL MALE`: Primary vocal channel with `Opto-2A` and `Pulse-EQ`.
- `11 BACKING VOCALS FEMALE`, `11 BACKING VOCALS MALE`: Doubled background vocal bus.
- `11 CHOIR`, `11 TALKBACK`: Group choir and studio communication tracks.

### `12 Video Post` & `13 Podcasting`
- `12 SFX Track`, `12 VIDEO`: Stereo video playback and spot foley channels.
- `13 HOST 1-4`, `13 GUEST 1-2`, `13 DIALOGS 1-2`, `13 CROWD 1-2`, `13 JINGLE BUS`, `13 MASTER PODCAST`: Complete broadcast/podcast studio setup.

### `14 FX` (Dedicated Sends)
- `14 CHAMBER REVERB`, `14 CONVOLUTION REVERB`, `14 DELAY`, `14 DISTORTION`, `14 FLANGER`, `14 PHASER`, `14 PLATE REVERB`, `14 ROOM REVERB`, `14 SLAP DELAY`, `14 SPRING REVERB`, `14 STEREO DELAY`: Auxiliary return channels.

### `15 Stems` & `16 Separators`
- `15 Mixbus + Summing Stems (4 / 8 / 12 / 16 / 24)`: Print buses for stem mastering.
- `16 Separators (Drums, Bass, Guitars, Keys, Brass, Strings, Vocals, FX, Master)`: Color-coded spacer tracks.

---

## 2. Genre-Tailored Project Templates (19 Projects)

Located in `ProjectTemplates/`:

| Project Template Name | Style / Routing Architecture | Default Master Processing |
| :--- | :--- | :--- |
| **`AAA Mastering.rpp`** | Mastering suite with reference track A/B switching and Mid/Side monitoring. | `D-DynEQ` → `Pulse-EQ` → `Vari-Mu` → `D-Limit` → `D-Meter` |
| **`Rock - Blues - Stoner (Analog & Standard).rpp`** | Parallel drum crush bus, multi-mic electric guitar buses, and tape saturation on bass. | `SolidBus` (4:1) → `Fat-Tape` (15 IPS) → `Pulse-EQ` |
| **`Salsa Song (Analog & Standard).rpp`** | Dynamic percussion buses (Timbal, Conga, Bongo), horn section summing bus, bright vocals. | `Mix-Bus` → `SolidBus` → `D-EQ` → `D-Limit` |
| **`Metal & Hard Rock (Analog & Standard).rpp`** | Fast `FET-76` sidechained kick/bass, aggressive high-gain guitar grouping, parallel drum nuke. | `FET-76` (All-Buttons) → `SolidBus` → `D-Limit` |
| **`Jazz & Blues (Analog & Standard).rpp`** | Transparent acoustic dynamics, natural room reverb sends, minimal bus compression. | `Opto-2A` → `D-DynEQ` → `D-Meter` |
| **`Electronic & Urban (Analog & Standard).rpp`** | 808 sidechain ducking, pitch-bent vocal buses, aggressive clip saturation. | `D-Multi` → `Fat-Tape` → `D-Limit` |
| **`Ranchera & Mariachi (Analog & Standard).rpp`** | Guitarrón & Vihuela dedicated bus, trumpet dynamic tamers, wide stereo acoustic strings. | `Vari-Mu` → `Pulse-EQ` → `D-Limit` |
| **`Bolero Cubano (Analog & Standard).rpp`** | Warm tube preamp emulation on lead vocal, acoustic nylon guitar clarity, lush plate reverbs. | `Tube-Pre` → `Opto-2A` → `Reflex Plate` |
| **`Popular & Mexican (Analog & Standard).rpp`** | Balanced brass, accordion, and acoustic rhythm section for regional production. | `Mix-Bus` → `Pulse-EQ` → `SolidBus` |
| **`Full Tracks Project.rpp`** | 64-channel master template containing every standard instrument strip ready to arm. | Full Console Summing Matrix |

---

## 3. Studio FX Chains

Located in `FXChains/`:

### Mixbus & Mastering Chains
- `MIX BUS CONTROL G1.RfxChain` (British VCA + Tape + Pultec program chain)
- `MIX BUS CONTROL G2.RfxChain` (Tube Vari-Mu + Mid/Side EQ mastering chain)
- `FAT TAPE.RfxChain` & `FAT TAPE MCP REELS.RfxChain` (Tape machine simulation rack)
- `FX Separator.RfxChain` (Visual divider for FX chain windows)

### StripTease Modular MCP Chains (`FXChains/StripTease/`)
- `StripTease AO The Bus.RfxChain` (Analog Obsidian bus strip)
- `StripTease BX Glue.RfxChain` (VCA glue dynamic strip)
- `StripTease Bx Opto.RfxChain` (Optical vocal leveler strip)
- `StripTease Pro-C3.RfxChain` (Surgical digital dynamic strip)
- `StripTease SSL Channel.RfxChain` (British console strip)
- `StripTease 1176 LN.RfxChain` (FET punch channel)

---

## 4. Screensets & Ergonomic Studio Workspaces

| Shortcut | Screenset Name | Focus Layout |
| :--- | :--- | :--- |
| **`F7`** | **Arrangement / Editing** | Maximized horizontal track arrange view, floating bottom media explorer/actions docker, compact track control panels (TCP). |
| **`F8`** | **Analog Mixing Console** | Full-screen Mixer Control Panel (MCP) with StripTease modular strips, live VU Gain Reduction meters, and docked master fader on the right. |
| **`F9`** | **Mastering & Metering Suite** | Dual-pane high-resolution spectral FFT visualizer, EBU R128 Loudness Radar, and Mid/Side phase correlation matrix. |

---

## 5. Theme Ecosystem & Contrast Engineering

Located in `ColorThemes/`:

- **`ReaFull Pro.ReaperThemeZip`** (*Default*): Deep Slate Navy (#0F172A) console aesthetic with vibrant teal/cyan (#00D2BE) accents. Engineered for extended 10+ hour mixing sessions.
- **`ReaFull Dark.ReaperThemeZip`**: Charcoal matte finish (#0B0F19) for darkened studio control rooms.
- **`ReaFull Gray.ReaperThemeZip`**: Balanced neutral studio console aesthetic with classic fader styling.
- **`ReaFull Light.ReaperThemeZip`**: High-contrast theme engineered for daylight tracking and outdoor recording sessions.

---

## 6. SWS AutoColor & Track Icon Mappings

ReaFull applies over 310 automatic coloring rules from `Data/sws-autocoloricon.ini`:

| Rule Type | Pattern Filter | Hex Color Code | Track Icon |
| :--- | :--- | :--- | :--- |
| **Drums (Kick)** | `KICK*`, `BD*`, `BOMBO*` | `#C0392B` (Crimson Red) | `kick.png` |
| **Drums (Snare)** | `SNARE*`, `SD*`, `CAJA*` | `#E74C3C` (Bright Red) | `snare.png` |
| **Drums (Toms)** | `TOM*`, `FLOOR TOM*` | `#E67E22` (Orange) | `tom.png` |
| **Drums (Cymbals/OH)** | `OH*`, `OVERHEAD*`, `CYM*`, `HH*` | `#F39C12` (Amber) | `hihat.png` / `cymbal.png` |
| **Bass (DI/Amp)** | `BASS*`, `DI BASS*`, `SUB*` | `#2980B9` (Electric Blue) | `bass.png` |
| **Acoustic Guitars** | `AC GTR*`, `NYLON*`, `BANJO*` | `#D35400` (Rust Orange) | `acoustic_gtr.png` |
| **Electric Guitars** | `GTR*`, `E_GTR*`, `LEAD GTR*` | `#E67E22` (Sunset Orange) | `guitar.png` |
| **Keyboards / Piano** | `PIANO*`, `KEYS*`, `RHODES*`, `ORGAN*` | `#16A085` (Sea Green) | `piano.png` / `organ.png` |
| **Brass / Horns** | `BRASS*`, `TRUMPET*`, `SAX*`, `HORN*` | `#F1C40F` (Bright Gold) | `brass.png` / `sax.png` |
| **Strings** | `STRINGS*`, `VLN*`, `CELLO*` | `#8E44AD` (Royal Purple) | `strings.png` |
| **Lead Vocals** | `LEAD VOC*`, `VOX*`, `VOZ*` | `#27AE60` (Emerald Green) | `mic_lead.png` |
| **Backing Vocals** | `BACK VOC*`, `BVOX*`, `COROS*` | `#2ECC71` (Mint Green) | `mic_backing.png` |
| **Mixbus & Master** | `MIXBUS*`, `MASTER*`, `SUM*` | `#34495E` (Obsidian Navy) | `console_bus.png` |
| **FX & Reverbs** | `FX*`, `REVERB*`, `DELAY*`, `AUX*` | `#E84393` (Magenta Pink) | `reverb.png` |

---

## 7. Grooves & MIDI Note Maps

### 7.1 Vintage Swing Grooves (`Grooves/`)
- Akai MPC60 & MPC3000 swing templates (51% to 75% groove offsets).
- E-mu SP-1200 vintage quantize templates.
- Roger Linn humanized pocket grooves.

### 7.2 Drum Kit MIDI Note Names (`MIDINoteNames/`)
- Standard General MIDI (GM) Drum Map.
- Toontrack EZdrummer 2 / 3 & Superior Drummer 3.
- XLN Audio Addictive Drums 2.
- Steven Slate Drums 5 (SSD5).
- Native Instruments Studio Drummer & Abbey Road Series.
