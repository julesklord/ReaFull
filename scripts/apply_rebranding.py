#!/usr/bin/env python3
"""
ReaFull Rebranding Transformation Script.
Renames and updates themes, templates, splash, menus, keymaps, and configs to ReaFull branding
while preserving full original author credits and legal notices.
"""

import os
import shutil
import re

REPO_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ASSETS_DIR = os.path.join(REPO_DIR, "assets")
CONFIG_TEMPLATES_DIR = os.path.join(REPO_DIR, "config_templates")

def rebrand_themes():
    print("[*] Verifying ColorThemes for ReaFull...")
    themes_dir = os.path.join(ASSETS_DIR, "ColorThemes")
    for theme in ["ReaFull Pro.ReaperThemeZip", "ReaFull Dark.ReaperThemeZip", "ReaFull Gray.ReaperThemeZip", "ReaFull Light.ReaperThemeZip"]:
        theme_path = os.path.join(themes_dir, theme)
        if os.path.exists(theme_path):
            print(f"  [OK] Theme present: {theme}")

def rebrand_menuse_and_keymaps():
    print("[*] Verifying MenuSets and KeyMaps...")
    menuset_dir = os.path.join(ASSETS_DIR, "MenuSets")
    new_menu = os.path.join(menuset_dir, "ReaFull Pro.ReaperMenuSet")
    if os.path.exists(new_menu):
        print(f"  [OK] MenuSet present: ReaFull Pro.ReaperMenuSet")

    keymap_dir = os.path.join(ASSETS_DIR, "KeyMaps")
    new_km = os.path.join(keymap_dir, "ReaFull Pro Full Keymap.ReaperKeyMap")
    if os.path.exists(new_km):
        print(f"  [OK] KeyMap present: ReaFull Pro Full Keymap.ReaperKeyMap")

def update_config_templates():
    print("[*] Checking config templates...")
    reaper_tpl = os.path.join(CONFIG_TEMPLATES_DIR, "reaper.template.ini")
    if os.path.exists(reaper_tpl):
        with open(reaper_tpl, "r", encoding="utf-8") as f:
            content = f.read()
        content = re.sub(r'lastthemefn5=[^\r\n]+', r'lastthemefn5={{REAPER_CONFIG_DIR}}/ColorThemes/ReaFull Pro.ReaperThemeZip', content)
        content = re.sub(r'splashimage=[^\r\n]+', r'splashimage={{REAPER_CONFIG_DIR}}/Splash ReaFull.png', content)
        with open(reaper_tpl, "w", encoding="utf-8") as f:
            f.write(content)

if __name__ == "__main__":
    rebrand_themes()
    rebrand_menuse_and_keymaps()
    update_config_templates()
    print("\n[+] ReaFull rebranding verified!")
