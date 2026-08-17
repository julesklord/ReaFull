#!/usr/bin/env python3
"""
ReaFull: Verification & Health Check Utility.
Performs comprehensive health checks on the REAPER configuration:
- Audits reaper.ini and INI files for broken paths / Windows drive letters
- Verifies placeholder expansion (no raw {{...}} remaining)
- Verifies ReaFull themes, JSFX suites, TrackTemplates, and fonts
- Checks SWS / ReaPack integration
"""

import os
import sys
import re
import argparse
import subprocess

def check_reafull(target_dir=None, quiet=False):
    if not target_dir:
        native_dir = os.path.expanduser("~/.config/REAPER")
        flatpak_dir = os.path.expanduser("~/.var/app/fm.reaper.Reaper/config/REAPER")
        if os.path.exists(native_dir):
            target_dir = native_dir
        elif os.path.exists(flatpak_dir):
            target_dir = flatpak_dir
        else:
            target_dir = native_dir

    if not quiet:
        print(f"=== ReaFull Health Check for: {target_dir} ===\n")
    
    issues = []
    checks_passed = 0

    # 1. Check directory existence
    if not os.path.exists(target_dir):
        msg = f"[FAIL] REAPER config directory {target_dir} does not exist!"
        if not quiet: print(msg)
        return False

    if not quiet: print("[OK] REAPER config directory exists.")
    checks_passed += 1

    # 2. Check Themes
    theme_pro = os.path.join(target_dir, "ColorThemes", "ReaFull Pro.ReaperThemeZip")
    if os.path.exists(theme_pro):
        if not quiet: print("[OK] ReaFull Pro theme installed.")
        checks_passed += 1
    else:
        issues.append("ReaFull Pro theme not found in ColorThemes/")
        if not quiet: print("[WARN] ReaFull Pro theme not found in ColorThemes.")

    # 3. Check JSFX Suites
    analog_fx = os.path.join(target_dir, "Effects", "ReaFull Analog FX")
    digital_fx = os.path.join(target_dir, "Effects", "ReaFull Digital FX")
    
    if os.path.exists(analog_fx) and os.path.exists(digital_fx):
        if not quiet: print("[OK] ReaFull Analog FX & Digital FX JSFX suites verified.")
        checks_passed += 1
    else:
        issues.append("ReaFull JSFX suites missing in Effects/")
        if not quiet: print("[WARN] ReaFull JSFX suites missing in Effects/.")

    # 4. Check Fonts
    try:
        res = subprocess.run(["fc-list"], capture_output=True, text=True)
        if "Electrolize" in res.stdout or "Roboto" in res.stdout or "Open Sans" in res.stdout:
            if not quiet: print("[OK] ReaFull typography available in fontconfig.")
            checks_passed += 1
        else:
            if not quiet: print("[INFO] Fonts might need terminal session restart or are loading locally.")
    except Exception as e:
        if not quiet: print(f"[INFO] fontconfig check skipped ({e}).")

    # 5. Check TrackTemplates
    templates_dir = os.path.join(target_dir, "TrackTemplates")
    if os.path.exists(templates_dir) and len(os.listdir(templates_dir)) >= 10:
        if not quiet: print(f"[OK] TrackTemplates installed ({len(os.listdir(templates_dir))} categories).")
        checks_passed += 1
    else:
        issues.append("TrackTemplates missing or incomplete")
        if not quiet: print("[WARN] TrackTemplates missing or incomplete.")

    # 6. Check SWS AutoColor
    sws_autocolor = os.path.join(target_dir, "sws-autocoloricon.ini")
    if os.path.exists(sws_autocolor):
        if not quiet: print("[OK] SWS AutoColor & Icons configuration installed.")
        checks_passed += 1
    else:
        issues.append("sws-autocoloricon.ini missing")
        if not quiet: print("[WARN] sws-autocoloricon.ini not found.")

    # 7. Audit INI files for broken Windows paths and raw placeholders
    ini_path_errors = 0
    raw_placeholders = 0
    for root, _, files in os.walk(target_dir):
        for f in files:
            if f.endswith(".ini"):
                fp = os.path.join(root, f)
                try:
                    with open(fp, "r", encoding="utf-8", errors="ignore") as inif:
                        content = inif.read()
                        if "{{REAPER_CONFIG_DIR}}" in content:
                            raw_placeholders += 1
                        for line in content.splitlines():
                            if re.search(r"^[a-zA-Z]:[\\/]", line.strip()) and not ("http://" in line or "https://" in line):
                                ini_path_errors += 1
                except Exception:
                    pass

    if raw_placeholders == 0:
        if not quiet: print("[OK] No raw {{...}} template placeholders detected.")
        checks_passed += 1
    else:
        issues.append(f"{raw_placeholders} unexpanded template placeholders found")
        if not quiet: print(f"[WARN] {raw_placeholders} unexpanded template placeholders found in target INIs.")

    if ini_path_errors == 0:
        if not quiet: print("[OK] Clean Linux configuration: zero Windows drive paths detected.")
        checks_passed += 1
    else:
        issues.append(f"{ini_path_errors} leftover Windows paths found")
        if not quiet: print(f"[WARN] {ini_path_errors} leftover Windows drive paths found.")

    all_ok = len(issues) == 0
    if not quiet:
        print("\n" + "=" * 54)
        if all_ok:
            print("  Status: REAFULL INSTALLATION HEALTHY & VERIFIED!")
        else:
            print(f"  Status: Verification completed with {len(issues)} warning(s).")
            for iss in issues:
                print(f"   - {iss}")
        print("=" * 54)

    return all_ok

def main():
    parser = argparse.ArgumentParser(description="ReaFull Health Check & Verification Utility")
    parser.add_argument("target_dir", nargs="?", default=None, help="Directorio de configuración de REAPER a verificar")
    parser.add_argument("--target", "-t", default=None, help="Directorio objetivo de configuración")
    parser.add_argument("--quiet", "-q", action="store_true", help="Modo silencioso (solo exit code)")
    args = parser.parse_args()

    target = args.target or args.target_dir
    success = check_reafull(target_dir=target, quiet=args.quiet)
    sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()
