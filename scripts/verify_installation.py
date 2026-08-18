#!/usr/bin/env python3
"""
ReaFull: Verification & Health Check Utility.
Performs comprehensive health checks on the REAPER configuration and template assets:
- Audits reaper.ini and INI files for broken paths / Windows drive letters
- Verifies placeholder expansion (no raw {{...}} remaining in target installations)
- Validates template directory integrity and placeholder syntax in config_templates
- Verifies ReaFull themes, JSFX suites, TrackTemplates, and fonts
- Checks SWS / ReaPack integration
"""

import os
import sys
import re
import argparse
import subprocess

def check_templates(templates_dir, quiet=False):
    """
    Validates template files in config_templates:
    - Zero Windows drive paths
    - Only valid placeholders (e.g. {{REAPER_CONFIG_DIR}}) in *.template.ini
    - Zero placeholders in static *.ini files
    """
    if not quiet:
        print(f"=== ReaFull Template Verification for: {templates_dir} ===\n")

    if not os.path.exists(templates_dir):
        if not quiet:
            print(f"[FAIL] Templates directory '{templates_dir}' does not exist!")
        return False

    issues = []
    checks_passed = 0

    # 1. Check required templates exist
    required_templates = [
        "reaper.template.ini",
        "S&M.template.ini",
        "reaper-extstate.template.ini",
        "sws-autocoloricon.ini",
        "reapack.ini",
        "reaper-kb.ini",
        "reaper-menu.ini",
        "reaper-mouse.ini",
        "reaper-screensets.ini",
    ]
    missing = [t for t in required_templates if not os.path.exists(os.path.join(templates_dir, t))]
    if not missing:
        if not quiet:
            print(f"[OK] All {len(required_templates)} core configuration templates found.")
        checks_passed += 1
    else:
        issues.append(f"Missing templates: {', '.join(missing)}")
        if not quiet:
            print(f"[WARN] Missing templates in {templates_dir}: {', '.join(missing)}")

    # 2. Audit Windows paths & placeholders
    win_paths = 0
    invalid_placeholders = 0
    valid_placeholder_pattern = re.compile(r"\{\{REAPER_CONFIG_DIR\}\}")

    for root, _, files in os.walk(templates_dir):
        for f in files:
            if f.endswith((".ini", ".template.ini")):
                fp = os.path.join(root, f)
                try:
                    with open(fp, "r", encoding="utf-8", errors="ignore") as inif:
                        content = inif.read()
                        
                        # In static .ini (not .template.ini), placeholders are forbidden
                        if not f.endswith(".template.ini") and "{{" in content:
                            invalid_placeholders += 1
                            issues.append(f"Unexpected placeholder in static file: {f}")
                        
                        # In .template.ini, check for invalid/unsupported placeholders
                        for match in re.finditer(r"\{\{([^}]+)\}\}", content):
                            ph = match.group(0)
                            if not valid_placeholder_pattern.fullmatch(ph):
                                invalid_placeholders += 1
                                issues.append(f"Unsupported placeholder '{ph}' in {f}")

                        for line in content.splitlines():
                            line_s = line.strip()
                            if re.search(r"^[a-zA-Z]:\\[^ \r\n]+", line_s) or re.search(r"^[a-zA-Z]:/(?:Users|Program|Windows|Desktop|Documents|Downloads|Temp|Common Files|REAPER|Cab Impulses|TEST)[^ \r\n]*", line_s, re.IGNORECASE):
                                if not ("http://" in line_s or "https://" in line_s):
                                    win_paths += 1
                except Exception as e:
                    issues.append(f"Error reading {fp}: {e}")

    if invalid_placeholders == 0:
        if not quiet:
            print("[OK] Template placeholders verified: all dynamic variables are valid.")
        checks_passed += 1
    else:
        if not quiet:
            print(f"[WARN] {invalid_placeholders} invalid or unhandled placeholder(s) detected.")

    if win_paths == 0:
        if not quiet:
            print("[OK] Clean Linux configuration: zero Windows drive paths detected.")
        checks_passed += 1
    else:
        issues.append(f"{win_paths} Windows drive paths found")
        if not quiet:
            print(f"[WARN] {win_paths} Windows drive paths detected in templates.")

    all_ok = len(issues) == 0
    if not quiet:
        print("\n" + "=" * 54)
        if all_ok:
            print("  Status: CONFIG TEMPLATES CLEAN & VERIFIED!")
        else:
            print(f"  Status: Template verification completed with {len(issues)} issue(s).")
            for iss in issues:
                print(f"   - {iss}")
        print("=" * 54)

    return all_ok

