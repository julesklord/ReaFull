# Comprehensive DSP Plugin Suites Catalog

> **Format**: Jesusonic JSFX (64-bit Floating Point Precision)  
> **Host**: Cockos REAPER (Linux x86_64, aarch64)  
> **Latency**: Zero internal processing latency (sample-accurate)

ReaFull integrates over 50 studio-grade audio processing tools compiled in native JSFX. They provide zero external binary dependencies, sample-accurate parameter modulation, and low CPU consumption.

---

## Table of Contents

1. [ReaFull Analog FX Suite](#1-reafull-analog-fx-suite)
2. [ReaFull Digital FX Suite](#2-reafull-digital-fx-suite)
3. [StripTease Modular Mixer Strip Suite](#3-striptease-modular-mixer-strip-suite)
4. [Community FX Suites (Saike, Sonic Anomaly, Tilr, Classic DSP)](#4-integrated-community-fx-suites)
5. [Signal Calibration & Metering Tools](#5-signal-calibration--metering-tools)

---

## 1. ReaFull Analog FX Suite

The **ReaFull Analog FX Suite** provides component-level analog modeling of classic British VCA consoles, American FET limiters, passive tube program equalizers, optical levelers, and vintage magnetic tape machines with custom high-contrast GUIs.

```
Effects/ReaFull Analog FX/
├── SolidBus            ← British 4K VCA Master Bus Compressor
├── Distres / DisTres-C ← Non-linear digitizer & knee compressor (Distressor emulation)
├── Pulse-EQ            ← Passive tube program equalizer (Pultec EQP-1A emulation)
├── FET-76              ← Ultra-fast Class-A FET peak limiter (1176 LN emulation)
├── Opto-2A / Opto-2A-AI← Electro-optical leveling amplifier (LA-2A emulation)
├── Vari-Mu             ← Vacuum tube variable-mu mixbus compressor (Fairchild 670 / Manley)
├── Retro-C             ← Vintage variable-gain tube leveler
├── VCA-160             ← Hard-knee VCA dynamic punch processor (dbx 160 emulation)
├── Fat-Tape            ← Analog magnetic tape machine (7.5, 15, 30 IPS & Head-Bump)
├── Tape-Dly            ← Tape echo unit with flutter, wow, and saturation
├── Tube-Pre            ← Triode/Pentode tube preamplifier drive stage
├── Mix-Chan            ← Analog console channel strip with harmonic drive & filters
├── Mix-Bus             ← Console mixbus summing with crosstalk & saturation
├── Sum-Desk / Sum-Mix  ← Multi-channel summing console matrix
├── Sum-Strip           ← Line amplifier summing strip
├── ST-Bass             ← Dedicated analog bass channel processor
├── ST-Guitar           ← Dedicated electric guitar analog processor
├── VoKoder             ← Analog spectral vocoder engine
└── VU Meter / VU Zeno  ← Ballistic needle VU meters (-18 dBFS / -14 dBFS calibration)
```

### 1.1 Detailed Processor Manual

#### SolidBus (British VCA Master Bus Compressor)
- **Architecture**: Modeled after the iconic center section master bus compressor of classic 4000-series British mixing desks.
- **Circuit Behavior**: Feed-forward VCA gain reduction with auto-release program dependency and smooth stereo link.
- **Controls**:
  - `Threshold` (-20 dB to +20 dB): Sets the compression onset level.
  - `Ratio` (`2:1`, `4:1`, `10:1`): `2:1` for subtle mixbus glue; `4:1` for standard master compression; `10:1` for aggressive drum bus control.
  - `Attack` (`0.1`, `0.3`, `1.0`, `3.0`, `10.0`, `30.0` ms): `30ms` lets initial drum transients pass through before clamping.
  - `Release` (`0.1`, `0.3`, `0.6`, `1.2` s, `Auto`): `Auto` applies a two-stage release curve (fast recovery on transients, slow recovery on sustained bass).
  - `Sidechain HPF` (Off, 30 Hz to 185 Hz): High-pass filter on the detection path to prevent deep bass/kick from over-triggering pumping.
  - `Mix` (0% to 100%): Integrated parallel compression blend.
- **Recommended Usage**: Place on the master bus with `30ms` attack, `Auto` release, `2:1` or `4:1` ratio, aiming for **2 to 3 dB of gain reduction** on loudest peaks.

#### Distres / DisTres-C (Non-Linear Knee Compressor)
- **Architecture**: Empirical Labs Distressor style digital controlled analog compressor.
- **Controls**:
  - `Ratio`: `1:1` (warmth only), `2:1`, `3:1`, `4:1`, `6:1`, `10:1` (Opto curve), `20:1`, `Nuke` (brickwall limiting with reverse release).
  - `Distortion Modes`:
    - `Clean`: Standard dynamic compression.
    - `Dist 2`: Introduces warm 2nd-order harmonic distortion (triode tube character).
    - `Dist 3`: Introduces 3rd-order harmonic distortion (tape compression edge and grit).
  - `Detector Filters`:
    - `HPF`: High-pass filter on detector.
    - `Band-Emphasis`: 6kHz boost in detector to tame harsh sibilance or cymbal bite.
  - `Opto Mode`: Activates a 10:1 optical response with a dual-decay release curve.
- **Recommended Usage**: Snare drum punch (`6:1`, `Dist 2`), rock vocals (`4:1`, `Dist 3`, Band-Emphasis), parallel drum crushing (`Nuke`, fast attack/release).

#### Pulse-EQ (Passive Tube Program Equalizer)
- **Architecture**: Dual-inductor passive filter network with tube makeup gain modeled after the Pultec EQP-1A.
- **Controls**:
  - `Low Frequency Select`: `20`, `30`, `60`, `100` Hz.
  - `Low Boost` & `Low Attenuate`: Independent control over low-frequency boost and cut curves.
  - `High Frequency Select`: `3`, `4`, `5`, `8`, `10`, `12`, `16` kHz.
  - `High Boost` & `Bandwidth`: Boost amount with variable Q (Sharp to Broad).
  - `High Attenuate`: `5`, `10`, `20` kHz shelf attenuation.
- **The Iconic Pultec Trick**: Set low frequency to `60 Hz` (or `30 Hz`). Simultaneously turn `Low Boost` to 5 and `Low Atten` to 4. Because the boost and cut curves have slightly different center frequencies and slopes, this produces a fat, solid low-end shelf with an adjacent low-mid notch around 250-400Hz, removing muddiness while boosting sub-weight.

#### FET-76 (Class-A FET Peak Limiter)
- **Architecture**: Discrete Class-A field effect transistor gain control circuit with ultra-fast attack times modeled after the 1176 LN (Rev D/E).
- **Controls**:
  - `Input`: Drives the signal into the fixed threshold; controls both drive and compression depth.
  - `Output`: Makeup output gain.
  - `Attack` (1 to 7): 20 microseconds (position 7) to 800 microseconds (position 1). *Note: 1176 knobs are counter-intuitive — fully clockwise (7) is fastest.*
  - `Release` (1 to 7): 50 ms (position 7) to 1100 ms (position 1).
  - `Ratio`: `4:1`, `8:1`, `12:1`, `20:1`, and **All-Buttons-In** (British Mode).
  - `All-Buttons Mode`: Alters the bias voltage of the FET transistor, creating a non-linear release curve, dramatic harmonic distortion, and explosive room ambiance.
- **Recommended Usage**: Lead vocals (`4:1` or `8:1`, Attack 3, Release 7), DI Bass guitar leveling (`4:1`, Attack 2, Release 7), Room mics (`All-Buttons`, fast release).

#### Opto-2A & Opto-2A-AI (Electro-Optical Leveling Amplifier)
- **Architecture**: T4 optical attenuator cell emulation with luminescent panel and photoresistors modeled after the LA-2A.
- **Controls**:
  - `Gain`: Clean tube output amplifier gain.
  - `Peak Reduction`: Adjusts the voltage sent to the electroluminescent cell, controlling compression depth.
  - `Compress / Limit Switch`: Alters the ratio curve from gentle ~3:1 compression to ~10:1 limiting.
- **Dynamic Physics**: Program-dependent release: initial 50% recovery occurs in approximately 60 milliseconds, while the remaining tail decays smoothly over 1 to 5 seconds depending on prior input energy.
- **Recommended Usage**: Smooth acoustic vocals, acoustic guitar, clean bass guitar, strings, and brass.

#### Vari-Mu (Vacuum Tube Variable-Mu Mixbus Compressor)
- **Architecture**: Variable-mu triode tube gain reduction where input level dynamically alters the tube's grid bias, smoothly changing the amplification factor.
- **Controls**: Input Threshold, Recovery Time (6 calibrated presets), Sidechain HPF, Dual-Mono / Stereo Link mode.
- **Sound Character**: Ultra-creamy, harmonic "glue" that blends complex orchestrations and dense mixbuses without squashing transients.

#### Fat-Tape (Analog Magnetic Tape Machine)
- **Controls**:
  - `Tape Speed`: `7.5 IPS` (warm, rolled-off highs, heavy bass bump), `15 IPS` (standard punchy rock/pop sound with solid low-end), `30 IPS` (ultra-clean, extended high frequencies).
  - `Drive / Input`: Saturates the simulated magnetic tape oxide particles.
  - `Head Bump`: Low-frequency resonance created by the physical geometry of the tape playback head.
  - `Bias`: Adjusts high-frequency bias signal (Under-bias gives grit; Over-bias warms up highs).
  - `Wow & Flutter`: Subtle mechanical tape speed variations for vintage realism.
- **Recommended Usage**: Mixbus finishing (15 IPS, subtle drive), Drum group cohesion, harsh digital synth smoothing.

#### Tape-Dly (Vintage Tape Delay)
- Analog delay line with tape saturation feedback, tape flutter modulation, and high/low pass tone controls.
- Synchronized beat divisions (1/4, 1/8d, 1/8t, 1/16) or free millisecond mode.

#### Tube-Pre (Triode / Pentode Tube Preamplifier)
- Two-stage tube saturation engine with independent Triode (warm even-order harmonics) and Pentode (punchy aggressive odd-order harmonics) drive stages.

#### Mix-Chan, Mix-Bus & Sum-Desk (Console Summing Suite)
- Models the non-linear transfer curve, harmonic crosstalk, and micro-phase differences between mixing desk channels.
- `Mix-Chan`: Insert on individual tracks for cumulative console coloration.
- `Mix-Bus`: Insert on sub-groups and master bus to tie channels together.
- `Sum-Desk` / `Sum-Strip`: Multi-bus analog summing matrix.

#### ST-Bass & ST-Guitar (Dedicated Instrument Channel Strips)
- **ST-Bass**: Sub-octave generator, optical compression, 3-band bass EQ with selectable mid scoop (400Hz / 800Hz), and speaker cabinet simulation.
- **ST-Guitar**: Clean/Crunch/Lead preamp gain, mid-boost presence switch, noise gate, and analog 4x12 cab filter.

#### VU Meter & VU Zeno
- Analog ballistic needle meters with standardized ANSI C16.5-1954 dynamics (300ms rise time).
- Selectable calibration: `-18 dBFS = 0 VU` (Standard EBU digital recording) and `-14 dBFS = 0 VU` (High-energy modern mixing).

---

## 2. ReaFull Digital FX Suite

The **ReaFull Digital FX Suite** provides surgical, transparent, and high-precision tools for mixing, mastering, corrective filtering, and loudness metering.

```
Effects/ReaFull Digital FX/
├── D-DynEQ           ← Dynamic multi-band parametric equalizer
├── D-EQ / D-ReEQ     ← FFT-assisted parametric equalizers with surgical filters
├── D-Comp            ← Feed-forward transparent digital compressor
├── D-MSComp          ← Mid/Side dual-stage matrix compressor
├── D-Limit           ← Mastering True-Peak brickwall limiter with lookahead
├── D-Multi           ← 4-band linear-phase dynamic processor
├── D-Esser           ← Precision vocal de-esser with frequency monitor
├── D-Gate            ← Precision noise gate with sidechain filter
├── D-Noise           ← Spectral noise filter
├── D-Delay           ← Stereo digital delay with crossfeed & modulation
├── D-Shaper          ← Transient designer & envelope shaper
├── Reflex 1, 2, 3    ← Algorithmic reverb suite (Plate, Room, Hall)
├── T-Meter / D-Meter ← EBU R128 / ITU-R BS.1770-4 LUFS analyzer & True Peak
├── T-FFT             ← High-resolution real-time FFT spectrum visualizer
├── T-Peak / T-Phase  ← Stereo correlation meter and Lissajous vector scope
└── T-Tone/Pink/White ← Precision audio calibration signal generators
```

### 2.1 Key Digital Processors

#### D-DynEQ (Dynamic Parametric Equalizer)
- Combines multi-band parametric equalization with threshold-based dynamic compression/expansion per band.
- **Modes**: Below-Threshold Compression, Above-Threshold Compression, Upward Expansion, Downward Expansion.
- **Use Cases**: Taming harsh 3-4kHz vocal resonance only during loud phrases; controlling dynamic bass bloom without thinning the sound.

#### D-ReEQ & D-EQ (High-Precision Parametric Equalizers)
- Real-time FFT spectrum overlay with infinite zoom and curve drag.
- Filter types: Bell, Low-Shelf, High-Shelf, High-Pass (up to 96 dB/oct), Low-Pass, Notch, Band-Pass, Tilt.
- **Phase Modes**: Minimum Phase (zero latency, lowest CPU) and Linear Phase (zero phase smearing, ideal for mastering and multi-mic phase alignment).

#### D-Limit (Mastering True-Peak Brickwall Limiter)
- **Oversampled True-Peak Detection**: 4x/8x inter-sample peak detection to guarantee zero digital clipping on streaming DACs (Spotify, Apple Music, YouTube).
- **Adaptive Lookahead**: 1ms to 5ms lookahead buffer for clean, artifact-free transient control.
- **Release Character**: Continuous adjustment from transparent transient retention to dense RMS loudness.

#### D-MSComp (Mid/Side Matrix Compressor)
- Encodes stereo input into Mid (mono sum / center content: kick, snare, lead vocal, bass) and Side (stereo difference / width content: reverbs, stereo guitars, synth pads).
- Allows independent threshold, ratio, attack, and release on Mid vs Side.
- **Mastering Trick**: Compress Mid channel to tighten punch while leaving Side channel uncompressed (or expanded) for wide stereo staging.

#### Reflex 1, 2, 3 (Algorithmic Reverb Suite)
- **Reflex 1 (Vocal Plate)**: Fast diffusion, bright damping, high-density plate simulation for lead vocals and percussion.
- **Reflex 2 (Acoustic Room & Chamber)**: Natural early reflections and smooth decay tailored for drums, horns, and acoustic guitars.
- **Reflex 3 (Hall & Cathedral)**: Wide spatial modulation, long lush decay tails for orchestral strings, synth pads, and ambient soundscapes.

---

## 3. StripTease Modular Mixer Strip Suite

The **StripTease** suite turns REAPER's Mixer Control Panel (MCP) into a modular analog hardware console:

```
+------------------------------------+
|  [VU GR METER] -12 -8 -4 -2 0 dB   |
|  ( ) THRESH    ( ) RATIO   ( ) GAIN|
|  [ HPF 80Hz ]  [ ALL BUTTONS IN ]  |
+------------------------------------+
  ^ Embedded modular strip in REAPER MCP
```

### 3.1 Modular Panel Heights
- Standard modular heights available in `Effects/StripTease/`:
  - `StripTease Panel 050 px` (Compact VU & Trim)
  - `StripTease Panel 100 px` (Simple Compressor / Gate)
  - `StripTease Panel 150 px` (Channel EQ / Dynamics)
  - `StripTease Panel 200 px` (Full Channel Strip)
  - `StripTease Panel 300 px` (Console Module)
  - `StripTease Panel 400 px` (Extended Channel)
  - `StripTease Panel 600 px` (Master Bus Console)

### 3.2 Factory Curated StripTease Chains (`FXChains/StripTease/`)
- `StripTease AO The Bus.RfxChain` (Master bus console strip)
- `StripTease BX Glue.RfxChain` (Mixbus VCA glue strip)
- `StripTease Bx Opto.RfxChain` (Smooth opto vocal leveler)
- `StripTease Pro-C3.RfxChain` (Precision digital dynamic channel)
- `StripTease SSL 4000.RfxChain` (British console strip)
- `StripTease 1176 LN.RfxChain` (FET punch channel)

---

## 4. Integrated Community FX Suites

ReaFull bundles curated and optimized community suites in `Effects/`:

### 4.1 Saike Tools (by Joep Vanlier)
- **Squashman**: Multi-band distortion and saturation unit with customizable crossover points and dynamic waveshaping.
- **Filther**: Formant and vowel filtering matrix with LFO modulation.
- **DuskVerb & SatanVerb**: Dark algorithmic diffusion reverbs.
- **Reflectosaurus**: Multi-tap delay and spatial resonator.
- **Nuker**: Extreme dynamics destroyer for parallel drum squash.
- **ReaBee & Yutani**: Physical modeling synthesis and sound generation.

### 4.2 Sonic Anomaly Suite
- **SLAX-C**: Optical program compressor with smooth electro-optical curve and tube output stage.
- **QuadraCom**: 4-band multiband compressor designed for broadcast leveling and master bus balance.
- **Hybrid-C**: Fast-reacting hybrid compressor combining RMS detection with peak limiters.
- **SEGX2-G**: Smooth expander and noise gate for cleaning drum bleed and vocal background noise.
- **TriLeveler2**: Broadcast speech leveler with target LUFS normalization.

### 4.3 Tilr Tools (by Tiago LR)
- **Delay**: Analog delay, ping-pong delay, dub delay.
- **Distortion**: Wavefolders, saturation clippers, bitcrushers.
- **Filter**: State-variable ladder filters, comb filters.
- **MIDI**: Step sequencers, chord triggers, MIDI arpeggiators.
- **Synth**: `JSAdditiv` (Additive harmonic synthesizer) and `Rippler` (Physical mallet/percussion modeler).

### 4.4 Classic DSP Foundations (Liteon, LOSER, Stillwell, Schwa)
- **Stillwell**: `1973 EQ` (Neve style EQ), `Major Tom` (VCA compressor), `Bad Bus Mojo` (harmonic saturation), `Event Horizon` (master limiter).
- **LOSER**: `Satser`, `3-Band EQ`, `DVC Compressor`, `PingPong Delay`.
- **Liteon**: High-order Butterworth filters, pseudo-stereo widening, non-linear saturators.

---

## 5. Signal Calibration & Metering Tools

Located in `Effects/ReaFull Digital FX/`:

| Tool | Function | Technical Description |
| :--- | :--- | :--- |
| **T-Meter / D-Meter** | Loudness Radar | EBU R128 / ITU-R BS.1770-4 compliance. Displays Integrated LUFS, Short-Term (3s), Momentary (400ms), True Peak Max (dBTP), Loudness Range (LRA), and RMS. |
| **T-FFT** | Spectral Visualizer | High-resolution real-time FFT analyzer with adjustable window size (512 to 16384 points), smoothing, and peak hold. |
| **T-Phase & T-Peak** | Phase & Vector Scope | Real-time stereo correlation (-1.0 to +1.0) and Lissajous orbital vector display to detect phase cancellation. |
| **T-Tone** | Calibration Generator | Pure 1 kHz sine wave generator calibrated to -18 dBFS or -14 dBFS for studio hardware line alignment. |
| **T-Pink** | Pink Noise Generator | 1/f equal energy per octave noise for speaker room acoustic tuning and reference mixing. |
| **T-White** | White Noise Generator | Equal energy per Hertz test signal for FFT impulse response measurements. |
| **T-Quiet** | Reference Silence | Bit-perfect digital zero generator for noise floor verification. |
