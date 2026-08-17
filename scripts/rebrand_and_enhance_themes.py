#!/usr/bin/env python3
"""
ReaFull Theme Customizer & Enhancer.
Applies subtle signature styling (modern cyan/amber studio palette, playhead,
time selection, markers, fonts, and clean ReaFull naming) to the 4 themes.
"""

import os
import shutil
import zipfile
import tempfile
import re

THEMES_DIR = "/mnt/DEV/projects/repos/julesklord/ReaFull/assets/ColorThemes"

# Windows COLORREF is 0x00BBGGRR -> R + (G << 8) + (B << 16)
def rgb_to_reaper(r, g, b):
    return r + (g << 8) + (b << 16)

# Signature ReaFull Color Palette
REAFULL_CYAN = rgb_to_reaper(0, 212, 255)         # Electric Cyan (Playhead / Active Marker)
REAFULL_AMBER = rgb_to_reaper(245, 166, 35)       # Warm Studio Amber (Regions / Accents)
REAFULL_CURSOR = rgb_to_reaper(225, 245, 255)      # Crisp Ice Blue Cursor
REAFULL_GRID = rgb_to_reaper(45, 48, 54)           # Refined subtle dark grid

THEME_SPECS = [
    {
        "zip_name": "ReaFull Pro.ReaperThemeZip",
        "theme_name": "ReaFull Pro",
        "old_theme_name": "ReArtist 2.0 Pro",
        "cursor_color": REAFULL_CYAN,
        "region_color": REAFULL_AMBER,
        "grid_v": rgb_to_reaper(48, 52, 60),
    },
    {
        "zip_name": "ReaFull Dark.ReaperThemeZip",
        "theme_name": "ReaFull Dark",
        "old_theme_name": "ReArtist 2.0 Dark",
        "cursor_color": REAFULL_CYAN,
        "region_color": REAFULL_AMBER,
        "grid_v": rgb_to_reaper(35, 38, 44),
    },
    {
        "zip_name": "ReaFull Gray.ReaperThemeZip",
        "theme_name": "ReaFull Gray",
        "old_theme_name": "ReArtist 2.0 Gray",
        "cursor_color": REAFULL_CYAN,
        "region_color": REAFULL_AMBER,
        "grid_v": rgb_to_reaper(60, 64, 72),
    },
    {
        "zip_name": "ReaFull Light.ReaperThemeZip",
        "theme_name": "ReaFull Light",
        "old_theme_name": "ReArtist 2.0 Light",
        "cursor_color": rgb_to_reaper(0, 150, 200),
        "region_color": rgb_to_reaper(210, 120, 20),
        "grid_v": rgb_to_reaper(200, 204, 210),
    },
]

def enhance_theme_file(content, spec):
    lines = content.splitlines()
    out_lines = []
    
    # Track keys to update
    keys_to_set = {
        "ui_img": spec["theme_name"],
        "playcursor_color": str(spec["cursor_color"]),
        "col_cursor": str(REAFULL_CURSOR),
        "col_cursor2": str(spec["cursor_color"]),
        "col_marker": str(spec["cursor_color"]),
        "col_region": str(spec["region_color"]),
        "arrange_vgrid": str(spec["grid_v"]),
    }
    seen_keys = set()

    for line in lines:
        if "=" in line:
            k, v = line.split("=", 1)
            k_trim = k.strip()
            if k_trim in keys_to_set:
                out_lines.append(f"{k_trim}={keys_to_set[k_trim]}")
                seen_keys.add(k_trim)
            else:
                out_lines.append(line)
        else:
            out_lines.append(line)

    for k, v in keys_to_set.items():
        if k not in seen_keys:
            out_lines.append(f"{k}={v}")

    return "\n".join(out_lines) + "\n"

def enhance_rtconfig(content, spec):
    lines = content.splitlines()
    out_lines = []
    
    for line in lines:
        if line.strip().startswith("adjuster_script"):
            out_lines.append('adjuster_script "ReaFull_theme_adjuster.lua"')
        elif "ReArtist" in line and not line.strip().startswith(";"):
            out_lines.append(line.replace("ReArtist", "ReaFull"))
        else:
            out_lines.append(line)

    return "\n".join(out_lines) + "\n"

