#!/usr/bin/env python3
"""
ReaFull Installer for Linux REAPER
Author: Jules Martins (fearlesslymediagroup@gmail.com)
Repository: https://github.com/julesklord/ReaFull

Automates the complete installation, cross-platform path resolution,
and non-destructive configuration merging of the ReaFull production suite.
"""

import os
import sys
import shutil
import argparse
import subprocess
import re
from datetime import datetime

VERSION = "2025.1.0-linux"

ROOT_DIR = os.path.dirname(os.path.abspath(__file__))
ASSETS_DIR = os.path.join(ROOT_DIR, "assets")
CONFIG_TEMPLATES_DIR = os.path.join(ROOT_DIR, "config_templates")

# Color formatting helpers for terminal output
class Colors:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    BOLD = '\033[1m'
    ENDC = '\033[0m'

def log_info(msg):
    print(f"{Colors.BLUE}[*]{Colors.ENDC} {msg}")

def log_success(msg):
    print(f"{Colors.GREEN}[+]{Colors.ENDC} {msg}")

def log_warn(msg):
    print(f"{Colors.YELLOW}[!]{Colors.ENDC} {msg}")

def log_err(msg):
    print(f"{Colors.RED}[ERROR]{Colors.ENDC} {msg}")

def is_reaper_running():
    try:
        res = subprocess.run(["pgrep", "-x", "reaper"], capture_output=True, text=True)
        return res.returncode == 0
    except Exception:
        return False

def detect_reaper_dir():
    # Native default
    native_dir = os.path.expanduser("~/.config/REAPER")
    # Flatpak default
    flatpak_dir = os.path.expanduser("~/.var/app/fm.reaper.Reaper/config/REAPER")
    
    if os.path.exists(native_dir):
        return native_dir
    elif os.path.exists(flatpak_dir):
        return flatpak_dir
    return native_dir

def create_backup(target_dir, dry_run=False):
    if not os.path.exists(target_dir):
        log_info(f"Target directory {target_dir} does not exist yet. Creating it.")
        if not dry_run:
            os.makedirs(target_dir, exist_ok=True)
        return None

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_path = f"{target_dir}_backup_pre_reafull_{timestamp}"
    log_info(f"Creating backup of current REAPER configuration:\n    -> {backup_path}")
    if not dry_run:
        shutil.copytree(target_dir, backup_path, symlinks=True)
        log_success("Backup created successfully.")
    return backup_path

def install_fonts(dry_run=False):
    fonts_src = os.path.join(ASSETS_DIR, "Fonts")
    fonts_dst = os.path.expanduser("~/.local/share/fonts/ReArtist")
    
    if not os.path.exists(fonts_src):
        log_warn("Fonts folder not found in assets, skipping font installation.")
        return

    log_info("Installing required audio/UI fonts into ~/.local/share/fonts/ReArtist/...")
    if not dry_run:
        os.makedirs(fonts_dst, exist_ok=True)
        for font in os.listdir(fonts_src):
            src_f = os.path.join(fonts_src, font)
            dst_f = os.path.join(fonts_dst, font)
            if os.path.isfile(src_f):
                shutil.copy2(src_f, dst_f)
        subprocess.run(["fc-cache", "-f", fonts_dst], capture_output=True)
        log_success("Fonts installed and fontconfig cache refreshed.")

def safe_copy_tree(src_dir, dst_dir, dry_run=False):
    if dry_run:
        return
    os.makedirs(dst_dir, exist_ok=True)
    for root, dirs, files in os.walk(src_dir):
        rel_path = os.path.relpath(root, src_dir)
        target_dir = os.path.join(dst_dir, rel_path)
        os.makedirs(target_dir, exist_ok=True)
        for f in files:
            src_file = os.path.join(root, f)
            dst_file = os.path.join(target_dir, f)
            if os.path.islink(dst_file):
                continue
            try:
                shutil.copy2(src_file, dst_file)
            except Exception as e:
                log_warn(f"Notice copying {f}: {e}")

