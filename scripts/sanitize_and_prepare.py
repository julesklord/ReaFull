#!/usr/bin/env python3
"""
ReaFull: Asset sanitizer and packager for Linux REAPER.
Extracts, cleans, and sanitizes all ReArtist Pro 2025 resources:
- Replaces Windows paths with dynamic Linux paths
- Normalizes path separators (\ -> /)
- Bundles complete Analog FX & Digital FX JSFX suites
- Produces clean configuration templates
"""

import os
import sys
import shutil
import re

REPO_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ASSETS_DIR = os.path.join(REPO_DIR, "assets")
CONFIG_TEMPLATES_DIR = os.path.join(REPO_DIR, "config_templates")

SRC_EXTRACTED = "/home/julesklord/.cache/reartist_extracted_files"
SRC_APP_DATA = os.path.join(SRC_EXTRACTED, "AppDataFolder", "REAPER")
SRC_FONTS = os.path.join(SRC_EXTRACTED, "FontsFolder")
SRC_PROGRAM_FILES = os.path.join(SRC_EXTRACTED, "ProgramFilesFolder", "ReArtist")
SRC_FLATPAK_EFFECTS = os.path.expanduser("~/.var/app/fm.reaper.Reaper/config/REAPER/Effects")

def safe_copy_tree(src_dir, dst_dir):
    os.makedirs(dst_dir, exist_ok=True)
    for root, dirs, files in os.walk(src_dir):
        rel_path = os.path.relpath(root, src_dir)
        target_dir = os.path.join(dst_dir, rel_path)
        os.makedirs(target_dir, exist_ok=True)
        for f in files:
            src_file = os.path.join(root, f)
            dst_file = os.path.join(target_dir, f)
            if os.path.islink(src_file):
                continue
            shutil.copy2(src_file, dst_file)

def copy_and_sanitize_assets():
    print("[*] Copying assets to ReaFull/assets/...")
    
    # 1. Fonts
    fonts_dst = os.path.join(ASSETS_DIR, "Fonts")
    if os.path.exists(SRC_FONTS):
        print("  -> Fonts...")
        safe_copy_tree(SRC_FONTS, fonts_dst)

    # 2. Branding (Splash screen)
    branding_dst = os.path.join(ASSETS_DIR, "branding")
    os.makedirs(branding_dst, exist_ok=True)
    splash_src = os.path.join(SRC_PROGRAM_FILES, "Splash ReArtist Pro.png")
    if os.path.exists(splash_src):
        shutil.copy2(splash_src, os.path.join(branding_dst, "Splash ReArtist Pro.png"))

    # 3. Subdirectories from AppDataFolder/REAPER
    subdirs = [
        "ColorThemes",
        "Data",
        "Docs",
        "Effects",
        "FXChains",
        "Grooves",
        "KeyMaps",
        "LangPack",
        "Licences",
        "MenuSets",
        "MIDINoteNames",
        "MouseMaps",
        "OSC",
        "presets",
        "ProjectTemplates",
        "ReaImGui",
        "ReaPack",
        "reaper_www_root",
        "Scripts",
        "TrackTemplates",
    ]

    for folder in subdirs:
        src = os.path.join(SRC_APP_DATA, folder)
        dst = os.path.join(ASSETS_DIR, folder)
        if os.path.exists(src):
            print(f"  -> {folder}...")
            safe_copy_tree(src, dst)

    # 4. UserPlugins extras
    userplugins_src = os.path.join(SRC_APP_DATA, "UserPlugins")
    userplugins_dst = os.path.join(ASSETS_DIR, "UserPlugins")
    for item in ["FX", "ReaKontrolConfig"]:
        src_item = os.path.join(userplugins_src, item)
        dst_item = os.path.join(userplugins_dst, item)
        if os.path.exists(src_item):
            print(f"  -> UserPlugins/{item}...")
            safe_copy_tree(src_item, dst_item)

    # 5. Bundle ReArtist Analog FX and Digital FX JSFX suites
    effects_dst = os.path.join(ASSETS_DIR, "Effects")
    for fx_suite in ["ReArtist Analog FX", "ReArtist Digital FX"]:
        src_fx = os.path.join(SRC_FLATPAK_EFFECTS, fx_suite)
        dst_fx = os.path.join(effects_dst, fx_suite)
        if os.path.exists(src_fx):
            print(f"  -> Bundling JSFX Suite: {fx_suite}...")
            safe_copy_tree(src_fx, dst_fx)

