# ReaFull Developer & Contributor Guide

> **Maintainer**: Jules Martins  
> **Repository**: [https://github.com/julesklord/ReaFull](https://github.com/julesklord/ReaFull)  
> **Toolchain**: Python 3.10+, Bash, Cockos REAPER v6.x / v7.x

This guide outlines the local development setup, template maintenance, validation pipelines, and release asset generation workflows.

---

## 1. Local Development Setup

### 1.1 Prerequisites
- Linux OS (Arch, Debian/Ubuntu, Fedora, openSUSE)
- Python 3.10+ with standard library
- Optional development tools: `Pillow` (for splash/screenshot rendering scripts)
- Cockos REAPER (Native Linux build installed)

### 1.2 Repository Clone
```bash
git clone https://github.com/julesklord/ReaFull.git
cd ReaFull
```

---

## 2. Directory Architecture for Contributors

```
ReaFull/
├── install.py                      ← Main installation and configuration merge engine
├── install.sh                      ← Interactive bootstrap wrapper for cURL / git
├── uninstall.sh                    ← Uninstaller and backup restoration utility
├── VERSION                         ← Single source of truth for project versioning
├── FMG-REPO-BIBLE.md               ← Organization-wide development standard
├── config_templates/               ← Master configuration templates
│   ├── *.template.ini              ← Dynamic templates (evaluated with {{REAPER_CONFIG_DIR}})
│   └── *.ini                       ← Static configuration profiles
├── assets/                         ← Local audio assets (ignored by git; fetched via CDN or local)
│   ├── ColorThemes/                ← ReaFull Pro, Dark, Gray, Light Themes & Splash
│   ├── Effects/                    ← JSFX Plugin Suites
│   ├── TrackTemplates/             ← 17 TrackTemplate Category Folders
│   ├── ProjectTemplates/           ← Genre Project Templates
│   ├── Fonts/                      ← Studio Fonts
│   └── Scripts/                    ← Lua/Python ReaScripts & StripTease
├── scripts/                        ← Validation, sanitization, and asset build utilities
│   ├── verify_installation.py      ← Health-check gate & path auditor
│   ├── sanitize_and_prepare.py     ← Template sanitizer (cleans Windows paths)
│   ├── audit_licenses.py           ← License auditor for bundled components
│   ├── create_splash_banner.py     ← Procedural splash renderer
│   └── render_terminal_screenshots.py ← Terminal showcase renderer
└── docs/
    ├── Splash ReaFull.png          ← Official splash branding & README cover
    ├── wiki/                       ← Comprehensive technical documentation
    ├── AGENT.md                    ← AI agent SOP entry point
    └── GEMINI.md                   ← Gemini CLI rules
```

---

## 3. Authoring & Editing Configuration Templates

When updating REAPER configurations in `config_templates/`:

1. **Path Placeholders**:
   - If an INI key points to an absolute path inside the REAPER config directory, use `{{REAPER_CONFIG_DIR}}` and save the file as `name.template.ini`.
   - Example: `splashimage={{REAPER_CONFIG_DIR}}/Splash ReaFull.png`
2. **Zero Windows Paths**:
   - Never commit hardcoded Windows drive letters (`C:\...`, `D:\...`, `\Users\...`).
   - Run `python3 scripts/sanitize_and_prepare.py` to sanitize new configurations.
3. **Static vs Dynamic**:
   - If a file has no path dependencies, save it directly as `name.ini` (e.g. `reaper-mouse.ini`, `sws-autocoloricon.ini`).

---

## 4. Developer Validation Tooling

Before submitting pull requests or cutting releases, execute the full test suite:

### 4.1 Dry-Run Simulation Test
Verify that the installer runs without errors across all presets:
```bash
python3 install.py --dry-run --preset core
python3 install.py --dry-run --preset full
python3 install.py --dry-run --preset minimal
```

### 4.2 Template & Path Integrity Audit
Audit all templates in `config_templates/`:
```bash
python3 scripts/verify_installation.py --audit-templates-only
```

### 4.3 Component License Audit
Verify license compliance across bundled JSFX suites and scripts:
```bash
python3 scripts/audit_licenses.py
```

---

## 5. Building Release Asset Bundles

To create a new release asset bundle for GitHub Releases CDN:

```bash
# 1. Update VERSION file (e.g. 2026.4.0)
echo "2026.4.0" > VERSION

# 2. Package assets tarball
tar -czvf reaffull-assets-v$(cat VERSION).tar.gz -C assets .

# 3. Calculate SHA-256 Checksum
sha256sum reaffull-assets-v$(cat VERSION).tar.gz

# 4. Update KNOWN_HASHES table in install.py and ASSETS_RELEASE_URL
```