def deploy_assets(target_dir, dry_run=False):
    log_info(f"Deploying ReaFull assets to {target_dir}...")
    
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
        src = os.path.join(ASSETS_DIR, folder)
        dst = os.path.join(target_dir, folder)
        if os.path.exists(src):
            safe_copy_tree(src, dst, dry_run=dry_run)

    # UserPlugins
    userplugins_src = os.path.join(ASSETS_DIR, "UserPlugins")
    userplugins_dst = os.path.join(target_dir, "UserPlugins")
    if os.path.exists(userplugins_src):
        safe_copy_tree(userplugins_src, userplugins_dst, dry_run=dry_run)

    # Splash Image
    splash_src = os.path.join(ASSETS_DIR, "branding", "Splash ReArtist Pro.png")
    if os.path.exists(splash_src) and not dry_run:
        shutil.copy2(splash_src, os.path.join(target_dir, "Splash ReArtist Pro.png"))

    # Link native extension libraries if available on system
    if not dry_run:
        # SWS
        for sws_path in ["/usr/lib/sws/reaper_sws-x86_64.so", "/usr/lib/REAPER/Plugins/reaper_sws-x86_64.so"]:
            if os.path.exists(sws_path):
                link_dst = os.path.join(userplugins_dst, "reaper_sws-x86_64.so")
                if not os.path.exists(link_dst):
                    try:
                        os.symlink(sws_path, link_dst)
                    except Exception:
                        pass
                break
        
        # ReaPack
        for reapack_path in ["/usr/lib/REAPER/Plugins/reaper_reapack-x86_64.so", "/usr/lib/reapack/reaper_reapack-x86_64.so"]:
            if os.path.exists(reapack_path):
                link_dst = os.path.join(userplugins_dst, "reaper_reapack-x86_64.so")
                if not os.path.exists(link_dst):
                    try:
                        os.symlink(reapack_path, link_dst)
                    except Exception:
                        pass
                break

    log_success("All asset files, plugins, and templates deployed.")

def deploy_configurations(target_dir, dry_run=False):
    log_info("Configuring settings and applying cross-platform path resolution...")
    
    # 1. Direct INI copies from config_templates
    direct_inis = [
        "BR.ini",
        "reapack.ini",
        "reaper-defpresets.ini",
        "reaper-fxfolders.ini",
        "reaper-fxoptions.ini",
        "reaper-fxtags.ini",
        "reaper-kb.ini",
        "reaper-menu.ini",
        "reaper-mouse.ini",
        "reaper-pinstates.ini",
        "reaper-recentfx.ini",
        "reaper-render.ini",
        "reaper-screensets.ini",
        "reaper-themeconfig.ini",
        "screensets.ini",
        "sws-autocoloricon.ini",
        "Xenakios_Commands.ini",
    ]

    for ini in direct_inis:
        src = os.path.join(CONFIG_TEMPLATES_DIR, ini)
        dst = os.path.join(target_dir, ini)
        if os.path.exists(src) and not dry_run:
            shutil.copy2(src, dst)

    # 2. Process templates with variable expansion
    # reaper-extstate.template.ini
    extstate_tpl = os.path.join(CONFIG_TEMPLATES_DIR, "reaper-extstate.template.ini")
    extstate_dst = os.path.join(target_dir, "reaper-extstate.ini")
    if os.path.exists(extstate_tpl) and not dry_run:
        with open(extstate_tpl, "r", encoding="utf-8") as f:
            content = f.read()
        content = content.replace("{{REAPER_CONFIG_DIR}}", target_dir)
        with open(extstate_dst, "w", encoding="utf-8") as f:
            f.write(content)

    # S&M.template.ini
    sm_tpl = os.path.join(CONFIG_TEMPLATES_DIR, "S&M.template.ini")
    sm_dst = os.path.join(target_dir, "S&M.ini")
    if os.path.exists(sm_tpl) and not dry_run:
        with open(sm_tpl, "r", encoding="utf-8") as f:
            content = f.read()
        content = content.replace("{{REAPER_CONFIG_DIR}}", target_dir)
        with open(sm_dst, "w", encoding="utf-8") as f:
            f.write(content)

    # 3. Smart Merge of reaper.ini
    merge_reaper_ini(target_dir, dry_run=dry_run)
    log_success("Configurations applied cleanly.")

