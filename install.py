#!/usr/bin/env python3
"""
ReaFull: Production, Mixing & Mastering Suite Installer for Linux REAPER
Author: Jules Martins (fearlesslymediagroup@gmail.com)
Repository: https://github.com/julesklord/ReaFull

Features:
- Interactive modular component selector
- Non-destructive configuration merge & full automated backup creation
- Intelligent ReaPack repository merge (preserves existing user remotes)
- Preserves existing keyboard shortcuts, mouse maps, and custom menus in Overlay mode
- Audio engine hardware & thread auto-tuning (PipeWire / ALSA Realtime, HQ Sinc)
- Comprehensive post-installation health verification
"""

import os
import sys
import shutil
import argparse
import subprocess
import re
import time
import hashlib
import platform
import tempfile
import urllib.request
import tarfile
from datetime import datetime

VERSION = "2026.3.0"
ASSETS_RELEASE_URL = f"https://github.com/julesklord/ReaFull/releases/download/v{VERSION}/reafull-assets-v{VERSION}.tar.gz"

KNOWN_HASHES = {
    "reafull-assets-v2026.3.0.tar.gz": "17019271a743534111384cc0c0dfd835ed61d5dec57e408e650fc7232f2d12c3",
    "sws_x86_64": "4cf0629aeeff346c1ed9a355ce826febfacf9775bd6f49f09b1b4f9f053b8644",
    "sws_aarch64": "615b66ae9e38e01aabb2e5e2a21fb0ffe3c1bab9587c1a2620f62c6e80e9a409",
    "reapack_x86_64": "35d80f63d8174c964af589c7d87c4728aa18f06899dce873e33f8d552d1bc7e0",
    "reapack_aarch64": "fa833c2e3367760c4103457ae2dd10bbd84543e80f6750bd695dd4f2e60fa2a3",
}

ROOT_DIR = os.path.dirname(os.path.abspath(__file__))
ASSETS_DIR = os.path.join(ROOT_DIR, "assets")
CONFIG_TEMPLATES_DIR = os.path.join(ROOT_DIR, "config_templates")

def safe_extract_tar(tar_path, dest_dir):
    """
    Safely extracts a tar file, preventing path traversal attacks,
    absolute path escapes, and links escaping the destination directory.
    """
    dest_dir = os.path.abspath(dest_dir)
    os.makedirs(dest_dir, exist_ok=True)
    with tarfile.open(tar_path, "r:*") as tar:
        for member in tar.getmembers():
            target_path = os.path.abspath(os.path.join(dest_dir, member.name))
            if os.path.commonpath([dest_dir, target_path]) != dest_dir:
                raise ValueError(f"Security error: Tar member escapes destination: {member.name}")
            if member.islnk() or member.issym():
                link_target = os.path.abspath(os.path.join(os.path.dirname(target_path), member.linkname))
                if os.path.commonpath([dest_dir, link_target]) != dest_dir:
                    raise ValueError(f"Security error: Tar link target escapes destination: {member.name} -> {member.linkname}")
        tar.extractall(path=dest_dir)

def download_and_verify(url, target_path, expected_sha256=None, logger=None, quiet=False):
    """
    Downloads a file to a temporary file, computes SHA-256 integrity hash,
    validates against expected_sha256 if provided, and atomically moves to target_path.
    """
    if not expected_sha256:
        err_msg = f"No checksum configured for {os.path.basename(target_path)}; refusing unverified download."
        if logger:
            logger.error(err_msg)
        elif not quiet:
            print(f"\033[91m[ERROR] {err_msg}\033[0m")
        return False

    target_dir = os.path.dirname(os.path.abspath(target_path))
    os.makedirs(target_dir, exist_ok=True)

    tmp_fd, tmp_file = tempfile.mkstemp(dir=target_dir, prefix=".reafull_dl_")
    os.close(tmp_fd)

    sha256_hash = hashlib.sha256()
    req = urllib.request.Request(url, headers={"User-Agent": f"ReaFull-Installer/{VERSION}"})

    try:
        with urllib.request.urlopen(req, timeout=30) as response, open(tmp_file, "wb") as out_f:
            total_size = int(response.headers.get("Content-Length", 0))
            downloaded = 0
            block_size = 65536
            while True:
                chunk = response.read(block_size)
                if not chunk:
                    break
                out_f.write(chunk)
                sha256_hash.update(chunk)
                downloaded += len(chunk)
                if not quiet and sys.stdout.isatty() and total_size > 0:
                    pct = int(downloaded * 100 / total_size)
                    mb = downloaded / (1024 * 1024)
                    tot_mb = total_size / (1024 * 1024)
                    sys.stdout.write(f"\r  -> Downloading {os.path.basename(target_path)}: {pct}% [{mb:.1f} MB / {tot_mb:.1f} MB] ")
                    sys.stdout.flush()
        if not quiet and sys.stdout.isatty():
            sys.stdout.write("\n")
            sys.stdout.flush()

        calculated_hash = sha256_hash.hexdigest()
        if expected_sha256 and calculated_hash.lower() != expected_sha256.lower():
            if os.path.exists(tmp_file):
                os.remove(tmp_file)
            err_msg = f"Checksum mismatch for {os.path.basename(target_path)}! Expected {expected_sha256}, got {calculated_hash}"
            if logger:
                logger.error(err_msg)
            elif not quiet:
                print(f"\033[91m[ERROR] {err_msg}\033[0m")
            return False

        os.replace(tmp_file, target_path)
        return True
    except Exception as e:
        if os.path.exists(tmp_file):
            os.remove(tmp_file)
        err_msg = f"Download failed for {url}: {e}"
        if logger:
            logger.error(err_msg)
        elif not quiet:
            print(f"\033[91m[ERROR] {err_msg}\033[0m")
        return False

