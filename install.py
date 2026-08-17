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
from datetime import datetime

VERSION = "2026.1.0"

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
    DIM = '\033[2m'
    ENDC = '\033[0m'

# Modular Component Definitions
COMPONENTS = {
    "themes": {
        "name": "Temas Visuales y Splash Screen",
        "desc": "Temas ReaFull Pro, Dark, Gray, Light y pantalla de inicio",
        "folders": [("ColorThemes", "ColorThemes"), ("branding/Splash ReaFull.png", "Splash ReaFull.png")],
        "inis": ["reaper-themeconfig.ini"],
        "default": True
    },
    "analog_fx": {
        "name": "ReaFull Analog FX Suite (JSFX)",
        "desc": "Emulaciones analógicas (SolidBus, DisTres-C, Pulse-EQ, Tape, Tube-Pre, FET-76, Summing)",
        "folders": [("Effects/ReaFull Analog FX", "Effects/ReaFull Analog FX")],
        "inis": [],
        "default": True
    },
    "digital_fx": {
        "name": "ReaFull Digital FX Suite (JSFX)",
        "desc": "Procesamiento digital (D-DynEQ, D-MSComp, D-Meter LUFS, Reflex 1/2/3 Reverbs, T-FFT)",
        "folders": [("Effects/ReaFull Digital FX", "Effects/ReaFull Digital FX")],
        "inis": [],
        "default": True
    },
    "community_fx": {
        "name": "Community FX Suites (Saike, Sonic Anomaly, Tilr)",
        "desc": "Herramientas de la comunidad integradas y optimizadas",
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
        "name": "Plantillas de Pistas y Proyectos",
        "desc": "17 categorías de TrackTemplates (Drums, Vocals, Guitars, Master) y ProjectTemplates",
        "folders": [("TrackTemplates", "TrackTemplates"), ("ProjectTemplates", "ProjectTemplates")],
        "inis": [],
        "default": True
    },
    "sws_autocolor": {
        "name": "SWS AutoColor, Iconos y Datos",
        "desc": "310+ reglas de auto-color, iconos de pista, toolbar icons HiDPI",
        "folders": [("Data", "Data")],
        "inis": ["sws-autocoloricon.ini", "S&M.template.ini", "S&M_Cyclactions.ini"],
        "default": True
    },
    "menus_toolbars": {
        "name": "Menús, Barras de Herramientas y Screensets",
        "desc": "Barras flotantes personalizadas, atajos de teclado y espacios de trabajo",
        "folders": [("MenuSets", "MenuSets"), ("KeyMaps", "KeyMaps"), ("MouseMaps", "MouseMaps"), ("OSC", "OSC")],
        "inis": ["reaper-menu.ini", "reaper-screensets.ini", "screensets.ini", "reaper-kb.ini", "reaper-mouse.ini", "reaper-fxfolders.ini"],
        "default": True
    },
    "scripts": {
        "name": "Suite de Scripts ReaScripts",
        "desc": "FTC Tools, HeDa Track Inspector 2, Lokasenna GUI v2, Zaibuyidao, ReaFull Manager",
        "folders": [("Scripts", "Scripts"), ("ReaPack", "ReaPack"), ("reaper_www_root", "reaper_www_root")],
        "inis": ["reaper-extstate.template.ini", "reapack.ini"],
        "default": True
    },
    "presets": {
        "name": "Presets y Cadenas FXChains",
        "desc": "Presets de fábrica analógicos y digitales, cadenas de masterización y mezcla",
        "folders": [("presets", "presets"), ("FXChains", "FXChains"), ("Grooves", "Grooves"), ("MIDINoteNames", "MIDINoteNames")],
        "inis": ["reaper-defpresets.ini", "reaper-fxoptions.ini", "reaper-fxtags.ini", "reaper-pinstates.ini"],
        "default": True
    },
    "fonts": {
        "name": "Tipografías de Estudio (Fonts)",
        "desc": "Fuentes TrueType/OpenType instaladas en ~/.local/share/fonts/ReaFull/",
        "folders": [("Fonts", "Fonts")],
        "inis": [],
        "default": True
    },
    "audio_tuning": {
        "name": "Optimización del Motor de Audio Linux",
        "desc": "Ajustes de tiempo real (ALSA/JACK/PipeWire), prioridad de hilos, RAM locking y HQ Resampling",
        "folders": [],
        "inis": [],
        "default": True
    },
    "docs": {
        "name": "Documentación y Recursos",
        "desc": "Guías de referencia rápida y enlaces de documentación",
        "folders": [("Docs", "Docs")],
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
                print(f"{Colors.YELLOW}[!] No se pudo abrir el archivo de log: {e}{Colors.ENDC}")

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
            print(f"\n{Colors.YELLOW}[?] Se detectaron múltiples instalaciones de REAPER:{Colors.ENDC}")
            print(f"    1. REAPER Nativo ({native_dir})")
            print(f"    2. REAPER Flatpak ({flatpak_dir})")
            choice = input(f"{Colors.BOLD}Selecciona destino [1/2] (por defecto 1): {Colors.ENDC}").strip()
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
        print("  ____            _____       _ _ ")
        print(" |  _ \\ ___  __ _|  ___|   _ | | |")
        print(" | |_) / _ \\/ _` | |_ | | | || | |")
        print(" |  _ <  __/ (_| |  _|| |_| || | |")
        print(" |_| \\_\\___|\\__,_|_|   \\__,_||_|_|")
        print("                                  ")
        print(f"  Instalador Modular para Linux REAPER (v{VERSION})")
        print(f"{Colors.ENDC}")
        print(f"{Colors.BOLD}Selecciona los componentes que deseas instalar:{Colors.ENDC}\n")

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
        print(f"  Total a instalar: {Colors.BOLD}{Colors.GREEN}{format_size(total_selected_size)}{Colors.ENDC} ({total_selected_files} archivos)")
        print("-" * 70)
        print(f"  {Colors.BOLD}Comandos:{Colors.ENDC}")
        print("  - Escribe el número del componente para activar/desactivar (ej: '1', '2 5 8')")
        print("  - 'a' / 'all'   : Seleccionar todos")
        print("  - 'm' / 'min'   : Perfil mínimo (Temas, Audio Tuning, Fuentes)")
        print("  - 'f' / 'fx'    : Solo Efectos y Plugins")
        print("  - 'c' / 'enter' : CONTINUAR con la instalación")
        print("  - 'q' / 'exit'  : Cancelar y salir\n")

        choice = input(f"{Colors.BOLD}Opción > {Colors.ENDC}").strip().lower()

        if choice in ['c', '']:
            if not any(selected.values()):
                print(f"{Colors.RED}Debes seleccionar al menos un componente.{Colors.ENDC}")
                time.sleep(1.5)
                continue
            break
        elif choice in ['q', 'exit']:
            print("Instalación cancelada por el usuario.")
            sys.exit(0)
        elif choice in ['a', 'all']:
            for k in keys:
                selected[k] = True
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
    logger.action("BACKUP", "Creando copia de respaldo de seguridad completa:")
    logger.action("BACKUP", f"  -> Destino: {backup_path}")
    
    if not dry_run:
        shutil.copytree(target_dir, backup_path, symlinks=True)
        logger.success(f"Respaldo creado con éxito en: {backup_path}")
    return backup_path

def install_fonts(logger, dry_run=False):
    fonts_src = os.path.join(ASSETS_DIR, "Fonts")
    fonts_dst = os.path.expanduser("~/.local/share/fonts/ReaFull")
    
    if not os.path.exists(fonts_src):
        logger.warn("Carpeta de fuentes no encontrada en assets, omitiendo.")
        return

    logger.action("FONTS", f"Instalando fuentes de estudio en {fonts_dst}...")
    if not dry_run:
        os.makedirs(fonts_dst, exist_ok=True)
        for font in os.listdir(fonts_src):
            src_f = os.path.join(fonts_src, font)
            dst_f = os.path.join(fonts_dst, font)
            if os.path.isfile(src_f):
                shutil.copy2(src_f, dst_f)
                logger.info(f"  -> Fuente instalada: {font}")
        try:
            subprocess.run(["fc-cache", "-f", fonts_dst], capture_output=True)
            logger.success("Fuentes tipográficas instaladas y caché fontconfig actualizado.")
        except Exception as e:
            logger.warn(f"No se pudo ejecutar fc-cache: {e}")

def safe_copy_item(src_path, dst_path, logger, dry_run=False):
    if dry_run:
        return
    if os.path.isfile(src_path):
        os.makedirs(os.path.dirname(dst_path), exist_ok=True)
        if not os.path.islink(dst_path):
            shutil.copy2(src_path, dst_path)
            logger.info(f"  -> Archivo: {os.path.relpath(dst_path, os.path.expanduser('~'))} ({format_size(os.path.getsize(src_path))})")
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
                        logger.warn(f"Aviso copiando {f}: {e}")

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
    logger.action("DEPLOY", f"Desplegando componentes seleccionados en: {target_dir} (Perfil: {profile.upper()})")

    # 1. Folders
    for comp_id in selected_keys:
        comp = COMPONENTS[comp_id]
        if comp_id == "fonts":
            install_fonts(logger, dry_run=dry_run)
            continue
        if comp_id == "audio_tuning":
            continue

        logger.action("COMPONENT", f"Instalando: {comp['name']}...")
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

    logger.action("CONFIG", "Aplicando configuraciones y plantillas sanitizadas...")
    for ini in active_inis:
        src = os.path.join(CONFIG_TEMPLATES_DIR, ini)
        if ini.endswith(".template.ini"):
            dst_name = ini.replace(".template.ini", ".ini")
            dst = os.path.join(target_dir, dst_name)
            if os.path.exists(src) and not dry_run:
                with open(src, "r", encoding="utf-8") as f:
                    content = f.read()
                content = content.replace("{{REAPER_CONFIG_DIR}}", target_dir)
                with open(dst, "w", encoding="utf-8") as f:
                    f.write(content)
                logger.info(f"  -> Plantilla dinámica procesada: {dst_name}")
        elif ini == "reapack.ini":
            dst = os.path.join(target_dir, ini)
            if os.path.exists(dst):
                logger.info("  -> reapack.ini existente detectado: fusionando repositorios ReaPack sin borrar los previos.")
                if not dry_run:
                    merge_reapack_ini(src, dst)
            else:
                if not dry_run:
                    shutil.copy2(src, dst)
                logger.info(f"  -> Configuración inicial copiada: {ini}")
        elif ini in ["reaper-kb.ini", "reaper-mouse.ini", "reaper-menu.ini", "reaper-screensets.ini"]:
            dst = os.path.join(target_dir, ini)
            if os.path.exists(dst) and profile != "fresh" and not force:
                reafull_backup_name = f"{ini}.reafull"
                reafull_backup_dst = os.path.join(target_dir, reafull_backup_name)
                if not dry_run:
                    shutil.copy2(src, reafull_backup_dst)
                logger.warn(f"  [PRESERVADO] {ini} existente del usuario mantenido intacto.")
                logger.info(f"               (Copia ReaFull disponible en {reafull_backup_name}; usa --force para sobrescribir)")
            else:
                if not dry_run:
                    shutil.copy2(src, dst)
                logger.info(f"  -> Configuración aplicada: {ini}")
        else:
            dst = os.path.join(target_dir, ini)
            if os.path.exists(src) and not dry_run:
                shutil.copy2(src, dst)
                logger.info(f"  -> Configuración copiada: {ini}")

    # 3. Native Extension Symlinks
    userplugins_dst = os.path.join(target_dir, "UserPlugins")
    if not dry_run:
        os.makedirs(userplugins_dst, exist_ok=True)
        for sws_path in ["/usr/lib/sws/reaper_sws-x86_64.so", "/usr/lib/REAPER/Plugins/reaper_sws-x86_64.so", "/usr/lib64/reaper_sws-x86_64.so"]:
            if os.path.exists(sws_path):
                link_dst = os.path.join(userplugins_dst, "reaper_sws-x86_64.so")
                if not os.path.exists(link_dst):
                    try:
                        os.symlink(sws_path, link_dst)
                    except Exception:
                        pass
                break
        
        for reapack_path in ["/usr/lib/REAPER/Plugins/reaper_reapack-x86_64.so", "/usr/lib/reapack/reaper_reapack-x86_64.so", "/usr/lib64/reaper_reapack-x86_64.so"]:
            if os.path.exists(reapack_path):
                link_dst = os.path.join(userplugins_dst, "reaper_reapack-x86_64.so")
                if not os.path.exists(link_dst):
                    try:
                        os.symlink(reapack_path, link_dst)
                    except Exception:
                        pass
                break

    # 4. Merge reaper.ini
    merge_reaper_ini(selected_keys, target_dir, logger, dry_run=dry_run)

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
            logger.info("  [Audio Hardware] Interfaz detectada: Behringer UMC404HD 192k (hw:U192k, 4 in/4 out, 32-bit, 48kHz).")
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
            logger.info("  [Audio Hardware] Interfaz detectada: Presonus AudioBox USB (hw:USB).")
        else:
            if is_pipewire:
                logger.info("  [Audio Server] Servidor PipeWire detectado. Se mantienen hilos optimizados y HQ sinc.")
            else:
                logger.info("  [Audio] Configuración general de hilos (HQ Sinc, low-latency DSP) aplicada.")
    except Exception as e:
        logger.warn(f"No se pudo consultar aplay: {e}")

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
            logger.action("AUDIO", "Aplicando configuración óptima para motor de audio en Linux...")
            for k, v in best_audio.items():
                preserved_kvs[k] = v
        else:
            logger.action("AUDIO", f"Dispositivo de audio personalizado detectado ({preserved_kvs.get('alsa_indev')}). Optimizando hilos y tiempo real...")
            for opt_k in ["alsa_rtprio", "linux_mlockall", "linux_disable_pm", "linux_auto_pasuspend", "workthreads", "playresamplemode", "projrenderresample", "afx", "afxb", "afxrender"]:
                if opt_k not in preserved_kvs or preserved_kvs[opt_k] in ["", "0", "-1", "50"]:
                    preserved_kvs[opt_k] = best_audio.get(opt_k, preserved_kvs.get(opt_k, "1"))

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
    parser = argparse.ArgumentParser(description="ReaFull: Instalador Modular para REAPER en Linux")
    parser.add_argument("--target", type=str, default=None, help="Directorio destino de configuración de REAPER")
    parser.add_argument("--profile", choices=["overlay", "fresh"], default=None, help="Perfil de instalación: 'overlay' (no destructivo, preserva atajos/mouse/reapack) o 'fresh' (estudio limpio)")
    parser.add_argument("--force", "-f", action="store_true", help="Sobrescribir atajos de teclado y menús aunque existan previamente")
    parser.add_argument("--all", "-a", action="store_true", help="Instalar todos los componentes (Modo Completo)")
    parser.add_argument("--components", "-c", type=str, default=None, help="Lista de componentes separados por coma (ej: themes,analog_fx,audio_tuning)")
    parser.add_argument("--preset", "-p", choices=["full", "minimal", "fx-only", "themes-only"], help="Preset de selección rápida")
    parser.add_argument("--no-backup", action="store_true", help="Omitir la creación del respaldo previo")
    parser.add_argument("--dry-run", action="store_true", help="Simular sin modificar archivos")
    parser.add_argument("--log-file", type=str, default=None, help="Ruta personalizada del archivo de log")
    parser.add_argument("--quiet", "-q", action="store_true", help="Modo silencioso no interactivo")
    parser.add_argument("--version", "-v", action="version", version=f"ReaFull Installer {VERSION}")

    args = parser.parse_args()

    is_interactive = not args.quiet and not args.all and not args.preset and not args.components
    target_dir = args.target or detect_reaper_dir(interactive=is_interactive)
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
    elif args.preset == "minimal":
        selected_keys = ["themes", "fonts", "audio_tuning"]
    elif args.preset == "fx-only":
        selected_keys = ["analog_fx", "digital_fx", "community_fx", "presets", "audio_tuning"]
    elif args.preset == "themes-only":
        selected_keys = ["themes", "fonts", "sws_autocolor"]
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
        print(f"\n{Colors.BOLD}{Colors.CYAN}======================================================{Colors.ENDC}")
        print(f"{Colors.BOLD}{Colors.CYAN}           Resumen de Instalación de ReaFull          {Colors.ENDC}")
        print(f"{Colors.BOLD}{Colors.CYAN}======================================================{Colors.ENDC}")
        print(f"  Directorio Destino  : {Colors.BOLD}{target_dir}{Colors.ENDC}")
        print(f"  Perfil de Instalación: {Colors.BOLD}{profile.upper()}{Colors.ENDC} {'(Atajos y menús preservados)' if profile == 'overlay' and not args.force else '(Sobrescritura total habilitada)'}")
        print(f"  Archivo de Registro : {Colors.DIM}{log_path}{Colors.ENDC}")
        print(f"  Modo de Operación   : {'SIMULACIÓN (DRY RUN)' if args.dry_run else 'INSTALACIÓN REAL'}")
        print(f"  Espacio Requerido   : {Colors.BOLD}{Colors.GREEN}{format_size(total_bytes)}{Colors.ENDC} ({total_files} archivos)")
        print(f"  Componentes ({len(selected_keys)} seleccionados):")
        for k in selected_keys:
            sz, _ = calculate_component_size(k)
            print(f"    - {COMPONENTS[k]['name']} {Colors.DIM}({format_size(sz)}){Colors.ENDC}")
        print("------------------------------------------------------\n")

    if is_reaper_running():
        logger.warn("REAPER está ejecutándose actualmente.")
        if not args.quiet and sys.stdin.isatty():
            ans = input(f"{Colors.YELLOW}¿Deseas continuar de todas formas? [y/N]: {Colors.ENDC}").strip().lower()
            if ans not in ['y', 'yes', 's', 'si']:
                logger.info("Instalación abortada por el usuario para cerrar REAPER.")
                logger.close()
                sys.exit(0)

    if not args.no_backup:
        create_backup(target_dir, logger, dry_run=args.dry_run)

    deploy_components(selected_keys, target_dir, logger, profile=profile, force=args.force, dry_run=args.dry_run)

    logger.success("Instalación de ReaFull completada exitosamente.")
    logger.info(f"Registro de instalación guardado en: {log_path}")

    # Run verification health check
    verify_script = os.path.join(ROOT_DIR, "scripts", "verify_installation.py")
    if os.path.exists(verify_script) and not args.dry_run:
        print("\n" + "-" * 54)
        logger.action("VERIFY", "Ejecutando comprobación de salud de la instalación...")
        try:
            subprocess.run([sys.executable, verify_script, target_dir], check=False)
        except Exception as e:
            logger.warn(f"No se pudo ejecutar el verificador: {e}")

    logger.close()

    if not args.quiet:
        print(f"\n{Colors.BOLD}{Colors.GREEN}======================================================{Colors.ENDC}")
        print(f"{Colors.BOLD}{Colors.GREEN}  ¡Instalación de ReaFull Suite Finalizada!           {Colors.ENDC}")
        print(f"{Colors.BOLD}{Colors.GREEN}======================================================{Colors.ENDC}")
        print(f"\nInicia REAPER para disfrutar de tu entorno de producción analógica en Linux.\n")

if __name__ == "__main__":
    main()