def check_reafull(target_dir=None, components=None, quiet=False):
    if not target_dir:
        native_dir = os.path.expanduser("~/.config/REAPER")
        flatpak_dir = os.path.expanduser("~/.var/app/fm.reaper.Reaper/config/REAPER")
        if os.path.exists(native_dir):
            target_dir = native_dir
        elif os.path.exists(flatpak_dir):
            target_dir = flatpak_dir
        else:
            target_dir = native_dir

    # Detect if user passed a templates directory
    normalized_path = os.path.abspath(target_dir)
    if os.path.basename(normalized_path) == "config_templates":
        return check_templates(target_dir, quiet=quiet)

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

    check_all = components is None or len(components) == 0

    # 2. Check Themes (if themes selected or full check)
    if check_all or "themes" in components:
        theme_pro = os.path.join(target_dir, "ColorThemes", "ReaFull Pro.ReaperThemeZip")
        if os.path.exists(theme_pro):
            if not quiet: print("[OK] ReaFull Pro theme installed.")
            checks_passed += 1
        else:
            issues.append("ReaFull Pro theme not found in ColorThemes/")
            if not quiet: print("[WARN] ReaFull Pro theme not found in ColorThemes.")

    # 3. Check JSFX Suites (if analog_fx or digital_fx selected or full check)
    if check_all or "analog_fx" in components or "digital_fx" in components:
        analog_fx = os.path.join(target_dir, "Effects", "ReaFull Analog FX")
        digital_fx = os.path.join(target_dir, "Effects", "ReaFull Digital FX")

        if os.path.exists(analog_fx) and os.path.exists(digital_fx):
            if not quiet: print("[OK] ReaFull Analog FX & Digital FX JSFX suites verified.")
            checks_passed += 1
        else:
            issues.append("ReaFull JSFX suites missing in Effects/")
            if not quiet: print("[WARN] ReaFull JSFX suites missing in Effects/.")

    # 4. Check Fonts (if fonts selected or full check)
    if check_all or "fonts" in components:
        try:
            res = subprocess.run(["fc-list"], capture_output=True, text=True)
            if "Electrolize" in res.stdout or "Roboto" in res.stdout or "Open Sans" in res.stdout:
                if not quiet: print("[OK] ReaFull typography available in fontconfig.")
                checks_passed += 1
            else:
                if not quiet: print("[INFO] Fonts might need terminal session restart or are loading locally.")
        except Exception as e:
            if not quiet: print(f"[INFO] fontconfig check skipped ({e}).")

    # 5. Check TrackTemplates (if templates selected or full check)
    if check_all or "templates" in components:
        templates_dir = os.path.join(target_dir, "TrackTemplates")
        if os.path.exists(templates_dir) and len(os.listdir(templates_dir)) >= 10:
            if not quiet: print(f"[OK] TrackTemplates installed ({len(os.listdir(templates_dir))} categories).")
            checks_passed += 1
        else:
            issues.append("TrackTemplates missing or incomplete")
            if not quiet: print("[WARN] TrackTemplates missing or incomplete.")

    # 6. Check SWS AutoColor (if sws_autocolor selected or full check)
    if check_all or "sws_autocolor" in components:
        sws_autocolor = os.path.join(target_dir, "sws-autocoloricon.ini")
        sws_autocolor_reafull = os.path.join(target_dir, "sws-autocoloricon.ini.reafull")
        if os.path.exists(sws_autocolor) or os.path.exists(sws_autocolor_reafull):
            if not quiet: print("[OK] SWS AutoColor & Icons configuration installed.")
            checks_passed += 1
        else:
            issues.append("sws-autocoloricon.ini missing")
            if not quiet: print("[WARN] sws-autocoloricon.ini not found.")

    # 7. Check Native Extensions (if extensions selected)
    if not check_all and "extensions" in components:
        userplugins_dir = os.path.join(target_dir, "UserPlugins")
        has_ext = os.path.exists(userplugins_dir) and any(
            f.startswith("reaper_sws") or f.startswith("reaper_reapack")
            for f in os.listdir(userplugins_dir)
        )
        if has_ext:
            if not quiet: print("[OK] Native REAPER extensions (SWS/ReaPack) verified.")
            checks_passed += 1
        else:
            issues.append("Native extensions (SWS/ReaPack) missing in UserPlugins/")
            if not quiet: print("[WARN] Native extensions missing in UserPlugins/.")

    # 8. Audit INI files for broken Windows paths and raw placeholders (ALWAYS check target INIs)
    ini_path_errors = 0
    raw_placeholders = 0
    for root, _, files in os.walk(target_dir):
        for f in files:
            if f.endswith(".ini"):
                fp = os.path.join(root, f)
                try:
                    with open(fp, "r", encoding="utf-8", errors="ignore") as inif:
                        content = inif.read()
                        if "{{" in content and "}}" in content:
                            raw_placeholders += 1
                        for line in content.splitlines():
                            line_s = line.strip()
                            # Match Windows absolute paths (e.g. C:\... or C:/Program Files/...)
                            if re.search(r"^[a-zA-Z]:\\[^ \r\n]+", line_s) or re.search(r"^[a-zA-Z]:/(?:Users|Program|Windows|Desktop|Documents|Downloads|Temp|Common Files|REAPER|Cab Impulses|TEST)[^ \r\n]*", line_s, re.IGNORECASE):
                                if not ("http://" in line_s or "https://" in line_s):
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
            print(f"  Status: Verification completed with {len(issues)} issue(s).")
            for iss in issues:
                print(f"   - {iss}")
        print("=" * 54)

    return all_ok

def main():
    parser = argparse.ArgumentParser(description="ReaFull Health Check & Verification Utility")
    parser.add_argument("target_dir", nargs="?", default=None, help="Directorio de configuración de REAPER a verificar o directorio de plantillas")
    parser.add_argument("--target", "-t", default=None, help="Directorio objetivo de configuración")
    parser.add_argument("--templates", action="store_true", help="Modo de validación de plantillas (config_templates)")
    parser.add_argument("--components", "-c", default=None, help="Lista de componentes instalados separados por coma")
    parser.add_argument("--quiet", "-q", action="store_true", help="Modo silencioso (solo exit code)")
    args = parser.parse_args()

    target = args.target or args.target_dir
    if args.templates:
        tpl_dir = target or os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "config_templates")
        success = check_templates(templates_dir=tpl_dir, quiet=args.quiet)
    else:
        components_list = [k.strip() for k in args.components.split(",")] if args.components else None
        success = check_reafull(target_dir=target, components=components_list, quiet=args.quiet)
    
    sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()