def merge_reaper_ini(target_dir, dry_run=False):
    cur_ini_path = os.path.join(target_dir, "reaper.ini")
    tpl_ini_path = os.path.join(CONFIG_TEMPLATES_DIR, "reaper.template.ini")

    if not os.path.exists(tpl_ini_path) or dry_run:
        return

    def parse_ini(filepath):
        sections = {}
        cur_sec = None
        if not os.path.exists(filepath):
            return sections
        with open(filepath, "r", encoding="utf-8", errors="ignore") as f:
            for line in f:
                line_s = line.strip()
                if line_s.startswith("[") and line_s.endswith("]"):
                    cur_sec = line_s[1:-1]
                    if cur_sec not in sections:
                        sections[cur_sec] = []
                elif cur_sec is not None:
                    sections[cur_sec].append(line)
        return sections

    cur_sections = parse_ini(cur_ini_path)
    tpl_sections = parse_ini(tpl_ini_path)

    # Keys to protect and preserve unconditionally from current Linux installation
    linux_keys_to_preserve = {
        "alsa_indev",
        "alsa_outdev",
        "alsa_rtprio",
        "jack_launchcmd",
        "jack_rtprio",
        "linux_audio_bits",
        "linux_audio_bsize",
        "linux_audio_bufs",
        "linux_audio_nch_in",
        "linux_audio_nch_out",
        "linux_audio_srate",
        "linux_audio_srateor",
        "linux_auto_pasuspend",
        "linux_disable_pm",
        "linux_mlockall",
        "hasrecentsec",
        "nag",
        "lastproject",
        "lastprojuiref",
        "projecttab1",
        "projecttab2",
        "projecttab3",
        "projecttabs",
        "pspage_last",
        "prefs_x",
        "prefs_y",
        "wnd_h",
        "wnd_w",
        "wnd_x",
        "wnd_y",
        "wnd_state",
    }

    preserved_kvs = {}
    if "reaper" in cur_sections:
        for line in cur_sections["reaper"]:
            if "=" in line:
                k, v = line.split("=", 1)
                k_trim = k.strip()
                if k_trim in linux_keys_to_preserve:
                    preserved_kvs[k_trim] = v.strip()

    preserved_sections = {}
    for sec_name in [".swell", ".swell_recent_path", "Recent", "RecentFX", "reaper_video"]:
        if sec_name in cur_sections:
            preserved_sections[sec_name] = cur_sections[sec_name]

    # Build merged [reaper] section
    merged_reaper_lines = []
    seen_reaper_keys = set()

    if "reaper" in tpl_sections:
        for line in tpl_sections["reaper"]:
            if "=" in line:
                k, v = line.split("=", 1)
                k_trim = k.strip()
                if k_trim in preserved_kvs:
                    merged_reaper_lines.append(f"{k_trim}={preserved_kvs[k_trim]}\n")
                    seen_reaper_keys.add(k_trim)
                elif k_trim == "lastthemefn5":
                    theme_path = os.path.join(target_dir, "ColorThemes/ReArtist 2.0 Pro.ReaperThemeZip")
                    merged_reaper_lines.append(f"lastthemefn5={theme_path}\n")
                    seen_reaper_keys.add(k_trim)
                elif k_trim == "splashimage":
                    splash_path = os.path.join(target_dir, "Splash ReArtist Pro.png")
                    merged_reaper_lines.append(f"splashimage={splash_path}\n")
                    seen_reaper_keys.add(k_trim)
                else:
                    merged_reaper_lines.append(line)
                    seen_reaper_keys.add(k_trim)
            else:
                merged_reaper_lines.append(line)

    for k, v in preserved_kvs.items():
        if k not in seen_reaper_keys:
            merged_reaper_lines.append(f"{k}={v}\n")

    if "lastthemefn5" not in seen_reaper_keys:
        merged_reaper_lines.append(f"lastthemefn5={os.path.join(target_dir, 'ColorThemes/ReArtist 2.0 Pro.ReaperThemeZip')}\n")
    if "splashimage" not in seen_reaper_keys:
        merged_reaper_lines.append(f"splashimage={os.path.join(target_dir, 'Splash ReArtist Pro.png')}\n")

    # Write merged reaper.ini
    with open(cur_ini_path, "w", encoding="utf-8") as f:
        # Swell sections first
        for sec in [".swell", ".swell_recent_path"]:
            if sec in preserved_sections:
                f.write(f"[{sec}]\n")
                f.writelines(preserved_sections[sec])
                if not preserved_sections[sec] or not preserved_sections[sec][-1].endswith("\n"):
                    f.write("\n")

        # Main [reaper]
        f.write("[reaper]\n")
        f.writelines(merged_reaper_lines)
        if not merged_reaper_lines or not merged_reaper_lines[-1].endswith("\n"):
            f.write("\n")

        # Other template sections
        for sec, lines in tpl_sections.items():
            if sec not in ["reaper", ".swell", ".swell_recent_path", "Recent", "RecentFX", "reaper_video"]:
                f.write(f"[{sec}]\n")
                f.writelines(lines)
                if not lines or not lines[-1].endswith("\n"):
                    f.write("\n")

        # Preserved recent sections
        for sec in ["Recent", "RecentFX", "reaper_video"]:
            if sec in preserved_sections:
                f.write(f"[{sec}]\n")
                f.writelines(preserved_sections[sec])
                if not preserved_sections[sec] or not preserved_sections[sec][-1].endswith("\n"):
                    f.write("\n")