def ensure_assets_available(custom_assets_dir=None, quiet=False):
    global ASSETS_DIR
    if custom_assets_dir and os.path.exists(custom_assets_dir):
        ASSETS_DIR = custom_assets_dir
        return True

    if os.path.exists(ASSETS_DIR) and os.path.exists(os.path.join(ASSETS_DIR, "Effects")):
        return True

    cache_dir = os.path.expanduser("~/.cache/reafull")
    cache_assets = os.path.join(cache_dir, "assets")
    if os.path.exists(cache_assets) and os.path.exists(os.path.join(cache_assets, "Effects")):
        ASSETS_DIR = cache_assets
        return True

    if not quiet:
        print(f"\n\033[1m\033[96m[*] Descargando componentes de estudio ReaFull (GitHub CDN)...\033[0m")

    os.makedirs(cache_dir, exist_ok=True)
    tar_path = os.path.join(cache_dir, f"reafull-assets-v{VERSION}.tar.gz")

    if not download_and_verify(ASSETS_RELEASE_URL, tar_path, expected_sha256=KNOWN_HASHES.get(f"reafull-assets-v{VERSION}.tar.gz"), quiet=quiet):
        return False

    try:
        if not quiet:
            print(f"  -> Descomprimiendo suites JSFX, temas y plantillas con validación de rutas...")
        safe_extract_tar(tar_path, cache_dir)
        ASSETS_DIR = cache_assets
        if not quiet:
            print(f"\033[92m[OK] Componentes de audio listos.\033[0m\n")
        return True
    except Exception as e:
        if not quiet:
            print(f"\n\033[91m[ERROR] No se pudieron extraer los assets: {e}\033[0m")
        return False

# Color formatting helpers for terminal output
class Colors:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    BOLD = '\033[1m'
    DIM = '\033[2m'
    ENDC = '\033[0m'

# Modular Component Definitions
COMPONENTS = {
    "themes": {
        "name": "Visual Themes & Splash Screen",
        "desc": "ReaFull Pro, Dark, Gray, Light themes and splash screen",
        "folders": [("ColorThemes", "ColorThemes"), ("branding/Splash ReaFull.png", "Splash ReaFull.png")],
        "inis": ["reaper-themeconfig.ini"],
        "default": True
    },
    "analog_fx": {
        "name": "ReaFull Analog FX Suite (JSFX)",
        "desc": "Analog emulations (SolidBus, DisTres-C, Pulse-EQ, Tape, Tube-Pre, FET-76, Summing)",
        "folders": [("Effects/ReaFull Analog FX", "Effects/ReaFull Analog FX")],
        "inis": [],
        "default": True
    },
    "digital_fx": {
        "name": "ReaFull Digital FX Suite (JSFX)",
        "desc": "Digital processing (D-DynEQ, D-MSComp, D-Meter LUFS, Reflex 1/2/3 Reverbs, T-FFT)",
        "folders": [("Effects/ReaFull Digital FX", "Effects/ReaFull Digital FX")],
        "inis": [],
        "default": True
    },
    "community_fx": {
        "name": "Community FX Suites (Saike, Sonic Anomaly, Tilr)",
        "desc": "Integrated and optimized community tools",
        "folders": [
            ("Effects/Saike Tools", "Effects/Saike Tools"),
            ("Effects/Sonic Anomaly", "Effects/Sonic Anomaly"),
            ("Effects/tilr", "Effects/tilr"),
            ("Effects/Liteon", "Effects/Liteon"),
            ("Effects/LOSER", "Effects/LOSER"),
            ("Effects/stillwell", "Effects/stillwell"),
            ("Effects/Mawi", "Effects/Mawi"),
            ("Effects/Schwa", "Effects/Schwa"),
        ],
        "inis": [],
        "default": True
    },
    "templates": {
        "name": "Track & Project Templates",
        "desc": "17 TrackTemplate categories (Drums, Vocals, Guitars, Master) and ProjectTemplates",
        "folders": [("TrackTemplates", "TrackTemplates"), ("ProjectTemplates", "ProjectTemplates")],
        "inis": [],
        "default": True
    },
    "sws_autocolor": {
        "name": "SWS AutoColor, Icons & Data",
        "desc": "310+ auto-color rules, track icons, HiDPI toolbar icons",
        "folders": [("Data", "Data")],
        "inis": ["sws-autocoloricon.ini", "S&M.template.ini", "S&M_Cyclactions.ini"],
        "default": True
    },
    "menus_toolbars": {
        "name": "Menus, Toolbars & Screensets",
        "desc": "Custom floating toolbars, keyboard shortcuts, and workspaces",
        "folders": [("MenuSets", "MenuSets"), ("KeyMaps", "KeyMaps"), ("MouseMaps", "MouseMaps"), ("OSC", "OSC")],
        "inis": ["reaper-menu.ini", "reaper-screensets.ini", "screensets.ini", "reaper-kb.ini", "reaper-mouse.ini", "reaper-fxfolders.ini"],
        "default": True
    },
    "scripts": {
        "name": "ReaScripts Suite",
        "desc": "FTC Tools, HeDa Track Inspector 2, Lokasenna GUI v2, Zaibuyidao, ReaFull Manager",
        "folders": [("Scripts", "Scripts"), ("ReaPack", "ReaPack"), ("reaper_www_root", "reaper_www_root")],
        "inis": ["reaper-extstate.template.ini", "reapack.ini"],
        "default": True
    },
    "presets": {
        "name": "Presets & FXChains",
        "desc": "Factory analog and digital presets, mastering and mixing chains",
        "folders": [("presets", "presets"), ("FXChains", "FXChains"), ("Grooves", "Grooves"), ("MIDINoteNames", "MIDINoteNames")],
        "inis": ["reaper-defpresets.ini", "reaper-fxoptions.ini", "reaper-fxtags.ini", "reaper-pinstates.ini"],
        "default": True
    },
    "fonts": {
        "name": "Studio Typography (Fonts)",
        "desc": "TrueType/OpenType fonts installed to ~/.local/share/fonts/ReaFull/",
        "folders": [("Fonts", "Fonts")],
        "inis": [],
        "default": True
    },
    "audio_tuning": {
        "name": "Linux Audio Engine Optimization",
        "desc": "Realtime settings (ALSA/JACK/PipeWire), thread priority, RAM locking, and HQ Resampling",
        "folders": [],
        "inis": [],
        "default": True
    },
    "striptease": {
        "name": "StripTease Modular Mixer Strip Suite",
        "desc": "Modular MCP channel strip interface with knobs, switches, and real-time GR meters",
        "folders": [
            ("Effects/StripTease", "Effects/StripTease"),
            ("Scripts/StripTease", "Scripts/StripTease"),
            ("FXChains/StripTease", "FXChains/StripTease"),
        ],
        "inis": [],
        "default": True
    },
    "docs": {
        "name": "Documentation & Resources",
        "desc": "Quick reference guides and documentation links",
        "folders": [("Docs", "Docs")],
        "inis": [],
        "default": True
    },
    "extensions": {
        "name": "Native Extensions (SWS & ReaPack)",
        "desc": "Verified Linux native binaries (SWS 2.14.0.7 & ReaPack 1.2.6) for UserPlugins/",
        "folders": [],
        "inis": [],
        "default": True
    },
}