def sanitize_reaper_kb_ini():
    print("[*] Sanitizing reaper-kb.ini...")
    src_file = os.path.join(SRC_APP_DATA, "reaper-kb.ini")
    dst_file = os.path.join(CONFIG_TEMPLATES_DIR, "reaper-kb.ini")
    if not os.path.exists(src_file):
        return

    with open(src_file, "r", encoding="utf-8", errors="ignore") as f:
        lines = f.readlines()

    out_lines = []
    # Pattern to match and remove absolute Windows script paths
    win_prefix_pattern = re.compile(r'(\\\\?\\[a-zA-Z]:\\Users\\[^\\]+\\AppData\\Roaming\\REAPER\\Scripts\\|[a-zA-Z]:\\Users\\[^\\]+\\AppData\\Roaming\\REAPER\\Scripts\\)', re.IGNORECASE)

    for line in lines:
        if line.startswith("SCR "):
            line = win_prefix_pattern.sub("", line)
            parts = line.split('"', 4)
            if len(parts) >= 4:
                parts[3] = parts[3].replace("\\", "/")
                line = '"'.join(parts)
        out_lines.append(line)

    with open(dst_file, "w", encoding="utf-8") as f:
        f.writelines(out_lines)

def sanitize_keymaps():
    print("[*] Sanitizing KeyMaps...")
    keymaps_dir = os.path.join(ASSETS_DIR, "KeyMaps")
    if not os.path.exists(keymaps_dir):
        return

    win_prefix_pattern = re.compile(r'(\\\\?\\[a-zA-Z]:\\Users\\[^\\]+\\AppData\\Roaming\\REAPER\\Scripts\\|[a-zA-Z]:\\Users\\[^\\]+\\AppData\\Roaming\\REAPER\\Scripts\\)', re.IGNORECASE)

    for filename in os.listdir(keymaps_dir):
        if filename.endswith(".ReaperKeyMap"):
            fpath = os.path.join(keymaps_dir, filename)
            with open(fpath, "r", encoding="utf-8", errors="ignore") as f:
                lines = f.readlines()
            out_lines = []
            for line in lines:
                if line.startswith("SCR "):
                    line = win_prefix_pattern.sub("", line)
                    parts = line.split('"', 4)
                    if len(parts) >= 4:
                        parts[3] = parts[3].replace("\\", "/")
                        line = '"'.join(parts)
                out_lines.append(line)
            with open(fpath, "w", encoding="utf-8") as f:
                f.writelines(out_lines)

def sanitize_sws_autocoloricon_ini():
    print("[*] Sanitizing sws-autocoloricon.ini...")
    src_file = os.path.join(SRC_APP_DATA, "sws-autocoloricon.ini")
    dst_file = os.path.join(CONFIG_TEMPLATES_DIR, "sws-autocoloricon.ini")
    if not os.path.exists(src_file):
        return

    with open(src_file, "r", encoding="utf-8", errors="ignore") as f:
        content = f.read()

    # Convert Windows backslashes in track icon paths to Linux forward slashes
    content = content.replace("eduserra\\", "eduserra/")

    with open(dst_file, "w", encoding="utf-8") as f:
        f.write(content)

def sanitize_reaper_extstate():
    print("[*] Creating reaper-extstate.template.ini...")
    src_file = os.path.join(SRC_APP_DATA, "reaper-extstate.ini")
    dst_file = os.path.join(CONFIG_TEMPLATES_DIR, "reaper-extstate.template.ini")
    if not os.path.exists(src_file):
        return

    with open(src_file, "r", encoding="utf-8", errors="ignore") as f:
        content = f.read()

    # Replace hardcoded Windows Lokasenna path with template placeholder
    content = re.sub(r'lib_path_v2=[^\r\n]+', r'lib_path_v2={{REAPER_CONFIG_DIR}}/Scripts/ReaTeam Scripts/Development/Lokasenna_GUI v2/Library/', content)

    with open(dst_file, "w", encoding="utf-8") as f:
        f.write(content)

