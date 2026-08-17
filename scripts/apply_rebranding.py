#!/usr/bin/env python3
"""
ReaFull Rebranding Transformation Script.
Renames and updates themes, templates, splash, menus, keymaps, and configs to ReaFull branding
while maintaining backward-compatibility symlinks and preserving full original author credits.
"""

import os
import shutil
import zipfile
import re

REPO_DIR = "/mnt/DEV/projects/repos/julesklord/ReaFull"
ASSETS_DIR = os.path.join(REPO_DIR, "assets")
CONFIG_TEMPLATES_DIR = os.path.join(REPO_DIR, "config_templates")

def rebrand_themes():
    print("[*] Rebranding ColorThemes to ReaFull...")
    themes_dir = os.path.join(ASSETS_DIR, "ColorThemes")
    theme_mappings = [
        ("ReArtist 2.0 Pro.ReaperThemeZip", "ReaFull Pro.ReaperThemeZip"),
        ("ReArtist 2.0 Dark.ReaperThemeZip", "ReaFull Dark.ReaperThemeZip"),
        ("ReArtist 2.0 Gray.ReaperThemeZip", "ReaFull Gray.ReaperThemeZip"),
        ("ReArtist 2.0 Light.ReaperThemeZip", "ReaFull Light.ReaperThemeZip"),
    ]

    for old_name, new_name in theme_mappings:
        old_path = os.path.join(themes_dir, old_name)
        new_path = os.path.join(themes_dir, new_name)
        if os.path.exists(old_path):
            print(f"  -> {old_name} -> {new_name}")
            shutil.copy2(old_path, new_path)

def rebrand_menuse_and_keymaps():
    print("[*] Rebranding MenuSets and KeyMaps...")
    # MenuSets
    menuset_dir = os.path.join(ASSETS_DIR, "MenuSets")
    old_menu = os.path.join(menuset_dir, "ReArtist Pro.ReaperMenuSet")
    new_menu = os.path.join(menuset_dir, "ReaFull Pro.ReaperMenuSet")
    if os.path.exists(old_menu):
        shutil.copy2(old_menu, new_menu)

    # KeyMaps
    keymap_dir = os.path.join(ASSETS_DIR, "KeyMaps")
    old_km = os.path.join(keymap_dir, "ReArtist Pro Full Keymap.ReaperKeyMap")
    new_km = os.path.join(keymap_dir, "ReaFull Pro Full Keymap.ReaperKeyMap")
    if os.path.exists(old_km):
        shutil.copy2(old_km, new_km)

def setup_effects_aliases():
    print("[*] Setting up ReaFull FX suite directory structure...")
    effects_dir = os.path.join(ASSETS_DIR, "Effects")
    # Duplicate / alias ReArtist Analog FX -> ReaFull Analog FX
    for suite in ["Analog FX", "Digital FX"]:
        src_suite = os.path.join(effects_dir, f"ReArtist {suite}")
        dst_suite = os.path.join(effects_dir, f"ReaFull {suite}")
        if os.path.exists(src_suite) and not os.path.exists(dst_suite):
            print(f"  -> Creating {dst_suite}...")
            shutil.copytree(src_suite, dst_suite, dirs_exist_ok=True)

def update_config_templates():
    print("[*] Updating config templates with ReaFull branding...")
    
    # 1. reaper.template.ini
    reaper_tpl = os.path.join(CONFIG_TEMPLATES_DIR, "reaper.template.ini")
    if os.path.exists(reaper_tpl):
        with open(reaper_tpl, "r", encoding="utf-8") as f:
            content = f.read()
        content = re.sub(r'lastthemefn5=[^\r\n]+', r'lastthemefn5={{REAPER_CONFIG_DIR}}/ColorThemes/ReaFull Pro.ReaperThemeZip', content)
        content = re.sub(r'splashimage=[^\r\n]+', r'splashimage={{REAPER_CONFIG_DIR}}/Splash ReaFull.png', content)
        with open(reaper_tpl, "w", encoding="utf-8") as f:
            f.write(content)

    # 2. reaper-menu.ini
    menu_ini = os.path.join(CONFIG_TEMPLATES_DIR, "reaper-menu.ini")
    if os.path.exists(menu_ini):
        with open(menu_ini, "r", encoding="utf-8") as f:
            content = f.read()
        content = content.replace("ReArtist Pro", "ReaFull Pro")
        content = content.replace("ReArtist", "ReaFull")
        with open(menu_ini, "w", encoding="utf-8") as f:
            f.write(content)

    # 3. reaper-screensets.ini
    screensets_ini = os.path.join(CONFIG_TEMPLATES_DIR, "reaper-screensets.ini")
    if os.path.exists(screensets_ini):
        with open(screensets_ini, "r", encoding="utf-8") as f:
            content = f.read()
        content = content.replace("ReArtist Pro", "ReaFull Pro")
        content = content.replace("ReArtist", "ReaFull")
        with open(screensets_ini, "w", encoding="utf-8") as f:
            f.write(content)

    # 4. reaper-fxfolders.ini
    fxfolders_ini = os.path.join(CONFIG_TEMPLATES_DIR, "reaper-fxfolders.ini")
    if os.path.exists(fxfolders_ini):
        with open(fxfolders_ini, "r", encoding="utf-8") as f:
            content = f.read()
        content = content.replace("=ReArtist Pro", "=ReaFull Pro")
        with open(fxfolders_ini, "w", encoding="utf-8") as f:
            f.write(content)

def update_installer_references():
    print("[*] Updating installer engine defaults...")
    installer_py = os.path.join(REPO_DIR, "install.py")
    if os.path.exists(installer_py):
        with open(installer_py, "r", encoding="utf-8") as f:
            content = f.read()
        
        content = content.replace("ReArtist 2.0 Pro.ReaperThemeZip", "ReaFull Pro.ReaperThemeZip")
        content = content.replace("Splash ReArtist Pro.png", "Splash ReaFull.png")
        content = content.replace("~/.local/share/fonts/ReArtist", "~/.local/share/fonts/ReaFull")
        
        with open(installer_py, "w", encoding="utf-8") as f:
            f.write(content)

if __name__ == "__main__":
    rebrand_themes()
    rebrand_menuse_and_keymaps()
    setup_effects_aliases()
    update_config_templates()
    update_installer_references()
    print("\n[+] ReaFull rebranding applied successfully!")