class Logger:
    def __init__(self, log_path, quiet=False):
        self.log_path = log_path
        self.quiet = quiet
        self.log_file = None
        try:
            os.makedirs(os.path.dirname(os.path.abspath(log_path)), exist_ok=True)
            self.log_file = open(log_path, "w", encoding="utf-8")
            self._write_raw(f"=== ReaFull Installation Log - {datetime.now().isoformat()} ===\n")
        except Exception as e:
            if not self.quiet:
                print(f"{Colors.YELLOW}[!] Could not open log file: {e}{Colors.ENDC}")

    def _write_raw(self, text):
        if self.log_file:
            self.log_file.write(text + "\n")
            self.log_file.flush()

    def info(self, msg):
        timestamp = datetime.now().strftime("%H:%M:%S")
        if not self.quiet:
            print(f"{Colors.BLUE}[{timestamp} INFO]{Colors.ENDC} {msg}")
        self._write_raw(f"[{timestamp} INFO] {msg}")

    def success(self, msg):
        timestamp = datetime.now().strftime("%H:%M:%S")
        if not self.quiet:
            print(f"{Colors.GREEN}[{timestamp} OK]{Colors.ENDC} {msg}")
        self._write_raw(f"[{timestamp} OK] {msg}")

    def warn(self, msg):
        timestamp = datetime.now().strftime("%H:%M:%S")
        if not self.quiet:
            print(f"{Colors.YELLOW}[{timestamp} WARN]{Colors.ENDC} {msg}")
        self._write_raw(f"[{timestamp} WARN] {msg}")

    def error(self, msg):
        timestamp = datetime.now().strftime("%H:%M:%S")
        if not self.quiet:
            print(f"{Colors.RED}[{timestamp} ERROR]{Colors.ENDC} {msg}")
        self._write_raw(f"[{timestamp} ERROR] {msg}")

    def action(self, tag, msg):
        timestamp = datetime.now().strftime("%H:%M:%S")
        if not self.quiet:
            print(f"{Colors.CYAN}[{timestamp} {tag}]{Colors.ENDC} {msg}")
        self._write_raw(f"[{timestamp} {tag}] {msg}")

    def close(self):
        if self.log_file:
            self._write_raw(f"\n=== Installation finished at {datetime.now().isoformat()} ===")
            self.log_file.close()

def format_size(bytes_val):
    if bytes_val < 1024:
        return f"{bytes_val} B"
    elif bytes_val < 1024 * 1024:
        return f"{bytes_val / 1024:.1f} KB"
    elif bytes_val < 1024 * 1024 * 1024:
        return f"{bytes_val / (1024 * 1024):.1f} MB"
    else:
        return f"{bytes_val / (1024 * 1024 * 1024):.2f} GB"

def calculate_component_size(comp_id):
    if comp_id not in COMPONENTS:
        return 0, 0
    comp = COMPONENTS[comp_id]
    total_bytes = 0
    total_files = 0

    for src_rel, _ in comp["folders"]:
        src_path = os.path.join(ASSETS_DIR, src_rel)
        if os.path.isfile(src_path):
            total_bytes += os.path.getsize(src_path)
            total_files += 1
        elif os.path.isdir(src_path):
            for root, _, files in os.walk(src_path):
                for f in files:
                    fp = os.path.join(root, f)
                    try:
                        total_bytes += os.path.getsize(fp)
                        total_files += 1
                    except Exception:
                        pass

    for ini in comp["inis"]:
        ini_path = os.path.join(CONFIG_TEMPLATES_DIR, ini)
        if os.path.exists(ini_path):
            total_bytes += os.path.getsize(ini_path)
            total_files += 1

    return total_bytes, total_files

def is_reaper_running():
    try:
        res = subprocess.run(["pgrep", "-i", "reaper"], capture_output=True, text=True)
        return res.returncode == 0
    except Exception:
        return False

def detect_reaper_dir(interactive=True):
    native_dir = os.path.expanduser("~/.config/REAPER")
    flatpak_dir = os.path.expanduser("~/.var/app/fm.reaper.Reaper/config/REAPER")
    
    native_exists = os.path.exists(native_dir)
    flatpak_exists = os.path.exists(flatpak_dir)

    if native_exists and flatpak_exists:
        if interactive and sys.stdin.isatty():
            print(f"\n{Colors.YELLOW}[?] Multiple REAPER installations detected:{Colors.ENDC}")
            print(f"    1. Native REAPER ({native_dir})")
            print(f"    2. Flatpak REAPER ({flatpak_dir})")
            choice = input(f"{Colors.BOLD}Select destination [1/2] (default 1): {Colors.ENDC}").strip()
            if choice == "2":
                return flatpak_dir
        return native_dir
    elif flatpak_exists:
        return flatpak_dir
    elif native_exists:
        return native_dir
    return native_dir

