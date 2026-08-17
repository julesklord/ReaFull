# Product Quality Audit — ReaFull

| Field | Value |
|---|---|
| Product | **ReaFull** — Production, mixing & mastering suite for REAPER on Linux |
| Audited version | `2025.1.0-linux` (`install.py`) · branch `main` @ `c4ac8de` |
| Date | August 17, 2026 |
| Scope | Full repository: installer, uninstaller, templates, assets, branding, licenses, in-DAW updater, documentation, and packaging |
| Type | Product quality audit (not just code) |
| Verdict | **Not ready for a public release as a "100% native professional suite."** The content is valuable; the packaging, legal hygiene, and non-destruction promise fall short. |

---

## 1. Executive Summary

ReaFull is a *port* and rebrand of **ReArtist Pro** (Edu Serra) to Linux. The value proposition is clear and compelling: turn native REAPER (or Flatpak) into a workstation ready for production, mixing, and mastering, with themes, analog/digital JSFX, templates, keymaps, grooves, and an installer that promises not to break the user's environment.

That promise is, today, **partially false**.

The repository is an almost complete *dump* of a Windows ReArtist installation (13,383 files, **2.1 GB**), with an incomplete rebranding layer and a Python installer that does have good ideas (backup, `reaper.ini` merge, ALSA detection), but which:

1. **Overwrites** keymaps, menus, ReaPack, and dozens of user INI files.
2. **Poorly filters** personal data and Windows paths from the original author.
3. **Duplicates** ~605 MB of JSFX suites (ReArtist + ReaFull identical).
4. **Claims** in the README that `C:\...` paths "are completely eradicated." They are not.
5. **Has** no tests, CI, changelog, GitHub releases, user guide, or post-install onboarding.

As an *internal kit* or *preview for early adopters who know REAPER*, it is usable and generous. As a public product presented as "The Ultimate REAPER Production Suite for Linux," it is **one or two serious iterations** of hygiene, legal, and UX away from saying that with a straight face.

### Overall Score

**5.8 / 10** — *rich content, immature packaging*.

| Dimension | Score | Brief Comment |
|---|---:|---|
| Value proposition | 8.5 | The problem it solves is real and the bundle is generous. |
| Content / depth | 8.0 | Themes, 200 track templates, 19 project templates, JSFX suites, grooves, render presets. |
| Promise vs. reality | 4.0 | The README oversells sanitization, non-destruction, and "100% native." |
| Installation & recovery | 6.0 | Backup and installer exist; overwrite, Flatpak, and uninstall are fragile. |
| Brand identity | 4.5 | Half rebrand: ReaFull on the outside, ReArtist on the inside. |
| Hygiene & privacy | 3.5 | Edu Serra's paths, projects, and logs remain in the package. |
| Legal / licenses | 4.0 | MIT at root vs. embedded LGPL/GPL; Cockos PDFs; Windows binaries; fonts without OFL. |
| In-DAW UX | 6.5 | Workflow inherited from ReArtist is solid; onboarding and updater are not. |
| Operations / release | 2.5 | No tests, CI, changelog, tags, or releases. Insecure updater. |
| Product documentation | 4.0 | Marketing README. Zero ReaFull user guide. |

---

## 2. What the Product Is (and What It Is Not)

### 2.1 Observed Definition

ReaFull is not a DAW or a plugin. It is a **configuration distribution** for Cockos REAPER:

- Themes (`ReaFull Pro/Dark/Gray/Light`)
- Analog + Digital JSFX Suites (Tukan / Sonic Anomaly / REEQ / etc. skins)
- ~200 track templates by instrument and role
- 19 project templates by genre (salsa, ranchera, metal, jazz, mastering...)
- Keymaps, menus, mouse maps, screensets, FX chains, grooves
- Thousands of third-party ReaScripts (ReaTeam, MPL, X-Raym, FTC, HeDa, Sexan...)
- Linux installer + in-DAW updater

The creative and workflow DNA is from **Edu Serra / ReArtist Pro**. The Linux packaging, sanitization, and rebrand work is from **Jules Martins**. That duality is unresolved: the product can't decide if it's a *fork* with its own identity or an *official/unofficial port* of ReArtist.

### 2.2 Implicit Target User

1. Producer/mixer on Linux who wants REAPER "ready" without weeks of setup.
2. ReArtist user on Windows migrating to Linux.
3. Someone looking for an analog-modeled console (SSL/Neve/Pultec/1176/LA-2A) in JSFX.

