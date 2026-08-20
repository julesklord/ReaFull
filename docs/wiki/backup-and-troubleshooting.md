# Backup, Restoration & Troubleshooting Runbook

> **Target Systems**: Linux REAPER Environments  
> **Key Tools**: `uninstall.sh`, `scripts/verify_installation.py`, `install.py`

This runbook details disaster recovery, backup management, automated health verification, and diagnostic steps for resolving common Linux audio workstation issues.

---

## 1. Automated Safety Backup Architecture

Every installation run of ReaFull creates a full timestamped backup of the target directory before modifying any files:

```
~/.config/
├── REAPER/                                                 ← Active Configuration
├── REAPER_backup_pre_reafull_20260818_143022/              ← Timestamped Safety Backup
└── REAPER_backup_pre_reafull_20260820_091540/              ← Subsequent Safety Backup
```

Backups are complete, bit-for-bit copies created via `shutil.copytree(..., symlinks=True)`.

---

## 2. Using the Uninstaller and Backup Recovery Tool (`uninstall.sh`)

ReaFull provides an interactive recovery utility located at the root of the repository:

```bash
./uninstall.sh
```

### 2.1 Menu Actions

```
Select an action:
  1. Restore a previous backup (Backup Restore)
  2. Uninstall ReaFull components (Themes, FX, Fonts)
  3. Delete old ReaFull backups (Free up space)
  4. Cancel and exit
```

#### Action 1: Restore a Previous Backup
- Scans `~/.config/` for all `REAPER_backup_pre_*` directories.
- Lists each backup with creation timestamp and disk size.
- Prompts for confirmation before atomically restoring the selected backup, completely reverting REAPER to its exact pre-installation state.

#### Action 2: Selective Component Removal
- Safely removes ReaFull color themes (`ReaFull*.ReaperThemeZip`) and splash images.
- Removes JSFX suites (`Effects/ReaFull Analog FX`, `Effects/ReaFull Digital FX`).
- Removes ReaFull scripts (`Scripts/ReaFull`).
- Removes installed studio fonts from `~/.local/share/fonts/ReaFull/` and refreshes `fc-cache`.
- Leaves your user projects, recordings, and custom plugins untouched.

#### Action 3: Clean Old Backups
- Deletes historical backup folders to reclaim disk space.

---

## 3. Automated Post-Install Health Verification

ReaFull includes an automated health check gate located in `scripts/verify_installation.py`. It runs automatically after every install, but can also be executed manually to diagnose a damaged installation:

```bash
python3 scripts/verify_installation.py ~/.config/REAPER
```

### 3.1 Verification Checklist Executed by the Tool

| Audit Phase | Verified Criteria | Error Condition |
| :--- | :--- | :--- |
| **1. Template Integrity** | Verifies `reaper.template.ini`, `S&M.template.ini`, `reapack.ini`, etc. | Missing template or invalid placeholder syntax. |
| **2. POSIX Sanitization** | Checks all INI files for raw Windows drive letters (`C:\...`, `D:\...`). | Hardcoded Windows paths detected. |
| **3. Placeholder Expansion** | Ensures all `{{REAPER_CONFIG_DIR}}` tokens were replaced with absolute paths. | Unexpanded `{{...}}` found in target directory. |
| **4. Asset Verification** | Confirms themes (`ReaFull Pro`), JSFX files, track templates, and fonts exist on disk. | Missing JSFX files or theme archives. |
| **5. SWS & ReaPack Audit** | Verifies `UserPlugins/reaper_sws-x86_64.so` and `reaper_reapack-x86_64.so`. | Missing extension binaries. |

---

## 4. Troubleshooting Common Linux Audio Issues

### 4.1 Audio Dropouts, Clicks, or Buffer Underruns (Xruns)

#### Symptom:
Audio playback crackles, clicks, or stutters during playback or recording.

#### Resolution Steps:
1. **Verify Realtime Limits**: Check if your user account has realtime permissions:
   ```bash
   ulimit -r -l
   # Output should show:
   # max locked memory       (kbytes, -l) unlimited
   # real-time priority              (-r) 95 (or 90+)
   ```
   If not, configure `/etc/security/limits.d/audio.conf` as described in the [Audio Engine Tuning Guide](./audio-engine-tuning.md).

2. **Adjust Buffer Size**: In REAPER (*Preferences → Audio → Device*):
   - For recording / live tracking: Set Block Size to `128` or `256` samples (48kHz).
   - For heavy mixing / mastering: Increase Block Size to `512` or `1024` samples.

3. **Check CPU Governor**: Ensure your CPU is not throttling:
   ```bash
   cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
   # If 'powersave', set to 'performance':
   echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
   ```

---

### 4.2 PipeWire Buffer Drift or High Latency

#### Symptom:
Latency feels higher than configured, or PipeWire changes buffer sizes dynamically.

#### Resolution Steps:
Force PipeWire's quantum buffer to a fixed size before launching REAPER:
```bash
# Force fixed 256 samples buffer at 48kHz
pw-metadata -n settings 0 clock.force-quantum 256
pw-metadata -n settings 0 clock.force-rate 48000
```

---

### 4.3 Missing SWS Extension or ReaPack in REAPER

#### Symptom:
SWS Actions (AutoColor, Loudness analysis, CueBuses) or ReaPack do not appear in the Action List or Extensions menu.

#### Resolution Steps:
1. Run the installer with the `extensions` component enabled:
   ```bash
   ./install.sh --components extensions
   ```
2. Verify that `reaper_sws-x86_64.so` exists in `~/.config/REAPER/UserPlugins/`:
   ```bash
   ls -la ~/.config/REAPER/UserPlugins/
   ```
3. Check permissions:
   ```bash
   chmod 755 ~/.config/REAPER/UserPlugins/*.so
   ```

---

### 4.4 Font Display / Missing Text Glyphs in Themes

#### Symptom:
Theme text looks misaligned or fallback fonts are displayed.

#### Resolution Steps:
1. Reinstall ReaFull studio fonts:
   ```bash
   ./install.sh --components fonts
   ```
2. Manually rebuild system font cache:
   ```bash
   fc-cache -f ~/.local/share/fonts
   ```
3. Verify font registration:
   ```bash
   fc-list : family | grep -E "Electrolize|Orbitron|Roboto|Alarm Clock"
   ```

---

### 4.5 Python ReaScript Engine Not Loading

#### Symptom:
ReaScripts requiring Python fail with "Python not found or not configured".

#### Resolution Steps:
ReaFull automatically detects `libpython3.so` in `/usr/lib/`. If your distribution uses a unique path:
1. Open REAPER (*Preferences → Plug-ins → ReaScript*).
2. Enable **Enable Python for use with ReaScript**.
3. Set **Custom path to Python dll directory** to `/usr/lib` (or `/usr/lib/x86_64-linux-gnu`).
4. Set **Force Python dll name** to `libpython3.11.so` (or your installed Python version).
5. Restart REAPER.

---

### 4.6 Flatpak Permission & Filesystem Sandbox Issues

#### Symptom:
Flatpak REAPER cannot access studio fonts or audio hardware devices directly.

#### Resolution Steps:
Grant filesystem and device permissions to the Flatpak container:
```bash
# Allow Flatpak REAPER access to fonts and user audio directories
flatpak override --user fm.reaper.Reaper --filesystem=xdg-data/fonts:ro
flatpak override --user fm.reaper.Reaper --filesystem=home
```