def interactive_menu():
    keys = list(COMPONENTS.keys())
    selected = {k: COMPONENTS[k]["default"] for k in keys}

    while True:
        os.system('clear' if os.name == 'posix' else 'cls')
        print(f"{Colors.BOLD}{Colors.CYAN}")
        print(r"       █ │ █                                                           ")
        print(r"     █ █ │ █ █       ██████╗ ███████╗ █████╗ ███████╗██╗   ██╗██╗     ██╗")
        print(r"   █ █ █ █ █ █ █     ██╔══██╗██╔════╝██╔══██╗██╔════╝██║   ██║██║     ██║")
        print(r" █ █ █ █ █ █ █ █ █   ██████╔╝█████╗  ███████║█████╗  ██║   ██║██║     ██║")
        print(r"   █ █ █ █ █ █ █     ██╔══██╗██╔══╝  ██╔══██║██╔══╝  ██║   ██║██║     ██║")
        print(r"     █ █ │ █ █       ██║  ██║███████╗██║  ██║██║     ╚██████╔╝███████╗███████╗")
        print(r"       █ │ █         ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝      ╚═════╝ ╚══════╝╚══════╝")
        print(f"\n   Studio Production Suite for Linux REAPER (v{VERSION})")
        print(f"{Colors.ENDC}")
        print(f"{Colors.BOLD}Select the components you want to install:{Colors.ENDC}\n")

        total_selected_size = 0
        total_selected_files = 0

        for idx, k in enumerate(keys, 1):
            status = f"{Colors.GREEN}[X]{Colors.ENDC}" if selected[k] else f"{Colors.DIM}[ ]{Colors.ENDC}"
            size, files = calculate_component_size(k)
            size_str = format_size(size) if size > 0 else "0 KB"
            if selected[k]:
                total_selected_size += size
                total_selected_files += files

            name_col = f"{idx:2d}. {COMPONENTS[k]['name']}"
            print(f"  {status} {Colors.BOLD}{name_col:<55}{Colors.ENDC} {Colors.CYAN}({size_str}){Colors.ENDC}")
            print(f"       {Colors.DIM}{COMPONENTS[k]['desc']}{Colors.ENDC}")

        print("\n" + "-" * 70)
        print(f"  Total to install: {Colors.BOLD}{Colors.GREEN}{format_size(total_selected_size)}{Colors.ENDC} ({total_selected_files} files)")
        print("-" * 70)
        print(f"  {Colors.BOLD}Commands:{Colors.ENDC}")
        print("  - Type a component number to toggle it on/off (e.g. '1', '2 5 8')")
        print("  - 'a' / 'all'   : Select all (Full Studio)")
        print("  - 'k' / 'core'  : Core Suite (<700MB: ReaFull Themes, Analog/Digital FX, Templates, SWS, Fonts)")
        print("  - 'm' / 'min'   : Minimal profile (Themes, Audio Tuning, Fonts)")
        print("  - 'f' / 'fx'    : FX and Plugins only")
        print("  - 'c' / 'enter' : CONTINUE with installation")
        print("  - 'q' / 'exit'  : Cancel and exit\n")

        choice = input(f"{Colors.BOLD}Choice > {Colors.ENDC}").strip().lower()

        if choice in ['c', '']:
            if not any(selected.values()):
                print(f"{Colors.RED}You must select at least one component.{Colors.ENDC}")
                time.sleep(1.5)
                continue
            break
        elif choice in ['q', 'exit']:
            print("Installation cancelled by user.")
            sys.exit(0)
        elif choice in ['a', 'all']:
            for k in keys:
                selected[k] = True
        elif choice in ['k', 'core']:
            core_set = {"themes", "analog_fx", "digital_fx", "templates", "sws_autocolor", "menus_toolbars", "fonts", "audio_tuning", "docs"}
            for k in keys:
                selected[k] = k in core_set
        elif choice in ['m', 'min']:
            for k in keys:
                selected[k] = k in ["themes", "fonts", "audio_tuning"]
        elif choice in ['f', 'fx']:
            for k in keys:
                selected[k] = k in ["analog_fx", "digital_fx", "community_fx", "presets", "audio_tuning"]
        else:
            parts = choice.replace(",", " ").split()
            for p in parts:
                if p.isdigit():
                    num = int(p)
                    if 1 <= num <= len(keys):
                        comp_k = keys[num - 1]
                        selected[comp_k] = not selected[comp_k]

    return [k for k, v in selected.items() if v]

def create_backup(target_dir, logger, dry_run=False):
    if not os.path.exists(target_dir):
        logger.info(f"Target directory {target_dir} does not exist yet. Creating it.")
        if not dry_run:
            os.makedirs(target_dir, exist_ok=True)
        return None

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_path = f"{target_dir}_backup_pre_reafull_{timestamp}"
    logger.action("BACKUP", "Creating full safety backup:")
    logger.action("BACKUP", f"  -> Destination: {backup_path}")
    
    if not dry_run:
        shutil.copytree(target_dir, backup_path, symlinks=True)
        logger.success(f"Backup created successfully at: {backup_path}")
    return backup_path

def install_fonts(logger, dry_run=False):
    fonts_src = os.path.join(ASSETS_DIR, "Fonts")
    fonts_dst = os.path.expanduser("~/.local/share/fonts/ReaFull")
    
    if not os.path.exists(fonts_src):
        logger.warn("Fonts folder not found in assets, skipping.")
        return

    logger.action("FONTS", f"Installing studio fonts to {fonts_dst}...")
    if not dry_run:
        os.makedirs(fonts_dst, exist_ok=True)
        for font in os.listdir(fonts_src):
            src_f = os.path.join(fonts_src, font)
            dst_f = os.path.join(fonts_dst, font)
            if os.path.isfile(src_f):
                shutil.copy2(src_f, dst_f)
                logger.info(f"  -> Font installed: {font}")
        try:
            subprocess.run(["fc-cache", "-f", fonts_dst], capture_output=True)
            logger.success("Studio fonts installed and fontconfig cache updated.")
        except Exception as e:
            logger.warn(f"Could not run fc-cache: {e}")

def safe_copy_item(src_path, dst_path, logger, dry_run=False):
    if dry_run:
        return
    if os.path.isfile(src_path):
        os.makedirs(os.path.dirname(dst_path), exist_ok=True)
        if not os.path.islink(dst_path):
            shutil.copy2(src_path, dst_path)
            logger.info(f"  -> File: {os.path.relpath(dst_path, os.path.expanduser('~'))} ({format_size(os.path.getsize(src_path))})")
    elif os.path.isdir(src_path):
        os.makedirs(dst_path, exist_ok=True)
        for root, dirs, files in os.walk(src_path):
            rel = os.path.relpath(root, src_path)
            target_sub = os.path.join(dst_path, rel)
            os.makedirs(target_sub, exist_ok=True)
            for f in files:
                sf = os.path.join(root, f)
                df = os.path.join(target_sub, f)
                if not os.path.islink(df):
                    try:
                        shutil.copy2(sf, df)
                    except Exception as e:
                        logger.warn(f"Warning copying {f}: {e}")

def merge_reapack_ini(src_path, dst_path):
    """
    Non-destructively merges ReaPack remotes from src_path into dst_path.
    Preserves all existing user remotes and settings, adding only new remotes.
    """
    if not os.path.exists(dst_path):
        shutil.copy2(src_path, dst_path)
        return

    with open(dst_path, "r", encoding="utf-8", errors="ignore") as f:
        dst_lines = f.readlines()

    with open(src_path, "r", encoding="utf-8", errors="ignore") as f:
        src_lines = f.readlines()

    existing_urls = set()
    for line in dst_lines:
        line_s = line.strip()
        if line_s.startswith("remote") and "=" in line_s:
            parts = line_s.split("=", 1)[1].split("|")
            if len(parts) >= 2:
                existing_urls.add(parts[1].strip().lower())

    new_remotes = []
    for line in src_lines:
        line_s = line.strip()
        if line_s.startswith("remote") and "=" in line_s:
            parts = line_s.split("=", 1)[1].split("|")
            if len(parts) >= 2:
                url = parts[1].strip().lower()
                if url not in existing_urls:
                    new_remotes.append(line_s.split("=", 1)[1])
                    existing_urls.add(url)

    if not new_remotes:
        return

    in_remotes = False
    max_idx = -1
    remotes_insert_idx = len(dst_lines)
    
    for i, line in enumerate(dst_lines):
        line_s = line.strip()
        if line_s == "[remotes]":
            in_remotes = True
        elif in_remotes and line_s.startswith("["):
            in_remotes = False
            remotes_insert_idx = i
        elif in_remotes and line_s.startswith("remote") and "=" in line_s:
            try:
                r_num = int(line_s.split("=")[0].replace("remote", ""))
                if r_num > max_idx:
                    max_idx = r_num
            except ValueError:
                pass

    appended_lines = []
    cur_idx = max_idx + 1
    for r_entry in new_remotes:
        appended_lines.append(f"remote{cur_idx}={r_entry}\n")
        cur_idx += 1

    dst_lines[remotes_insert_idx:remotes_insert_idx] = appended_lines

    for i, line in enumerate(dst_lines):
        if line.strip().startswith("size="):
            dst_lines[i] = f"size={cur_idx}\n"
            break

    with open(dst_path, "w", encoding="utf-8") as f:
        f.writelines(dst_lines)