The installer and README **do not segment** these three. A veteran REAPER user with their own keymap will suffer more than a new user.

### 2.3 README Promises vs. Evidence

| Promise | Reality | Verdict |
|---|---|---|
| "100% Linux Native" | `J:\`, `F:\`, `C:/Program Files (x86)/ReArtist/ffmpeg.exe` paths remain; `C:\Users\EDU SERRA\...` logs; 5 Windows `.exe` files; Windows fonts (`MS Shell Dlg`, `Segoe UI`). | **Violated** |
| "Fully Sanitized" | `reaper.template.ini` retains 13 recent projects from Edu Serra and mastering paths. | **Violated** |
| "Smart Non-Destructive Installer" | Backup yes. Then `shutil.copy2` of 17 INI files over the user's (`reaper-kb.ini`, `reaper-menu.ini`, `reapack.ini`...). | **Partial** |
| "Preserves ALSA, JACK, Pipewire, licenses, recent projects" | The `reaper.ini` merge does protect a set of keys. The rest of the configs do not. | **Partial** |
| "Battery-Included" | True: themes, JSFX, templates, scripts, grooves, fonts. | **Met** |
| "In-DAW Updater" | Exists, but there are no GitHub releases; downloads `install.py` from `main` and runs it in the background **without checksum or `--target`**. | **Met in form, failed in substance** |
| "4 curated theme flavors" | The 4 ReaFull `.ReaperThemeZip` files are **byte-identical copies** of ReArtist 2.0. | **Met as asset, not as rebrand** |

---

## 3. Strengths (What Works Well)

This is not an empty project. There is product substance:

1. **Concrete proposition.** "REAPER on Linux, studio-ready" is a real gap. Native REAPER on Linux ships bare.
2. **Workflow depth.** 200 well-taxonomized track templates (00 Default → 16 Separators), project templates by genre (latin/rock/electronic), bus/tape FX chains, LUFS render presets (Spotify −8/−10/−12/−14, CD). That's not improvised.
3. **JSFX Suites with GUI.** Analog (SolidBus, Distres, Pulse-EQ, Fat-Tape, FET-76, Opto-2A, Mix-Chan, Sum-Desk...) and Digital (D-Comp, D-DynEQ, Reflex 1/2/3, T-FFT, T-Meter). For a Linux user without Waves/UAD, this is the heart of the product.
4. **Installer with good ideas.** Native/Flatpak detection, dry-run, `--no-backup`, `--quiet`, selective `reaper.ini` merge, ALSA UMC404HD/AudioBox detection, r8brain resampling defaults, `linux_mlockall`, `alsa_rtprio`.
5. **Backup + restore.** `create_backup()` + `uninstall.sh` provide a rollback path. Few DAW configurators have this.
6. **Visible credits.** README names Edu Serra, Cockos, FTC, HeDa, Lokasenna, MPL, X-Raym, Archie, Saike, Tilr, StevieKeys, SWS, cfillion. That is ethical and necessary.
7. **Well-chosen ReaPack remotes.** 15 remotes coherent with what's packaged (ReaTeam, MPL, X-Raym, FTC, Sexan, Suzuki, Tilr, Saike...).
8. **Automated typography.** Copies to `~/.local/share/fonts/ReaFull` + `fc-cache`. A product detail, not just a script.

These strengths are the reason to fix the rest, not throw it away.

---

## 4. Findings

Severity levels:

- **P0** — Blocks a public release or can harm the user / author.
- **P1** — Breaks the product promise or generates recurring support.
- **P2** — Visible debt; doesn't block, but erodes trust.
- **P3** — Polish.

---

### P0 — Blockers

#### P0.1 The installer is not non-destructive

`deploy_configurations()` does `shutil.copy2` of 17 INI files over the live REAPER directory:

`reaper-kb.ini`, `reaper-menu.ini`, `reaper-mouse.ini`, `reapack.ini`, `reaper-fxfolders.ini`, `reaper-screensets.ini`, `BR.ini`, `Xenakios_Commands.ini`, etc.

A user with years of shortcuts, custom menus, or ReaPack remotes **loses them** (unless they restore the backup). The README says the opposite.

The smart merge exists **only** for `reaper.ini`, and even there it's incomplete (see P1.2).

**Product impact:** A Linux power user who tries ReaFull one afternoon may feel they've had their "REAPER formatted." That kills adoption and generates panic issues.

**Remedy:** Per-file merge (or at minimum, don't touch `reaper-kb.ini` / `reapack.ini` / `reaper-mouse.ini` if they already exist, except with `--force`). Offer profiles: *Fresh studio* vs *Overlay on my setup*.

#### P0.2 Third-party personal and session data in the package

`config_templates/reaper.template.ini` includes:

- `importpath=J:\Antonio Dorado`
- `lastprojuiref=J:\REARTIST.NET\Test RA2025 Borrar\...`
- 13 `recent0N=` entries with real projects (`Lazy Dogs LP`, `Psicophony_Peste de Silicio`, `Aston Maio-Mamacita-Urbano`, `Gaga`, paths on `H:\`, `E:\`, `K:\`)
- `lastrenderpath3/5/6` pointing to mastering drives
- `lastdir=G:\Cab Impulses\BOGREN\Bogren.Digital.Jens.Bogren.Signature.IR.Pack...`

Additionally:

- `assets/Scripts/HeDaScripts/HeDaScripts Manager.log` — session log of **EDU SERRA** on Windows, with `C:\Users\EDU SERRA\AppData\...` paths, curl version, 7-Zip tests.
- `reaper-extstate.template.ini` → `ffmpeg path=C:/Program Files (x86)/ReArtist/ffmpeg/bin/ffmpeg.exe`
- Dozens of `ReaImGui/*.ini` with window geometry from that session.

If the user installs on a clean machine, **they inherit another person's project history**. If they publish the repo, they publish someone else's session metadata.

**Remedy:** Key allowlist in the template. Delete `recent*`, `lastproj*`, `lastdir`, `lastrenderpath*`, logs, `ReaImGui/*.ini` runtime data. Regenerate `reaper.template.ini` from a *factory* profile.

#### P0.3 Unresolved legal and attribution conflict

| Layer | Observed License | Problem |
|---|---|---|
| Repo root | MIT (Jules Martins, 2025) | MIT does not cover the bundle. |
| ReArtist | LGPL v3 (Edu Serra, 2023) — the file says "LGLP" (typo) | A Combined Work LGPL + MIT requires notices, attached GPL/LGPL, and cannot be "relicensed" as MIT. |
| Embedded ReaScripts | Mostly GPL-3 (ReaTeam, MPL, X-Raym...) | Redistributing 5,000+ scripts as a snapshot violates the spirit (and sometimes the letter) of "install via ReaPack." Several authors explicitly request this. |
| Analog/Digital JSFX | Tukan Studios (John Matthews), Sonic Anomaly (Stige T), REEQ (Justin Johnson), Cockos skins | The `ABOUT` file acknowledges this. Rebranding to "ReaFull Analog FX" + ReArtist logos in GUI + MIT at root is a broken attribution chain. |
| `assets/Docs/ReaperUserGuide734e.pdf`, `Reaper FX Manual v2022.pdf` | Cockos Copyright | Redistributing the official user guide in a third-party repo is at minimum gray area. Cockos typically doesn't authorize this. |
| `ogler.clap` (13 MB) | Third-party CLAP binary | No license, no source, no provenance note. |
| `7za.exe`, `curl.exe` (HeDa) | Windows binaries | Junk in a Linux product; also redistribution of 7-Zip/curl. |
| Fonts | OFL for Open Sans, Orbitron, Roboto | **No license** for Electrolize, FrozenCrystal, "alarm clock". |

The README says: *"Bundled JSFX and ReaScripts maintain their respective open-source licenses."* That's a footnote, not a *NOTICE* / *THIRD_PARTY.md*. For a product that is cloned and installed in full, that's not enough.

**Minimum remedy for a public v1:**

1. `NOTICE.md` + `THIRD_PARTY.md` with author, license, and origin for each block.
2. Root: "installer MIT; bundled content under original licenses."
3. Remove Cockos PDFs (link to the official website).
4. Remove `.exe`, `.log`, `ogler.clap` if there's no clear license.
5. Add OFL/licenses for the 3 missing fonts, or don't package them.
6. Prefer ReaPack for third-party scripts instead of vendoring 156 MB.

#### P0.4 Insecure and incomplete in-DAW updater

`assets/Scripts/ReaFull/ReaFull_Updater.lua`:

- Queries `/releases/latest`. **There are no releases.** It always falls back.
- The actual "update" is:

  ```lua
  python3 -c "...urlretrieve('.../main/install.py', '/tmp/reafull_install.py');
              os.system('python3 /tmp/reafull_install.py --quiet --no-backup')"
  ```

  Problems: no integrity check, runs `--no-backup`, **doesn't pass `--target`** (breaks Flatpak), runs in the background while REAPER is open (the installer itself warns that REAPER should be closed), and the OS-detect is broken:

  ```lua
  local is_linux = reaper.GetOS():match("Other") or reaper.GetOS():match("OSX") == nil and reaper.GetOS():match("Win") == nil
  ```

  `is_linux` **is never used**. The menu is in Spanish, the rest of the product in English.

**Impact:** A user who clicks "update" may overwrite their config **without backup** and, on Flatpak, write to `~/.config/REAPER` instead of the sandbox.

---

### P1 — Breaks the Product Promise

#### P1.1 Incomplete rebrand: the user gets ReArtist instead of ReaFull

The rebrand is a **file copy**, not a product transformation.

| Surface | Status |
|---|---|
| Splash, README, `install.py`, `Scripts/ReaFull/` folder | ReaFull |
| `ReaFull *.ReaperThemeZip` themes | Identical copies of `ReArtist 2.0 *` (all 8 still shipped) |
| `ReaFull Analog/Digital FX` suites | Identical copies of `ReArtist *` (**+605 MB**) |
| Plugin internal names | `SolidBus (ReArtist Pro)`, `D-Comp (ReArtist Pro)...` |
| GUI logos | `ReArtist Logo BLUE.png` / `GREY.png` in dozens of JSFX |
| `ABOUT THIS PLUGIN COLLECTION.txt` | References ReArtist, Edu Serra, "REARTIST" folder |
| `MouseMaps/` | Only `ReArtist Pro.ReaperMouseMap` — no ReaFull |
| `Scripts/Cockos/ReArtist_theme_adjuster.lua` | No ReaFull equivalent |
| `S&M.template.ini` theme slots | Still point to `ReArtist 2.0 *.ReaperThemeZip` |
| `reaper-fxoptions.ini` | Hundreds of `ReARTIST/...` and `ReArtist Analog FX/...` entries |

The user sees "ReaFull Pro" on the splash and "ReArtist Pro" in every plugin. That's not an easter egg: it's a product that hasn't finished being born.

**Cost of not deciding:** 605 MB × 2 JSFX + 4 duplicate themes. In a GitHub clone / installer backup, it hurts.

**Product decision needed (pick one):**

- **A. Faithful ReArtist port** — keep the ReArtist name on plugins (correct attribution), ReaFull only as "Linux edition / installer."
- **B. Own brand** — real rebrand of JSFX slugs, ABOUT, theme adjuster, mouse map, fxoptions; stop shipping the ReArtist tree.

Right now it's A and B simultaneously, worse than either.

#### P1.2 `reaper.template.ini` is not a template

It's a `REAPER.ini` from a 2025 Windows machine, with placeholders only in `lastthemefn5` and `splashimage`. It retains:

- Window geometry from a specific monitor (`iconpicker_x=-1275`, docks, prefs at absolute coordinates).
- Windows fonts (`Segoe UI`, `Arial Narrow`, `alarm clock`).
- Project and render history (P0.2).
- Hardware/UI keys that the merge tries to preserve *if they already exist*, but are installed as-is in a new profile.

The merge **does not expand** `{{REAPER_CONFIG_DIR}}` in template lines: it rewrites theme/splash manually. If anyone adds more placeholders, they'll remain as literals.

#### P1.3 Incomplete target and process detection for real Linux

```python
def detect_reaper_dir():
    if os.path.exists(native_dir):
        return native_dir
    elif os.path.exists(flatpak_dir):
        return flatpak_dir
    return native_dir
```

If the user has **both** (very common: tried native and switched to Flatpak, or vice versa), native always wins. It doesn't ask.

`is_reaper_running()` uses `pgrep -x reaper`. A Flatpak binary or a `reaper.exe` under Wine isn't detected. The user can install over a live session.

`uninstall.sh` **only** looks at `$HOME/.config/REAPER` (or `$1`). No Flatpak, no `--quiet`, no documented `*_backup_pre_reafull_*` backup listing in the README.

`install.sh` warns about missing deps but **proceeds anyway**. `curl` is listed as a dependency but the Python installer doesn't use it.

#### P1.4 Aggressive and too-specific audio defaults

`detect_best_audio_settings()` is well-intentioned but poorly generalized:

- Hardcodes `hw:U192k` (Behringer UMC404HD) and `hw:USB` (AudioBox). Any other interface is ignored.
- `alsa_rtprio=90` + `linux_mlockall=1` fail silently without `rtirq` / `limits.conf` / `audio` group. The user sees xruns or REAPER not opening ALSA, not an error message.
- Forces 48 kHz / 256 / 3 buffers. Legitimate as a studio default; not documented or prompted.
- If the user *already* has a device, it may overwrite `playresamplemode`, `afxb`, `workthreads` when they're `"0"` / `"50"`.

A "pro Linux" product should detect PipeWire/JACK first (it's the 2026 stack), not just `aplay -l` + two interface brands.

#### P1.5 Startup scripts without consent

`assets/Scripts/__startup.lua` launches at startup:

1. Lil Chordbox (FTC)
2. Adaptive grid (background)
3. Gridbox

In a product marketed as a "studio console," opening two MIDI/grid overlays at every launch is an author's decision, not a universal default. No toggle, no wizard, not documented.

#### P1.6 Verification disconnected from the product flow

`scripts/verify_installation.py` exists and is the right seed for a health check. The installer **doesn't call it**. The README doesn't mention it. It checks 6 superficial things (folder, one theme, two FX dirs, two font names, ≥10 track templates, one INI). It doesn't validate:

- That JSFX resolves correctly
- That no literal `{{REAPER_CONFIG_DIR}}` remains
- That no `C:\` exists in the installed `reaper.ini`
- That SWS/ReaPack were linked
- That the *alarm clock* / Orbitron fonts (used by the theme) are present

It also accepts the ReArtist fallback as "OK", hiding a half-done rebrand.

#### P1.7 Packaging scripts are not product, they're kitchen leftovers

`scripts/sanitize_and_prepare.py`, `apply_rebranding.py`, `clean_templates_final.py` contain:

```python
REPO_DIR = "/mnt/DEV/projects/repos/julesklord/ReaFull"
SRC_EXTRACTED = "/home/julesklord/.cache/reartist_extracted_files"
```

Author's machine paths. If a contributor (or their mental updater) runs these elsewhere, they do nothing or write outside. There's no `Makefile` / `justfile` distinguishing *package build* from *user install*.

This is not just code debt: it's a signal that **the repo *is* the working copy of a migration**, not a reproducible artifact.

---

### P2 — Visible Debt

#### P2.1 The repo is a dump, not a package

| Tree | Size | Comment |
|---|---:|---|
| `Effects/` | 1.3 GB | Half duplicated ReArtist/ReaFull |
| `Scripts/` | 156 MB | ~5,042 `.lua` files from all of ReaTeam + HeDa + MPL + X-Raym... |
| `Data/` | 49 MB | Includes `tilr_*` **and** `tilr8_*` (duplicate samples) + 1,788 toolbar icons |
| `Docs/` | 29 MB | Official REAPER manuals |
| `ReaPack/` | 15 MB | `registry.db` snapshot from April 2025 + cache |
| `UserPlugins/FX/ogler.clap` | 13 MB | Loose binary |
| `ColorThemes/` | 15 MB | 8 zips, 4 of which are clones |
| **Total** | **2.1 GB** | A `git clone` is hostile. An installer backup duplicates that again. |

`create_backup()` does `copytree` of the **entire REAPER directory**. After installing ReaFull, the next update copies ~2 GB+ again. On a laptop SSD that's a product bug.

**Right direction:** *core* profile (themes + ReaFull JSFX + templates + kb/menu) at ~400–500 MB, with an optional *full* profile. Third-party scripts via ReaPack, not vendored.

#### P2.2 Nonexistent product documentation

There's a marketing README and two Cockos PDFs. Missing:

- First 15 minutes guide (which theme, which screenset, where the analog FX are)
- Keymap map (the product *is* a keymap)
- ReaFull Pro / Dark / Gray / Light differences
- What each project template does
- Which JSFX to use on a vocal bus vs. a mixbus
- Linux troubleshooting (PipeWire, rtprio, Flatpak permissions, fonts not loading)
- Real changelog / semver
- Update policy

The keymap is called `ReaFull Pro Full Keymap` and there isn't a single page explaining it. A new user can't adopt a keymap they don't understand.

`AGENTS.md` at the root is a Claude Code skills dump, not project documentation. In a public repo it's noise (and a bit confusing).

#### P2.3 Missing release operations

- No `.github/workflows`
- No issue / PR templates
- No `CHANGELOG.md`
- No tags / GitHub Releases (the updater depends on them)
- No tests (not even an asserted `--dry-run`)
- Version `2025.1.0-linux` in a repo audited in 2026, no timeline
- 5 commits, all setup. No trace of user feedback.

A "suite" product without a reliable update channel **ages the day it's cloned**. The ReaTeam scripts from the snapshot stay frozen; ReaPack will later fight local copies.

#### P2.4 Installer / uninstaller UX

- `install.sh` prints ASCII art and delegates. Fine.
- `--quiet` isn't quiet: it still prints the cyan banner.
- No progress bar. Copying 2 GB silently looks like a hang.
- No resume; if it fails midway, it leaves a half-painted REAPER + a backup.
- `uninstall.sh` is restore, not uninstall. It doesn't remove fonts from `~/.local/share/fonts/ReaFull`. The name is misleading.
- `ls -d ${CONFIG_DIR}_backup_pre_*` without quotes breaks if the path has spaces.
- No `set -u` or validation that REAPER isn't open during uninstall.

#### P2.5 Inconsistent visual identity

- Two splashes (ReaFull + ReArtist) are both installed (ReArtist's lives in `assets/branding/` and isn't copied, but it's in the clone).
- Theme adjuster, mouse map, and internal logos are still ReArtist.
- Updater menu in Spanish; CLI and README in English; Edu's scripts in mixed English/Spanish.
- Typo "LGLP v3" in the ReArtist license.
- `install.py` VERSION year 2025 vs. copyright 2025 vs. actual date 2026.

#### P2.6 Curatorship-free third-party script surface

Shipping HeDa Track Inspector 2 + HeDaScripts Manager (with `7za.exe`, `curl.exe`, and a Windows `.log`) inside a Linux product is dead weight. Track Inspector is paid / has its own manager: redistributing its settings tree and binaries is a commercial risk in addition to being technical.

The same applies to snapshots of Sexan Pie3000, ReaSpaghetti, McSequencer, etc. A curated product picks 20 tools and documents them. A dump ships 5,000 and prays.

#### P2.7 Quality of "verify" and sanitizers

The sanitizers (`clean_fxfolders.py`, `sanitize_and_prepare.py`) are migration one-shots, not gates. Proof: after running them, `reaper.template.ini` **still** has `J:\` and `F:\`. The gate doesn't exist.

`apply_rebranding.py` does `content.replace("ReArtist", "ReaFull")` in menus. That's a blind replace: it can break credits, comments, or IDs that should have stayed.

---

### P3 — Polish

- `__startup.lua` has extra blank lines and zero product header.
- `Grooves/` is duplicated: `assets/Grooves` and `assets/Data/Grooves`.
- `tilr_*` and `tilr8_*` coexist (wav samples × 2).
- `MouseMaps` has no ReaFull variant.
- `LangPack/` (10 MB) installs without asking for language.
- `reaper_www_root/` (5.4 MB) is not mentioned in the README.
- Extra keymaps (`DK keymap`, `German Keymap`) with no documentation on when to use them.
- `pgrep -x reaper` doesn't cover `reaper.bin` / AppImage.
- `fc-cache` is called even when it doesn't exist (`install.sh` only warns).
- SWS/ReaPack links only search 4 x86_64 paths. No ARM64, no `/usr/lib64`, no `~/.local`.
- `safe_copy_tree` silences copy errors: a half-copied JSFX installs as "OK".
- No `CONTRIBUTING`, no policy on "what's accepted in the bundle."

---

## 5. User Journey Audit

### 5.1 Discovery

The README reads well: hero, bullets, FX list with hardware-sounding names, CLI. The splash helps. A **real** screenshot of REAPER already themed (TCP/MCP/mixer) is missing — that's what sells a DAW suite. An Ardour/Bitwig user can't imagine the look.

### 5.2 Installation (First 10 Minutes)

1. **2.1 GB clone.** High friction. No "core" release zip.
2. `./install.sh` — OK for Linux.
3. If REAPER is open, it asks. Good.
4. Silent backup of entire `~/.config/REAPER`. In an already large installation, the user doesn't know they just spent another 2 GB.
5. Mass copy without progress.
6. End: "Start REAPER now". Zero checklist (close PipeWire session? install SWS? close and reopen?).

**Truth moment:** On opening REAPER, the Pro theme should load and the splash should show. That probably works. Then:

- Three FTC tools auto-launch.
- The FX browser shows "ReArtist Pro" on every analog.
- Recent projects may list drives `J:\` that don't exist.
- The keymap has replaced the user's.

There's no tour, no "ReaFull Hub", no welcome page. The updater is buried in `Scripts/ReaFull/`.

### 5.3 Daily Use

Here the product **wins**, if the user accepts the ReArtist workflow:

- Track templates with icons and SWS autocolor.
- Mix-Chan / Mix-Bus / Sum-Desk as console metaphor.
- Mixing vs. editing screensets.
- LUFS render presets ready.
- MPC/SP1200/ASR10 grooves — a producer's detail, not a computer scientist's.

That's the *core loop* and it's inherited, not invented. Inheriting it is fine. It needs to be **named and documented**.

### 5.4 Update / Uninstall

Update: broken (no releases) or dangerous (main + `--no-backup`).
Uninstall: backup restore, not actual uninstall. Fonts remain. Flatpak not covered.

### 5.5 Support

No ISSUE_TEMPLATE, no FAQ, no "known Linux issues." Users will go to GitHub Issues or the REAPER Discord talking about ReArtist and ReaFull simultaneously. Support impossible to scale.

---

## 6. Product Architecture (How It Is vs. How It Should Be)

```
Today:
  [Windows ReArtist Dump]
        |  scripts/*_prepare.py  (hardcoded /home/julesklord paths)
        v
  [2.1 GB Repo, dual brand]
        |  install.py  (copytree + partial merge)
        v
  [~/.config/REAPER  or  Flatpak, sometimes the wrong one]
        |  updater.lua  (git main, no-backup)
        v
  [Drift / overwrite]

Should be:
  [Versioned ReArtist source + Linux/ReaFull patches]
        |  reproducible pipeline (sanitize → audit paths → pack)
        v
  [Artifact "reafull-core-x.y.z.tar.zst" + optional "reafull-extras"]
        |  installer: Fresh | Overlay profile, explicit native/Flatpak target
        v
  [REAPER]  +  health-check  +  updater by signed tag
```

The gap is not technical, it's **product discipline**: stop treating the working copy as the release.

---

## 7. Risks

| Risk | Prob. | Impact | Note |
|---|---|---|---|
| User loses keymap/menus and blames ReaFull publicly | High | High | P0.1 |
| Takedown / friction with Cockos over official PDFs | Low | High | Easy to avoid |
| Friction with Tukan / Sonic Anomaly / HeDa over redistribution + rebrand | Medium | High | Edu's ABOUT is honest; MIT at root is not |
| Edu Serra doesn't recognize this port / ReArtist brand conflict | Medium | High | There's credit, no evidence of written agreement in the repo |
| Updater overwrites a Flatpak session | Medium | High | P0.4 |
| 2 GB clone + backups fill the disk | High | Medium | P2.1 |
| "100% sanitized" debunked in 30 seconds with `rg 'J:\\'` | High | Medium | Damages credibility |
| ReaTeam snapshot rots and clashes with ReaPack | High | Medium | P2.3 / P2.6 |

---

## 8. Recommended Roadmap (To Say "v1.0")

Ordered by trust return, not shininess.

### Sprint 0 — Stop Causing Harm (Before Any Announcement)

1. Clean `reaper.template.ini` / `reaper-extstate.template.ini` of paths, recents, renders, ffmpeg.exe.
2. Delete `HeDaScripts Manager.log`, `ReaImGui/*.ini` runtime data, `.exe`, Cockos PDFs, `ogler.clap` if there's no license.
3. Installer **must not overwrite** `reaper-kb.ini`, `reaper-mouse.ini`, `reapack.ini` if they exist, except with `--force`.
4. Updater: disable `main` download until there are releases. Keep only "sync ReaPack" + "reload theme."
5. `NOTICE.md` + clarify that MIT covers the installer, not the bundle.

### Sprint 1 — Honest Product

6. Decide A or B (ReArtist port vs. own brand) and remove the duplicate tree (605 MB).
7. Installation profiles: `core` / `full`.
8. Target wizard: Native vs Flatpak vs custom path.
9. Call `verify_installation.py` at the end, and harden it (zero `C:\`, zero literal `{{…}}`).
10. Honest README: what gets overwritten, what's preserved, SWS/ReaPack/PipeWire requirements, clone size.

### Sprint 2 — Feels Like a Product

11. "First 15 minutes" guide + keymap cheat sheet.
12. Real mixer Pro screenshot.
13. `__startup.lua` opt-in, or a "ReaFull Setup" wizard on first launch.
14. PipeWire/JACK detection + message if `mlockall`/rtprio aren't available.
15. Progress in the installer. Uninstall that actually uninstalls (fonts included) in addition to restore.
16. Tag `v2026.1.0`, GitHub Release, changelog. Point the updater to that tag with checksum.

### Sprint 3 — Sustainable

17. Stop vendoring the entire ReaTeam. ReaPack remotes + a version pin.
18. CI: `python3 install.py --dry-run` + Windows path linter + placeholder test.
19. Remove generic `AGENTS.md` or replace it with real repo conventions.
20. Explicit agreement (even an archived email / signed credits section) with the ReArtist / Tukan / Sonic Anomaly lineage.

---

## 9. Exit Criteria for a "Go" Release

A public v1.0 should pass **all**:

- [ ] `rg '[A-Z]:\\\\|C:/Program Files' config_templates assets/Scripts/ReaFull` → 0 session hits
- [ ] No `.exe`, user `.log`, or Cockos-copyrighted PDFs in the tree
- [ ] Single FX tree (ReaFull **or** ReArtist), not both
- [ ] Installer with Fresh / Overlay profiles; Overlay doesn't overwrite kb/mouse/reapack
- [ ] `--target` / detection asks if native + Flatpak both exist
- [ ] Post-install health check with exit code ≠ 0 on failure
- [ ] Updater only communicates with a release tag + checksum, or is disabled
- [ ] `NOTICE.md` / `THIRD_PARTY.md` reviewed
- [ ] 15-minute guide + 1 real screenshot
- [ ] "Core" clone < 700 MB (ideally < 400 MB)

Today the product **passes none** of those checks cleanly.

---

## 10. Conclusion

ReaFull has the material of a great Linux product: an analog-modeled console, a template vocabulary that understands real genres (not just "EDM starter"), and an installer that already thinks about ALSA, backups, and Flatpak. That's more than most "REAPER configs" circulating as opaque zips.

What it doesn't yet have is **product discipline**.

It's a working copy of a Windows → Linux migration, published with a README that speaks as if the migration were finished. The user pays that distance with a 2 GB clone, an overwritten keymap, an FX browser saying ReArtist, someone else's project history, and an Update button that shouldn't exist.

The good news: almost all P0/P1 is hygiene and decisions, not DSP or design. In two short sprints ReaFull can go from "dump with aspirations" to "the canonical way to use REAPER on Linux." Until then, the honest verdict is:

> **Use it locally, with a backup, knowing you're installing a half-sanitized ReArtist Pro.**
> **Don't announce it yet as a native, non-destructive, battery-included suite.**

---

### Appendix A — Quick Inventory

| Component | Count / Size | Quality Notes |
|---|---|---|
| Themes | 8 zips (4+4 clones) | ReaFull/ReArtist identical |
| JSFX Analog | 382 MB × 2 | ReArtist names and logos |
| JSFX Digital | 223 MB × 2 | Same |
| Track templates | 200 / 16 categories | Strength |
| Project templates | 19 | Strength; paths OK |
| Lua scripts | ~5,042 | Dump, no curation |
| Grooves | 82 + copy in `Data/` | Duplicates |
| Fonts | 11 files | 3 without license in repo |
| Config templates | 22 INI | 2 still with Windows paths |
| Windows binaries | 5 `.exe` | HeDa Manager |
| Automated tests | 0 | — |
| GitHub releases | 0 | Updater useless |
| ReaFull user guide | 0 | — |

### Appendix B — Key Files Reviewed

- `README.md`, `LICENSE`, `install.py`, `install.sh`, `uninstall.sh`
- `scripts/{sanitize_and_prepare,apply_rebranding,clean_fxfolders,clean_templates_final,verify_installation}.py`
- `config_templates/reaper.template.ini`, `reaper-extstate.template.ini`, `S&M.template.ini`, `reapack.ini`, `reaper-kb.ini`
- `assets/Scripts/ReaFull/ReaFull_Updater.lua`, `assets/Scripts/__startup.lua`
- `assets/Licences/*`, `assets/Effects/ReaFull Analog FX/ABOUT THIS PLUGIN COLLECTION.txt`
- Inventory of `assets/{ColorThemes,Effects,Scripts,UserPlugins,ProjectTemplates,TrackTemplates,Docs}`

### Appendix C — Method

Static audit of the repository (reading installer, templates, licenses, updater, README; measuring sizes and duplicates; searching for Windows paths, binaries, and session leftovers). The installer was not run against a live REAPER instance and JSFX DSP/audio was not validated. In-DAW UX notes are inferred from startup (`__startup.lua`), templates, and configs, not from a mixing session.
