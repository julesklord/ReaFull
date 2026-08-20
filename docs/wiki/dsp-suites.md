# ReaFull DSP Plugin Suites Catalog

> **Format**: JSFX (Jesusonic FX)  
> **Processing**: 64-bit Double-Precision Floating Point DSP  
> **Compatibility**: Native Linux REAPER (x86_64, aarch64)

ReaFull integrates over 50 studio-grade audio processing tools compiled in native JSFX. They provide zero external binary dependencies, sample-accurate parameter modulation, and low CPU consumption.

---

## 1. ReaFull Analog FX Suite

The **ReaFull Analog FX Suite** provides component-modeled vintage dynamics, passive equalizers, tape machines, and console summing stages with analog-style GUIs.

```
ReaFull Analog FX/
├── SolidBus          ← British 4K VCA Master Bus Compressor
├── DisTres-C         ← Non-linear digitizer & knee compressor (Empirical Labs style)
├── Pulse-EQ          ← Passive tube program equalizer (Pultec EQP-1A style)
├── FET-76            ← Ultra-fast FET peak limiter (1176 style with All-Buttons mode)
├── Opto-2A           ← Electro-optical leveling amplifier (LA-2A style)
├── Vari-Mu           ← Vacuum tube variable-mu mixbus compressor (Fairchild/Manley style)
├── Retro-C           ← Vintage tube leveler
├── VCA-160           ← Hard-knee VCA dynamic compressor (dbx 160 style)
├── Fat-Tape          ← Magnetic tape machine simulation (speed, bias, head-bump)
├── Tape-Dly          ← Tape delay with flutter, wow, and saturation
├── Tube-Pre          ← Triode/pentode tube preamplifier stage
├── Mix-Chan          ← Analog console channel strip with harmonic drive
├── Mix-Bus           ← Console mixbus summing with crosstalk & saturation
├── Sum-Desk          ← Multi-channel summing desk console
├── Sum-Strip         ← Line amplifier summing strip
├── ST-Bass           ← Dedicated analog bass channel processor
├── ST-Guitar         ← Dedicated electric guitar analog processor
└── VU-TK / VU-Z      ← Ballistic needle VU meters (-18 dBFS / -14 dBFS calibration)
```

### 1.1 Detailed Processor Descriptions

#### SolidBus (VCA Master Bus Compressor)
- **Model**: Classic British 4000-series console stereo bus compressor.
- **Controls**: Threshold, Ratio (2:1, 4:1, 10:1), Attack (0.1ms to 30ms), Release (0.1s to 1.2s, Auto), High-Pass Sidechain Filter (Off to 185Hz), Dry/Wet mix.
- **Best For**: Drum buses, mixbus glue, mastering punch.

#### DisTres-C / Distres (Non-Linear Knee Compressor)
- **Model**: Non-linear digitizer and harmonic distortion compressor.
- **Controls**: Ratio selections (1:1 to Nuke), Dist 2 (2nd harmonic tube warmth), Dist 3 (3rd harmonic tape grit), Opto release curve mode, Detector HPF and Band-Emphasis.
- **Best For**: Snare punch, acoustic guitars, aggressive rock vocals, parallel drum crushing.

#### Pulse-EQ (Passive Program Tube Equalizer)
- **Model**: Classic Pultec EQP-1A passive inductor/tube equalizer.
- **Controls**: Low-frequency simultaneous Boost & Attenuation (20, 30, 60, 100 Hz), High-frequency Boost & Bandwidth (3, 4, 5, 8, 10, 12, 16 kHz), High Attenuation (5, 10, 20 kHz).
- **Trick**: Simultaneous boost and cut on the low band creates the iconic "Pultec low-end trick" resonant bass shelf.

#### FET-76 (FET Peak Limiter)
- **Model**: Ultra-fast Class-A Field Effect Transistor peak compressor.
- **Controls**: Input (Drive), Output, Attack (20µs to 800µs), Release (50ms to 1100ms), Ratio (4:1, 8:1, 12:1, 20:1, and **All-Buttons In**).
- **Best For**: In-your-face lead vocals, bass guitar transient clamping, explosive drum rooms.

#### Opto-2A (Optical Leveling Amplifier)
- **Model**: T4 electro-optical attenuator leveling amplifier.
- **Controls**: Gain, Peak Reduction, Compress/Limit switch. Program-dependent two-stage release curve (50% recovery in 60ms, remaining over several seconds).
- **Best For**: Smooth vocals, bass guitars, brass, smooth acoustic instruments.