def deploy_components(selected_keys, target_dir, logger, profile="overlay", force=False, dry_run=False):
    logger.action("DEPLOY", f"Deploying selected components to: {target_dir} (Profile: {profile.upper()})")

    # 1. Folders
    for comp_id in selected_keys:
        comp = COMPONENTS[comp_id]
        if comp_id == "fonts":
            install_fonts(logger, dry_run=dry_run)
            continue
        if comp_id == "audio_tuning":
            continue

        logger.action("COMPONENT", f"Installing: {comp['name']}...")
        for src_rel, dst_rel in comp["folders"]:
            src_full = os.path.join(ASSETS_DIR, src_rel)
            dst_full = os.path.join(target_dir, dst_rel)
            if os.path.exists(src_full):
                safe_copy_item(src_full, dst_full, logger, dry_run=dry_run)

    # 2. Config templates associated with selected components
    active_inis = set()
    for comp_id in selected_keys:
        for ini in COMPONENTS[comp_id]["inis"]:
            active_inis.add(ini)

    logger.action("CONFIG", "Applying sanitized configurations and templates...")
    for ini in active_inis:
        src = os.path.join(CONFIG_TEMPLATES_DIR, ini)
        if not os.path.exists(src):
            continue

        if ini.endswith(".template.ini"):
            dst_name = ini.replace(".template.ini", ".ini")
            dst = os.path.join(target_dir, dst_name)
            with open(src, "r", encoding="utf-8") as f:
                content = f.read()
            content = content.replace("{{REAPER_CONFIG_DIR}}", target_dir)

            if os.path.exists(dst) and profile != "fresh" and not force:
                reafull_backup_name = f"{dst_name}.reafull"
                reafull_backup_dst = os.path.join(target_dir, reafull_backup_name)
                if not dry_run:
                    with open(reafull_backup_dst, "w", encoding="utf-8") as f:
                        f.write(content)
                logger.warn(f"  [PRESERVED] Existing user {dst_name} kept intact.")
                logger.info(f"               (ReaFull copy saved at {reafull_backup_name}; use --force to overwrite)")
            else:
                if not dry_run:
                    with open(dst, "w", encoding="utf-8") as f:
                        f.write(content)
                logger.info(f"  -> Dynamic template processed: {dst_name}")

        elif ini == "reapack.ini":
            dst = os.path.join(target_dir, ini)
            if os.path.exists(dst):
                logger.info("  -> Existing reapack.ini detected: merging ReaPack repositories without removing previous ones.")
                if not dry_run:
                    merge_reapack_ini(src, dst)
            else:
                if not dry_run:
                    shutil.copy2(src, dst)
                logger.info(f"  -> Initial configuration copied: {ini}")

        else:
            dst = os.path.join(target_dir, ini)
            if os.path.exists(dst) and profile != "fresh" and not force:
                reafull_backup_name = f"{ini}.reafull"
                reafull_backup_dst = os.path.join(target_dir, reafull_backup_name)
                if not dry_run:
                    shutil.copy2(src, reafull_backup_dst)
                logger.warn(f"  [PRESERVED] Existing user {ini} kept intact.")
                logger.info(f"               (ReaFull copy saved at {reafull_backup_name}; use --force to overwrite)")
            else:
                if not dry_run:
                    shutil.copy2(src, dst)
                logger.info(f"  -> Configuration applied: {ini}")

    # 3. Native Extension Setup (SWS & ReaPack)
    if "extensions" in selected_keys:
        ensure_native_extensions(target_dir, logger, dry_run=dry_run)

    # 4. Merge reaper.ini
    merge_reaper_ini(selected_keys, target_dir, logger, dry_run=dry_run)