def sanitize_reaper_defpresets():
    print("[*] Sanitizing reaper-defpresets.ini...")
    src_file = os.path.join(SRC_APP_DATA, "reaper-defpresets.ini")
    dst_file = os.path.join(CONFIG_TEMPLATES_DIR, "reaper-defpresets.ini")
    if not os.path.exists(src_file):
        return

    with open(src_file, "r", encoding="utf-8", errors="ignore") as f:
        lines = f.readlines()

    out_lines = []
    for line in lines:
        if "=" in line and not line.startswith("["):
            k, v = line.split("=", 1)
            k = k.replace("\\", "/")
            out_lines.append(f"{k}={v}")
        else:
            out_lines.append(line)

    with open(dst_file, "w", encoding="utf-8") as f:
        f.writelines(out_lines)

def copy_config_inis():
    print("[*] Copying configuration INIs...")
    ini_files = [
        "BR.ini",
        "reapack.ini",
        "reaper-fxfolders.ini",
        "reaper-fxoptions.ini",
        "reaper-fxtags.ini",
        "reaper-menu.ini",
        "reaper-mouse.ini",
        "reaper-pinstates.ini",
        "reaper-recentfx.ini",
        "reaper-render.ini",
        "reaper-screensets.ini",
        "reaper-themeconfig.ini",
        "screensets.ini",
        "S&M.ini",
        "S&M_Cyclactions.ini",
        "S&M_Cyclactions_export.ini",
        "Xenakios_Commands.ini",
    ]

    for ini in ini_files:
        src = os.path.join(SRC_APP_DATA, ini)
        dst = os.path.join(CONFIG_TEMPLATES_DIR, ini)
        if os.path.exists(src):
            shutil.copy2(src, dst)

def sanitize_reaper_ini_template():
    print("[*] Creating reaper.template.ini...")
    src_file = os.path.join(SRC_APP_DATA, "REAPER.ini")
    dst_file = os.path.join(CONFIG_TEMPLATES_DIR, "reaper.template.ini")
    if not os.path.exists(src_file):
        return

    with open(src_file, "r", encoding="utf-8", errors="ignore") as f:
        lines = f.readlines()

    # We filter out Windows hardware/audio/path specific lines and add placeholders
    out_lines = []
    skip_sections = {"asiochan", "audioconfig"}
    cur_sec = None

    for line in lines:
        line_s = line.strip()
        if line_s.startswith("[") and line_s.endswith("]"):
            cur_sec = line_s[1:-1]
            if cur_sec in skip_sections:
                continue
            out_lines.append(line)
        else:
            if cur_sec in skip_sections:
                continue
            if "=" in line:
                k, v = line.split("=", 1)
                k_trim = k.strip()
                # Replace Windows paths with placeholders or skip machine-specific paths
                if k_trim == "lastthemefn5":
                    out_lines.append("lastthemefn5={{REAPER_CONFIG_DIR}}/ColorThemes/ReArtist 2.0 Pro.ReaperThemeZip\n")
                    continue
                elif k_trim == "splashimage":
                    out_lines.append("splashimage={{REAPER_CONFIG_DIR}}/Splash ReArtist Pro.png\n")
                    continue
                elif k_trim in ["altpeakspath", "lastmenusetdir", "lastscript", "lastrenderpath2", "lastrenderpath4", "vstpath64"]:
                    continue  # Let Linux REAPER use its default or user paths
                elif k_trim.startswith("asio_"):
                    continue
            out_lines.append(line)

    with open(dst_file, "w", encoding="utf-8") as f:
        f.writelines(out_lines)

def main():
    print("=== ReaFull: Preparing Clean, Sanitized Repository ===")
    copy_and_sanitize_assets()
    sanitize_reaper_kb_ini()
    sanitize_keymaps()
    sanitize_sws_autocoloricon_ini()
    sanitize_reaper_extstate()
    sanitize_reaper_defpresets()
    copy_config_inis()
    sanitize_reaper_ini_template()
    print("\n=== Repository assets prepared and sanitized! ===")

if __name__ == "__main__":
    main()