#### Fat-Tape (Analog Magnetic Tape Simulator)
- **Controls**: Tape Speed (7.5 IPS, 15 IPS, 30 IPS), Drive / Saturation, Head Bump Resonance, Bias (Warm/Bright), Hiss Level, Wow & Flutter.
- **Best For**: Taming harsh high-end transients on cymbals, adding low-end weight to drum groups, mixbus finishing.

---

## 2. ReaFull Digital FX Suite

The **ReaFull Digital FX Suite** delivers surgical precision tools for correction, spectral analysis, mastering dynamics, and loudness compliance.

```
ReaFull Digital FX/
├── D-DynEQ           ← Dynamic multi-band parametric equalizer
├── D-EQ / D-ReEQ     ← FFT-assisted parametric equalizers with surgical filters
├── D-Comp            ← Feed-forward transparent digital compressor
├── D-MSComp          ← Mid/Side matrix dual compressor
├── D-Limit           ← Mastering True-Peak brickwall limiter with lookahead
├── D-Multi           ← Multiband dynamic processor with linear-phase crossovers
├── Reflex 1, 2, 3    ← Algorithmic reverb suite (Plate, Room, Hall)
├── D-Meter / T-Meter ← EBU R128 / ITU-R BS.1770-4 LUFS analyzer & True Peak
├── T-FFT             ← Real-time high-resolution FFT spectrum visualizer
└── Test Generators   ← T-Tone, T-Pink, T-White, T-Phase, T-Quiet
```

### 2.1 Key Digital Tools

#### D-DynEQ (Dynamic Parametric Equalizer)
- Dynamic threshold and ratio per EQ band.
- Allows frequency-specific compression or expansion (e.g. compressing harsh 3.5kHz vocal resonances only when they exceed threshold).

#### D-Limit (Mastering True-Peak Brickwall Limiter)
- **Oversampled True-Peak Detection**: Catches inter-sample peaks (ISPs) to ensure compliant streaming releases.
- **Lookahead Buffer**: Prevents distortion on ultra-fast sub-bass transients.
- **Ceiling & Release Profiling**: Adjustable from transparent smooth release to aggressive punch.

#### D-Meter / T-Meter (EBU R128 Loudness Radar)
- Integrated LUFS (Target: -14 LUFS for Spotify/YouTube, -23 LUFS for Broadcast).
- Short-Term LUFS (3-second window), Momentary LUFS (400ms window).
- True Peak Max (dBTP), Loudness Range (LRA), RMS level.

---

## 3. StripTease Modular Mixer Engine

The **StripTease** suite transforms the REAPER Mixer Control Panel (MCP) into a modular analog hardware console:

```
+------------------------------------+
|  [VU GR METER] -12 -8 -4 -2 0 dB   |
|  ( ) THRESH    ( ) RATIO   ( ) GAIN|
|  [ HPF 80Hz ]  [ ALL BUTTONS IN ]  |
+------------------------------------+
  ^ Embedded modular strip in REAPER MCP
```

- **Embedded MCP Controls**: Live knobs, toggles, and ballistic VU meters rendered directly in the mixer without opening separate plugin floating windows.
- **Direct Parameter Link**: Binds panel controls to any native or third-party VST/JSFX parameter in real time.
- **Automatic GR Metering**: Captures Gain Reduction telemetry from compressors and displays live needle movement on the track strip.
- **7 Modular Panel Heights**: Standard heights (`50px`, `100px`, `150px`, `200px`, `300px`, `400px`, `600px`) for ergonomic track layouts.
- **12 Factory Channel Strips**: Ready-to-use SSL 4000, UAD 1176, Vertigo VSC-2, and mastering console presets.

---

## 4. Community Suites Integration

ReaFull integrates curated and optimized community suites:

| Suite | Author | Focus Areas |
| :--- | :--- | :--- |
| **Saike Tools** | Joep Vanlier | Physical modeling, analog saturation (Squashman), dynamic EQ, diffusion verbs. |
| **Sonic Anomaly** | Sonic Anomaly | SLAX-C opto compressor, QuadraCom 4-band dynamic processor, Hybrid-C, TriLeveler2. |
| **tilr** | Tiago LR | Step sequencers, multi-breakpoint envelopes, audio utilities. |
| **Liteon & LOSER** | Community | Mathematical audio filtering, saturated clippers, 3-band equalizers, stereo field rotators. |
| **Stillwell & Schwa** | Stillwell Audio | 1973 EQ, Major Tom compressor, Bad bus mojo saturation, Event Horizon limiter. |