def ensure_native_extensions(target_dir, logger, dry_run=False):
    """
    Ensures SWS Extension and ReaPack binaries are installed in target_dir/UserPlugins.
    1. Checks if already present in target_dir/UserPlugins.
    2. Searches system library locations (/usr/lib, /usr/lib64, etc.) and symlinks.
    3. If still missing, downloads official cryptographically verified binary releases.
    """
    arch = platform.machine().lower()
    if arch in ["x86_64", "amd64"]:
        sws_bin = "reaper_sws-x86_64.so"
        reapack_bin = "reaper_reapack-x86_64.so"
        sws_hash = KNOWN_HASHES.get("sws_x86_64")
        reapack_hash = KNOWN_HASHES.get("reapack_x86_64")
        sws_url = f"https://github.com/reaper-oss/sws/releases/download/v2.14.0.7/{sws_bin}"
        reapack_url = f"https://github.com/cfillion/reapack/releases/download/v1.2.6/{reapack_bin}"
    elif arch in ["aarch64", "arm64"]:
        sws_bin = "reaper_sws-aarch64.so"
        reapack_bin = "reaper_reapack-aarch64.so"
        sws_hash = KNOWN_HASHES.get("sws_aarch64")
        reapack_hash = KNOWN_HASHES.get("reapack_aarch64")
        sws_url = f"https://github.com/reaper-oss/sws/releases/download/v2.14.0.7/{sws_bin}"
        reapack_url = f"https://github.com/cfillion/reapack/releases/download/v1.2.6/{reapack_bin}"
    else:
        logger.warn(f"Architecture '{arch}' not supported for automatic binary extension downloads.")
        return

    userplugins_dst = os.path.join(target_dir, "UserPlugins")
    if not dry_run:
        os.makedirs(userplugins_dst, exist_ok=True)

    # 1. SWS Extension
    sws_dst = os.path.join(userplugins_dst, sws_bin)
    if not os.path.exists(sws_dst):
        found_sws = False
        for sys_path in [
            f"/usr/lib/sws/{sws_bin}",
            f"/usr/lib/REAPER/Plugins/{sws_bin}",
            f"/usr/lib64/{sws_bin}",
            f"/usr/lib/x86_64-linux-gnu/{sws_bin}",
            f"/usr/lib/aarch64-linux-gnu/{sws_bin}",
        ]:
            if os.path.exists(sys_path):
                if not dry_run:
                    try:
                        os.symlink(sys_path, sws_dst)
                        logger.success(f"Linked system SWS extension: {sys_path} -> {sws_dst}")
                        found_sws = True
                        break
                    except Exception:
                        pass
        if not found_sws and not dry_run:
            logger.action("EXTENSION", f"Downloading official SWS extension ({arch}) with integrity check...")
            if download_and_verify(sws_url, sws_dst, expected_sha256=sws_hash, logger=logger, quiet=logger.quiet):
                logger.success(f"SWS Extension ({arch}) installed and verified at UserPlugins/{sws_bin}")
            else:
                logger.warn("Could not download/verify SWS extension.")

    # 2. ReaPack
    reapack_dst = os.path.join(userplugins_dst, reapack_bin)
    if not os.path.exists(reapack_dst):
        found_reapack = False
        for sys_path in [
            f"/usr/lib/REAPER/Plugins/{reapack_bin}",
            f"/usr/lib/reapack/{reapack_bin}",
            f"/usr/lib64/{reapack_bin}",
            f"/usr/lib/x86_64-linux-gnu/{reapack_bin}",
            f"/usr/lib/aarch64-linux-gnu/{reapack_bin}",
        ]:
            if os.path.exists(sys_path):
                if not dry_run:
                    try:
                        os.symlink(sys_path, reapack_dst)
                        logger.success(f"Linked system ReaPack: {sys_path} -> {reapack_dst}")
                        found_reapack = True
                        break
                    except Exception:
                        pass
        if not found_reapack and not dry_run:
            logger.action("EXTENSION", f"Downloading official ReaPack ({arch}) with integrity check...")
            if download_and_verify(reapack_url, reapack_dst, expected_sha256=reapack_hash, logger=logger, quiet=logger.quiet):
                logger.success(f"ReaPack ({arch}) installed and verified at UserPlugins/{reapack_bin}")
            else:
                logger.warn("Could not download/verify ReaPack.")

def detect_best_audio_settings(logger):
    cpu_cores = os.cpu_count() or 4
    audio_settings = {
        "workthreads": str(cpu_cores),
        "afx": "1",
        "afxb": "200",
        "afxrender": "1",
        "playresamplemode": "5",  # r8brain / 512pt Sinc HQ
        "projrenderresample": "6",  # r8brain / 768pt Sinc
        "audio_closeifidle": "0",
        "audio_mute": "1",
        "audio_mute_db": "18.0",
        "linux_mlockall": "1",
        "linux_disable_pm": "1",
        "linux_auto_pasuspend": "1",
        "alsa_rtprio": "90",
    }

    is_pipewire = False
    try:
        pw_check = subprocess.run(["pgrep", "-x", "pipewire"], capture_output=True)
        if pw_check.returncode == 0:
            is_pipewire = True
    except Exception:
        pass

    try:
        res = subprocess.run(["aplay", "-l"], capture_output=True, text=True)
        if "U192k" in res.stdout or "UMC404HD" in res.stdout:
            audio_settings.update({
                "alsa_indev": "hw:U192k",
                "alsa_outdev": "hw:U192k",
                "linux_audio_bits": "32",
                "linux_audio_bsize": "256",
                "linux_audio_bufs": "3",
                "linux_audio_nch_in": "4",
                "linux_audio_nch_out": "4",
                "linux_audio_srate": "48000",
                "linux_audio_srateor": "1",
            })
            logger.info("  [Audio Hardware] Interface detected: Behringer UMC404HD 192k (hw:U192k, 4 in/4 out, 32-bit, 48kHz).")
        elif "AudioBox" in res.stdout:
            audio_settings.update({
                "alsa_indev": "hw:USB",
                "alsa_outdev": "hw:USB",
                "linux_audio_bits": "24",
                "linux_audio_bsize": "256",
                "linux_audio_bufs": "3",
                "linux_audio_nch_in": "2",
                "linux_audio_nch_out": "2",
                "linux_audio_srate": "48000",
                "linux_audio_srateor": "1",
            })
            logger.info("  [Audio Hardware] Interface detected: Presonus AudioBox USB (hw:USB).")
        else:
            if is_pipewire:
                logger.info("  [Audio Server] PipeWire server detected. Optimized threads and HQ sinc retained.")
            else:
                logger.info("  [Audio] General thread configuration applied (HQ Sinc, low-latency DSP).")
    except Exception as e:
        logger.warn(f"Could not query aplay: {e}")

    return audio_settings

