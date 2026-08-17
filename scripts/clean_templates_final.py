#!/usr/bin/env python3
"""
Full cleanup and generator for ReaFull config templates.
Ensures zero hardcoded Windows paths across all templates.
"""
import os
import re

CONFIG_TEMPLATES_DIR = "/mnt/DEV/projects/repos/julesklord/ReaFull/config_templates"
ASSETS_DIR = "/mnt/DEV/projects/repos/julesklord/ReaFull/assets"

def clean_sm_ini():
    fpath = os.path.join(CONFIG_TEMPLATES_DIR, "S&M.template.ini")
    src_fpath = os.path.join(CONFIG_TEMPLATES_DIR, "S&M.ini")
    if not os.path.exists(src_fpath):
        return

    with open(src_fpath, "r", encoding="utf-8", errors="ignore") as f:
        content = f.read()

    # Replace hardcoded Windows paths with dynamic template variables
    content = re.sub(r'track_template_path="[^"]+"', r'track_template_path="{{REAPER_CONFIG_DIR}}/TrackTemplates/00 Default/00 PHONES .RTrackTemplate"', content)
    content = re.sub(r'AutoFillDirFXChains="[^"]+"', r'AutoFillDirFXChains="{{REAPER_CONFIG_DIR}}/FXChains"', content)
    content = re.sub(r'AutoSaveDirFXChains="[^"]+"', r'AutoSaveDirFXChains="{{REAPER_CONFIG_DIR}}/FXChains"', content)
    content = re.sub(r'AutoFillDirTrackTemplates="[^"]+"', r'AutoFillDirTrackTemplates="{{REAPER_CONFIG_DIR}}/TrackTemplates"', content)
    content = re.sub(r'AutoSaveDirTrackTemplates="[^"]+"', r'AutoSaveDirTrackTemplates="{{REAPER_CONFIG_DIR}}/TrackTemplates"', content)
    content = re.sub(r'AutoFillDirProjectTemplates="[^"]+"', r'AutoFillDirProjectTemplates="{{REAPER_CONFIG_DIR}}/ProjectTemplates"', content)
    content = re.sub(r'AutoSaveDirProjectTemplates="[^"]+"', r'AutoSaveDirProjectTemplates="{{REAPER_CONFIG_DIR}}/ProjectTemplates"', content)
    content = re.sub(r'AutoFillDirMediaFiles="[^"]+"', r'AutoFillDirMediaFiles="{{REAPER_CONFIG_DIR}}/MediaFiles"', content)
    content = re.sub(r'AutoSaveDirMediaFiles="[^"]+"', r'AutoSaveDirMediaFiles="{{REAPER_CONFIG_DIR}}/MediaFiles"', content)
    content = re.sub(r'AutoFillDirTrack_icons="[^"]+"', r'AutoFillDirTrack_icons="{{REAPER_CONFIG_DIR}}/Data/track_icons"', content)
    content = re.sub(r'AutoFillDirColorThemes="[^"]+"', r'AutoFillDirColorThemes="{{REAPER_CONFIG_DIR}}/ColorThemes"', content)
    content = re.sub(r';\s*C:\\Users\\[^\r\n]+', r'; ReaFull S&M Configuration', content)

    with open(fpath, "w", encoding="utf-8") as f:
        f.write(content)
    if os.path.exists(src_fpath):
        os.remove(src_fpath)
    print("[+] S&M.template.ini created.")

def clean_xenakios():
    fpath = os.path.join(CONFIG_TEMPLATES_DIR, "Xenakios_Commands.ini")
    if not os.path.exists(fpath):
        return
    with open(fpath, "r", encoding="utf-8", errors="ignore") as f:
        content = f.read()
    content = re.sub(r'EXTERNALTOOL1PATH=[^\r\n]+', r'EXTERNALTOOL1PATH=', content)
    with open(fpath, "w", encoding="utf-8") as f:
        f.write(content)
    print("[+] Xenakios_Commands.ini cleaned.")

def clean_recent_fx():
    fpath = os.path.join(CONFIG_TEMPLATES_DIR, "reaper-recentfx.ini")
    if not os.path.exists(fpath):
        return
    with open(fpath, "r", encoding="utf-8", errors="ignore") as f:
        lines = f.readlines()
    out_lines = []
    for line in lines:
        if "=" in line:
            k, v = line.split("=", 1)
            # Remove Windows file paths
            if re.match(r'^[a-zA-Z]:\\', v.strip()):
                continue
        out_lines.append(line)
    with open(fpath, "w", encoding="utf-8") as f:
        f.writelines(out_lines)
    print("[+] reaper-recentfx.ini cleaned.")

def remove_cache_files():
    print("[*] Removing stale cache files from assets...")
    for root, dirs, files in os.walk(ASSETS_DIR):
        for f in files:
            if "Cache" in f and f.endswith(".ini"):
                cache_file = os.path.join(root, f)
                print(f"  -> Removing {cache_file}")
                os.remove(cache_file)

if __name__ == "__main__":
    clean_sm_ini()
    clean_xenakios()
    clean_recent_fx()
    remove_cache_files()
