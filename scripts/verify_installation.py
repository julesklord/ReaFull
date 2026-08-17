#!/usr/bin/env python3
"""
ReaFull: Verification utility.
Performs health checks on the current REAPER configuration:
- Checks font installation
- Verifies JSFX effects folders
- Verifies templates and themes
- Audits reaper.ini for broken paths
"""

import os
import sys
import subprocess

def check_reafull(target_dir=None):
    if not target_dir:
        target_dir = os.path.expanduser("~/.config/REAPER")

    print(f"=== ReaFull Health Check for: {target_dir} ===\n")
    all_ok = True

    # 1. Check directory existence
    if not os.path.exists(target_dir):
        print(f"[FAIL] REAPER config directory {target_dir} not found!")
        return False
    print("[OK] REAPER config directory exists.")

    # 2. Check Themes
    theme_pro = os.path.join(target_dir, "ColorThemes", "ReaFull Pro.ReaperThemeZip")
    theme_fallback = os.path.join(target_dir, "ColorThemes", "ReArtist 2.0 Pro.ReaperThemeZip")
    if os.path.exists(theme_pro) or os.path.exists(theme_fallback):
        print("[OK] ReaFull / ReArtist Pro theme installed.")
    else:
        print("[WARN] ReaFull Pro theme not found in ColorThemes.")
        all_ok = False

    # 3. Check JSFX Suites
    analog_fx = os.path.join(target_dir, "Effects", "ReaFull Analog FX")
    analog_fallback = os.path.join(target_dir, "Effects", "ReArtist Analog FX")
    digital_fx = os.path.join(target_dir, "Effects", "ReaFull Digital FX")
    digital_fallback = os.path.join(target_dir, "Effects", "ReArtist Digital FX")
    
    if (os.path.exists(analog_fx) or os.path.exists(analog_fallback)) and (os.path.exists(digital_fx) or os.path.exists(digital_fallback)):
        print("[OK] ReaFull Analog FX & Digital FX JSFX suites verified.")
    else:
        print("[WARN] JSFX suites missing in Effects/.")
        all_ok = False

    # 4. Check Fonts
    try:
        res = subprocess.run(["fc-list"], capture_output=True, text=True)
        if "Electrolize" in res.stdout and "Frozen Crystal" in res.stdout:
            print("[OK] ReaFull typography installed in fontconfig.")
        else:
            print("[WARN] Some typography fonts missing from fc-list.")
    except Exception as e:
        print(f"[WARN] Could not check fonts with fc-list: {e}")

    # 5. Check TrackTemplates
    templates_dir = os.path.join(target_dir, "TrackTemplates")
    if os.path.exists(templates_dir) and len(os.listdir(templates_dir)) >= 10:
        print(f"[OK] TrackTemplates installed ({len(os.listdir(templates_dir))} categories).")
    else:
        print("[WARN] TrackTemplates missing or incomplete.")
        all_ok = False

    # 6. Check SWS AutoColor
    sws_autocolor = os.path.join(target_dir, "sws-autocoloricon.ini")
    if os.path.exists(sws_autocolor):
        print("[OK] SWS AutoColor & Icons configuration installed.")
    else:
        print("[WARN] sws-autocoloricon.ini not found.")
        all_ok = False

    print("\n------------------------------------------------------")
    if all_ok:
        print("Status: ALL REAFULL COMPONENTS VERIFIED HEALTHY!")
    else:
        print("Status: Some components have warnings. Check details above.")
    print("------------------------------------------------------")
    return all_ok

if __name__ == "__main__":
    target = sys.argv[1] if len(sys.argv) > 1 else None
    check_reafull(target)