def merge_reaper_ini(selected_keys, target_dir, logger, dry_run=False):
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

    project_and_system_keys = {
        "lastproject", "lastprojuiref",
        "projecttab1", "projecttab2", "projecttab3", "projecttab4", "projecttab5", "projecttabs",
        "hasrecentsec", "maxrecent", "numrecent",
        "recent01", "recent02", "recent03", "recent04", "recent05",
        "recent06", "recent07", "recent08", "recent09", "recent10",
        "projdefrecpath", "lastrenderpath", "lastrenderpath2", "lastrenderpath3", "lastrenderpath4", "lastrenderpath5", "lastrenderpath6",
        "render_pattern_0", "render_pattern_1", "render_pattern_2", "render_pattern_3",
        "SWSProjectList",
        "alsa_indev", "alsa_outdev", "alsa_rtprio",
        "jack_launchcmd", "jack_rtprio",
        "linux_audio_bits", "linux_audio_bsize", "linux_audio_bufs",
        "linux_audio_nch_in", "linux_audio_nch_out", "linux_audio_srate", "linux_audio_srateor",
        "linux_auto_pasuspend", "linux_disable_pm", "linux_mlockall",
        "workthreads", "playresamplemode", "projrenderresample", "afx", "afxb", "afxrender",
        "nag", "pspage_last", "prefs_x", "prefs_y", "wnd_h", "wnd_w", "wnd_x", "wnd_y", "wnd_state",
    }

    preserved_kvs = {}
    if "reaper" in cur_sections:
        for line in cur_sections["reaper"]:
            if "=" in line:
                k, v = line.split("=", 1)
                k_trim = k.strip()
                if k_trim in project_and_system_keys:
                    preserved_kvs[k_trim] = v.strip()

    if "audio_tuning" in selected_keys:
        best_audio = detect_best_audio_settings(logger)
        has_custom = bool(preserved_kvs.get("alsa_indev") or preserved_kvs.get("alsa_outdev") or preserved_kvs.get("jack_launchcmd"))
        if not has_custom:
            logger.action("AUDIO", "Applying optimal Linux audio engine configuration...")
            for k, v in best_audio.items():
                preserved_kvs[k] = v
        else:
            logger.action("AUDIO", f"Custom audio device detected ({preserved_kvs.get('alsa_indev')}). Optimizing threads and realtime...")
            for opt_k in ["alsa_rtprio", "linux_mlockall", "linux_disable_pm", "linux_auto_pasuspend", "workthreads", "playresamplemode", "projrenderresample", "afx", "afxb", "afxrender"]:
                if opt_k not in preserved_kvs or preserved_kvs[opt_k] in ["", "0", "-1", "50"]:
                    preserved_kvs[opt_k] = best_audio.get(opt_k, preserved_kvs.get(opt_k, "1"))

    # Auto-configure Python ReaScript engine in REAPER if not explicitly set
    if "python_lib" not in preserved_kvs:
        for lib_dir in ["/usr/lib", "/usr/lib64", "/usr/lib/x86_64-linux-gnu"]:
            if os.path.exists(lib_dir):
                for fn in os.listdir(lib_dir):
                    if re.match(r"^libpython3\.\d+\.so(\.1\.0)?$", fn) or fn == "libpython3.so":
                        preserved_kvs["python_lib"] = fn
                        preserved_kvs["python_lib_path"] = lib_dir
                        preserved_kvs["python_enable"] = "1"
                        logger.info(f"  [ReaScript Python] Auto-configured REAPER Python engine: {fn} ({lib_dir})")
                        break
            if "python_lib" in preserved_kvs:
                break

    preserved_sections = {}
    for sec_name in [".swell", ".swell_recent_path", "Recent", "RecentFX", "recentmetropat", "reaper_video", "midihw"]:
        if sec_name in cur_sections:
            preserved_sections[sec_name] = cur_sections[sec_name]

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
                elif k_trim == "lastthemefn5" and "themes" in selected_keys:
                    theme_path = os.path.join(target_dir, "ColorThemes/ReaFull Pro.ReaperThemeZip")
                    merged_reaper_lines.append(f"lastthemefn5={theme_path}\n")
                    seen_reaper_keys.add(k_trim)
                elif k_trim == "splashimage" and "themes" in selected_keys:
                    splash_path = os.path.join(target_dir, "Splash ReaFull.png")
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

    if "themes" in selected_keys:
        if "lastthemefn5" not in seen_reaper_keys:
            merged_reaper_lines.append(f"lastthemefn5={os.path.join(target_dir, 'ColorThemes/ReaFull Pro.ReaperThemeZip')}\n")
        if "splashimage" not in seen_reaper_keys:
            merged_reaper_lines.append(f"splashimage={os.path.join(target_dir, 'Splash ReaFull.png')}\n")

    with open(cur_ini_path, "w", encoding="utf-8") as f:
        for sec in [".swell", ".swell_recent_path"]:
            if sec in preserved_sections:
                f.write(f"[{sec}]\n")
                f.writelines(preserved_sections[sec])
                if not preserved_sections[sec] or not preserved_sections[sec][-1].endswith("\n"):
                    f.write("\n")

        f.write("[reaper]\n")
        f.writelines(merged_reaper_lines)
        if not merged_reaper_lines or not merged_reaper_lines[-1].endswith("\n"):
            f.write("\n")

        for sec, lines in tpl_sections.items():
            if sec not in ["reaper", ".swell", ".swell_recent_path", "Recent", "RecentFX", "recentmetropat", "reaper_video", "midihw"]:
                f.write(f"[{sec}]\n")
                f.writelines(lines)
                if not lines or not lines[-1].endswith("\n"):
                    f.write("\n")

        for sec in ["Recent", "RecentFX", "recentmetropat", "reaper_video", "midihw"]:
            if sec in preserved_sections:
                f.write(f"[{sec}]\n")
                f.writelines(preserved_sections[sec])
                if not preserved_sections[sec] or not preserved_sections[sec][-1].endswith("\n"):
                    f.write("\n")