def process_theme(spec):
    zip_path = os.path.join(THEMES_DIR, spec["zip_name"])
    if not os.path.exists(zip_path):
        print(f"[!] Theme zip not found: {zip_path}")
        return

    print(f"[*] Enhancing theme: {spec['theme_name']}...")
    temp_dir = tempfile.mkdtemp(prefix="reafull_theme_")
    
    try:
        # 1. Unzip
        with zipfile.ZipFile(zip_path, 'r') as zf:
            zf.extractall(temp_dir)

        # 2. Find and rename .ReaperTheme file
        old_theme_fn = None
        for f in os.listdir(temp_dir):
            if f.endswith(".ReaperTheme"):
                old_theme_fn = f
                break

        if not old_theme_fn:
            print(f"[!] No .ReaperTheme found inside {spec['zip_name']}")
            return

        old_theme_path = os.path.join(temp_dir, old_theme_fn)
        new_theme_path = os.path.join(temp_dir, f"{spec['theme_name']}.ReaperTheme")

        with open(old_theme_path, "r", encoding="utf-8", errors="ignore") as tf:
            theme_content = tf.read()

        enhanced_theme_content = enhance_theme_file(theme_content, spec)
        
        with open(new_theme_path, "w", encoding="utf-8") as tf:
            tf.write(enhanced_theme_content)

        if old_theme_path != new_theme_path and os.path.exists(old_theme_path):
            os.remove(old_theme_path)

        # 3. Rename image folder if needed
        old_folder_path = os.path.join(temp_dir, spec["old_theme_name"])
        new_folder_path = os.path.join(temp_dir, spec["theme_name"])
        
        if os.path.exists(old_folder_path) and old_folder_path != new_folder_path:
            shutil.move(old_folder_path, new_folder_path)

        # 4. Enhance rtconfig.txt inside image folder
        rtconfig_path = os.path.join(new_folder_path, "rtconfig.txt")
        if os.path.exists(rtconfig_path):
            with open(rtconfig_path, "r", encoding="utf-8", errors="ignore") as rtf:
                rt_content = rtf.read()
            enhanced_rt_content = enhance_rtconfig(rt_content, spec)
            with open(rtconfig_path, "w", encoding="utf-8") as rtf:
                rtf.write(enhanced_rt_content)

        # 5. Re-pack as .ReaperThemeZip
        backup_zip = zip_path + ".bak"
        shutil.move(zip_path, backup_zip)

        with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED) as new_zf:
            for root, _, files in os.walk(temp_dir):
                for f in files:
                    fp = os.path.join(root, f)
                    arcname = os.path.relpath(fp, temp_dir)
                    new_zf.write(fp, arcname)

        if os.path.exists(backup_zip):
            os.remove(backup_zip)

        print(f"[+] {spec['theme_name']} enhanced and repackaged successfully.")

    finally:
        shutil.rmtree(temp_dir, ignore_errors=True)

def setup_theme_adjuster():
    scripts_cockos = "/mnt/DEV/projects/repos/julesklord/ReaFull/assets/Scripts/Cockos"
    old_adj = os.path.join(scripts_cockos, "ReArtist_theme_adjuster.lua")
    new_adj = os.path.join(scripts_cockos, "ReaFull_theme_adjuster.lua")
    
    if os.path.exists(old_adj) and not os.path.exists(new_adj):
        with open(old_adj, "r", encoding="utf-8", errors="ignore") as f:
            content = f.read()
        content = content.replace("ReArtist", "ReaFull")
        with open(new_adj, "w", encoding="utf-8") as f:
            f.write(content)
        print("[+] ReaFull_theme_adjuster.lua created in Scripts/Cockos/.")

if __name__ == "__main__":
    for spec in THEME_SPECS:
        process_theme(spec)
    setup_theme_adjuster()
    print("\n[+] All ReaFull themes enhanced with custom signature styling!")