def main():
    parser = argparse.ArgumentParser(description="ReaFull Linux Installer for REAPER")
    parser.add_argument("--target", type=str, default=None, help="Target REAPER config directory (default: auto-detected)")
    parser.add_argument("--no-backup", action="store_true", help="Skip creating a pre-installation backup")
    parser.add_argument("--no-fonts", action="store_true", help="Skip font installation")
    parser.add_argument("--dry-run", action="store_true", help="Simulate installation without writing files")
    parser.add_argument("--quiet", "-q", action="store_true", help="Non-interactive mode")
    parser.add_argument("--version", "-v", action="version", version=f"ReaFull Installer {VERSION}")

    args = parser.parse_args()

    target_dir = args.target or detect_reaper_dir()

    print(f"{Colors.BOLD}{Colors.CYAN}======================================================{Colors.ENDC}")
    print(f"{Colors.BOLD}{Colors.CYAN}          ReaFull Suite Installer for Linux           {Colors.ENDC}")
    print(f"{Colors.BOLD}{Colors.CYAN}======================================================{Colors.ENDC}")
    print(f"Target Directory : {Colors.BOLD}{target_dir}{Colors.ENDC}")
    print(f"Mode             : {'DRY RUN' if args.dry_run else 'INSTALL'}")
    print("------------------------------------------------------")

    if is_reaper_running():
        log_warn("REAPER is currently running.")
        if not args.quiet:
            print(f"{Colors.YELLOW}Important: REAPER must be closed to properly apply configurations.{Colors.ENDC}")
            ans = input("Do you want to proceed anyway? [y/N]: ").strip().lower()
            if ans not in ['y', 'yes', 's', 'si']:
                print("Aborted. Please save your projects, close REAPER and run again.")
                sys.exit(0)

    if not args.no_backup:
        create_backup(target_dir, dry_run=args.dry_run)

    if not args.no_fonts:
        install_fonts(dry_run=args.dry_run)

    deploy_assets(target_dir, dry_run=args.dry_run)
    deploy_configurations(target_dir, dry_run=args.dry_run)

    print(f"\n{Colors.BOLD}{Colors.GREEN}======================================================{Colors.ENDC}")
    print(f"{Colors.BOLD}{Colors.GREEN}  ReaFull Installation Completed Successfully!        {Colors.ENDC}")
    print(f"{Colors.BOLD}{Colors.GREEN}======================================================{Colors.ENDC}")
    print(f"\n{Colors.CYAN}Start REAPER now to enjoy your new ReaFull environment.{Colors.ENDC}\n")

if __name__ == "__main__":
    main()