def main():
    parser = argparse.ArgumentParser(description="ReaFull: Modular Installer for REAPER on Linux")
    parser.add_argument("--target", type=str, default=None, help="REAPER configuration target directory ('native', 'flatpak', or absolute path)")
    parser.add_argument("--profile", choices=["overlay", "fresh"], default=None, help="Installation profile: 'overlay' (non-destructive, preserves user INIs and settings) or 'fresh' (clean studio setup)")
    parser.add_argument("--force", "-f", action="store_true", help="Overwrite keyboard shortcuts, menus, and custom INIs even if they already exist")
    parser.add_argument("--all", "-a", action="store_true", help="Install all components (Full Mode)")
    parser.add_argument("--components", "-c", type=str, default=None, help="Comma-separated list of components (e.g. themes,analog_fx,audio_tuning)")
    parser.add_argument("--preset", "-p", choices=["full", "core", "minimal", "fx-only", "themes-only", "community", "extras"], help="Quick selection preset ('core' < 700MB)")
    parser.add_argument("--no-backup", action="store_true", help="Skip pre-install backup creation")
    parser.add_argument("--allow-running-reaper", action="store_true", help="Allow installation even if REAPER is currently running (not recommended)")
    parser.add_argument("--assets-dir", type=str, default=None, help="Custom path to ReaFull assets directory")
    parser.add_argument("--dry-run", action="store_true", help="Simulate without modifying files")
    parser.add_argument("--log-file", type=str, default=None, help="Custom log file path")
    parser.add_argument("--quiet", "-q", action="store_true", help="Silent non-interactive mode")
    parser.add_argument("--version", "-v", action="version", version=f"ReaFull Installer {VERSION}")

    args = parser.parse_args()

    # Ensure assets are present or download from release CDN
    ensure_assets_available(custom_assets_dir=args.assets_dir, quiet=args.quiet)

    is_interactive = not args.quiet and not args.all and not args.preset and not args.components
    
    # Resolve target directory (including native / flatpak aliases)
    if args.target == "native":
        target_dir = os.path.expanduser("~/.config/REAPER")
    elif args.target == "flatpak":
        target_dir = os.path.expanduser("~/.var/app/fm.reaper.Reaper/config/REAPER")
    elif args.target:
        target_dir = os.path.abspath(os.path.expanduser(args.target))
    else:
        target_dir = detect_reaper_dir(interactive=is_interactive)

    log_path = args.log_file or os.path.join(target_dir, f"reafull_install_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log")
    logger = Logger(log_path, quiet=args.quiet)

    # Determine profile: if not explicitly given, default to 'overlay' if target exists and has files, else 'fresh'
    if args.profile:
        profile = args.profile
    else:
        profile = "overlay" if os.path.exists(os.path.join(target_dir, "reaper.ini")) else "fresh"

    # Component Selection Resolution
    if args.all or args.preset == "full":
        selected_keys = list(COMPONENTS.keys())
    elif args.preset == "core":
        selected_keys = ["themes", "analog_fx", "digital_fx", "templates", "sws_autocolor", "menus_toolbars", "fonts", "audio_tuning", "extensions", "docs"]
    elif args.preset == "minimal":
        selected_keys = ["themes", "fonts", "audio_tuning"]
    elif args.preset == "fx-only":
        selected_keys = ["analog_fx", "digital_fx", "community_fx", "presets", "audio_tuning"]
    elif args.preset == "themes-only":
        selected_keys = ["themes", "fonts", "sws_autocolor"]
    elif args.preset in ["community", "extras"]:
        selected_keys = ["community_fx", "scripts", "presets"]
    elif args.components:
        selected_keys = [k.strip() for k in args.components.split(",") if k.strip() in COMPONENTS]
    elif args.quiet:
        selected_keys = [k for k, v in COMPONENTS.items() if v["default"]]
    else:
        selected_keys = interactive_menu()

    # Pre-Flight Summary
    total_bytes = sum(calculate_component_size(k)[0] for k in selected_keys)
    total_files = sum(calculate_component_size(k)[1] for k in selected_keys)

    if not args.quiet:
        print(f"{Colors.BOLD}{Colors.CYAN}")
        print(r"       █ │ █                                                           ")
        print(r"     █ █ │ █ █       ██████╗ ███████╗ █████╗ ███████╗██╗   ██╗██╗     ██╗")
        print(r"   █ █ █ █ █ █ █     ██╔══██╗██╔════╝██╔══██╗██╔════╝██║   ██║██║     ██║")
        print(r" █ █ █ █ █ █ █ █ █   ██████╔╝█████╗  ███████║█████╗  ██║   ██║██║     ██║")
        print(r"   █ █ █ █ █ █ █     ██╔══██╗██╔══╝  ██╔══██║██╔══╝  ██║   ██║██║     ██║")
        print(r"     █ █ │ █ █       ██║  ██║███████╗██║  ██║██║     ╚██████╔╝███████╗███████╗")
        print(r"       █ │ █         ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝      ╚═════╝ ╚══════╝╚══════╝")
        print(f"{Colors.ENDC}")
        print(f"{Colors.BOLD}{Colors.CYAN}==============================================================================={Colors.ENDC}")
        print(f"{Colors.BOLD}{Colors.CYAN}                    ReaFull Installation Pre-Flight Summary                     {Colors.ENDC}")
        print(f"{Colors.BOLD}{Colors.CYAN}==============================================================================={Colors.ENDC}")
        print(f"  Target Directory     : {Colors.BOLD}{target_dir}{Colors.ENDC}")
        print(f"  Installation Profile : {Colors.BOLD}{profile.upper()}{Colors.ENDC} {'(Shortcuts and custom INIs preserved)' if profile == 'overlay' and not args.force else '(Full overwrite enabled)'}")
        print(f"  Log File             : {Colors.DIM}{log_path}{Colors.ENDC}")
        print(f"  Operation Mode       : {'SIMULATION (DRY RUN)' if args.dry_run else 'REAL INSTALLATION'}")
        print(f"  Space Required       : {Colors.BOLD}{Colors.GREEN}{format_size(total_bytes)}{Colors.ENDC} ({total_files} files)")
        print(f"  Components ({len(selected_keys)} selected):")
        for k in selected_keys:
            sz, _ = calculate_component_size(k)
            print(f"    - {COMPONENTS[k]['name']} {Colors.DIM}({format_size(sz)}){Colors.ENDC}")
        print("------------------------------------------------------\n")

    if is_reaper_running():
        logger.warn("REAPER is currently running.")
        if not args.quiet and sys.stdin.isatty():
            ans = input(f"{Colors.YELLOW}Do you want to continue anyway? [y/N]: {Colors.ENDC}").strip().lower()
            if ans not in ['y', 'yes', 's', 'si']:
                logger.info("Installation aborted by user to close REAPER.")
                logger.close()
                sys.exit(0)
        elif not args.allow_running_reaper and not args.force:
            logger.error("REAPER is currently running. Please close REAPER before installing, or pass --allow-running-reaper.")
            logger.close()
            sys.exit(1)

    if not args.no_backup:
        create_backup(target_dir, logger, dry_run=args.dry_run)

    deploy_components(selected_keys, target_dir, logger, profile=profile, force=args.force, dry_run=args.dry_run)

    logger.success("ReaFull files deployed successfully.")
    logger.info(f"Installation log saved to: {log_path}")

    # Run verification health check gate
    verify_script = os.path.join(ROOT_DIR, "scripts", "verify_installation.py")
    if os.path.exists(verify_script) and not args.dry_run:
        if not args.quiet:
            print("\n" + "-" * 54)
        logger.action("VERIFY", "Running installation health check gate...")
        try:
            cmd = [sys.executable, verify_script, target_dir, "--components", ",".join(selected_keys)]
            if args.quiet:
                cmd.append("--quiet")
            res = subprocess.run(cmd)
            if res.returncode != 0:
                logger.error("Post-installation health check failed! Issues detected in installed configuration.")
                logger.close()
                sys.exit(1)
            else:
                logger.success("Post-installation health check passed with zero issues.")
        except Exception as e:
            logger.error(f"Could not run verifier: {e}")
            logger.close()
            sys.exit(1)

    logger.close()

    if not args.quiet:
        print(f"\n{Colors.BOLD}{Colors.GREEN}======================================================{Colors.ENDC}")
        print(f"{Colors.BOLD}{Colors.GREEN}      ReaFull Suite Installation Complete!              {Colors.ENDC}")
        print(f"{Colors.BOLD}{Colors.GREEN}======================================================{Colors.ENDC}")
        print(f"\nLaunch REAPER to enjoy your analog production environment on Linux.\n")

if __name__ == "__main__":
    main()
