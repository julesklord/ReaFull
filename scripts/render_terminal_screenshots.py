#!/usr/bin/env python3
"""
Renders terminal screenshots for ReaFull documentation.
Creates modern dark-themed terminal frames with drop shadows, window chrome, and ANSI styling.
"""

import os
import re
from PIL import Image, ImageDraw, ImageFont, ImageFilter

FONT_PATH = "/usr/share/fonts/TTF/DejaVuSansMono.ttf"
if not os.path.exists(FONT_PATH):
    FONT_PATH = "/usr/share/fonts/dejavu-sans-mono-fonts/DejaVuSansMono.ttf"

FONT_SIZE = 15
LINE_HEIGHT = 22
CHAR_WIDTH = 9.2

COLOR_MAP = {
    "default": (220, 224, 232),
    "dim": (120, 130, 150),
    "bold": (255, 255, 255),
    "cyan": (56, 189, 248),
    "green": (74, 222, 128),
    "yellow": (250, 204, 21),
    "red": (248, 113, 113),
    "blue": (96, 165, 250),
    "magenta": (232, 121, 249),
}

def render_terminal(title, text_tokens, output_path, min_width=860):
    font = ImageFont.truetype(FONT_PATH, FONT_SIZE)
    bold_font = font

    # Calculate content dimensions
    max_line_len = max(sum(len(t[0]) for t in line) for line in text_tokens)
    num_lines = len(text_tokens)

    content_w = max(min_width, int(max_line_len * CHAR_WIDTH) + 60)
    title_bar_h = 38
    content_h = num_lines * LINE_HEIGHT + 35
    term_w = content_w
    term_h = title_bar_h + content_h

    pad_x, pad_y = 60, 50
    canvas_w = term_w + pad_x * 2
    canvas_h = term_h + pad_y * 2

    # Canvas
    canvas = Image.new("RGBA", (canvas_w, canvas_h), (13, 17, 23, 255))

    # Shadow
    shadow = Image.new("RGBA", (canvas_w, canvas_h), (0, 0, 0, 0))
    sdraw = ImageDraw.Draw(shadow)
    sbox = [pad_x - 4, pad_y + 12, pad_x + term_w + 4, pad_y + term_h + 20]
    sdraw.rounded_rectangle(sbox, radius=18, fill=(0, 0, 0, 160))
    shadow = shadow.filter(ImageFilter.GaussianBlur(radius=24))
    canvas = Image.alpha_composite(canvas, shadow)

    draw = ImageDraw.Draw(canvas)

    # Window body
    wbox = [pad_x, pad_y, pad_x + term_w, pad_y + term_h]
    draw.rounded_rectangle(wbox, radius=12, fill=(22, 27, 34, 255), outline=(48, 54, 61, 255), width=1)

    # Title bar
    tbox = [pad_x, pad_y, pad_x + term_w, pad_y + title_bar_h]
    draw.rounded_rectangle(tbox, radius=12, fill=(30, 36, 46, 255))
    draw.rectangle([pad_x, pad_y + 20, pad_x + term_w, pad_y + title_bar_h], fill=(30, 36, 46, 255))
    draw.line([pad_x, pad_y + title_bar_h, pad_x + term_w, pad_y + title_bar_h], fill=(48, 54, 61, 255), width=1)

    # Window dots
    dot_y = pad_y + 19
    draw.ellipse([pad_x + 18, dot_y - 6, pad_x + 30, dot_y + 6], fill=(255, 95, 86, 255)) # Close
    draw.ellipse([pad_x + 38, dot_y - 6, pad_x + 50, dot_y + 6], fill=(255, 189, 46, 255)) # Minimize
    draw.ellipse([pad_x + 58, dot_y - 6, pad_x + 70, dot_y + 6], fill=(39, 201, 63, 255)) # Maximize

    # Title text
    title_font = ImageFont.truetype(FONT_PATH, 13)
    bbox = title_font.getbbox(title)
    tw = bbox[2] - bbox[0]
    draw.text((pad_x + (term_w - tw) / 2, pad_y + 11), title, font=title_font, fill=(139, 148, 158, 255))

    # Render lines
    start_x = pad_x + 25
    start_y = pad_y + title_bar_h + 18

    for row_idx, line in enumerate(text_tokens):
        cur_x = start_x
        y = start_y + row_idx * LINE_HEIGHT
        for text, style in line:
            color = COLOR_MAP.get(style, COLOR_MAP["default"])
            draw.text((cur_x, y), text, font=font, fill=color + (255,))
            cur_x += len(text) * CHAR_WIDTH

    os.makedirs(os.path.dirname(os.path.abspath(output_path)), exist_ok=True)
    canvas.save(output_path)
    print(f"[+] Saved screenshot: {output_path} ({canvas_w}x{canvas_h})")

def make_interactive_menu_screenshot():
    lines = [
        [("  ____            _____       _ _ ", "cyan")],
        [(" |  _ \\ ___  __ _|  ___|   _ | | |", "cyan")],
        [(" | |_) / _ \\/ _` | |_ | | | || | |", "cyan")],
        [(" |  _ <  __/ (_| |  _|| |_| || | |", "cyan")],
        [(" |_| \\_\\___|\\__,_|_|   \\__,_||_|_|", "cyan")],
        [("", "default")],
        [("  Instalador Modular para Linux REAPER (v2026.1.0)", "bold")],
        [("", "default")],
        [("Selecciona los componentes que deseas instalar:", "bold")],
        [("", "default")],
        [("  ", "default"), ("[X] 1. Temas Visuales y Splash Screen", "green"), ("                     (8.0 MB)", "cyan")],
        [("       Temas ReaFull Pro, Dark, Gray, Light y pantalla de inicio", "dim")],
        [("  ", "default"), ("[X] 2. ReaFull Analog FX Suite (JSFX)", "green"), ("                     (379.9 MB)", "cyan")],
        [("       Emulaciones analógicas (SolidBus, DisTres-C, Pulse-EQ, Tape, FET-76)", "dim")],
        [("  ", "default"), ("[X] 3. ReaFull Digital FX Suite (JSFX)", "green"), ("                    (221.3 MB)", "cyan")],
        [("       Procesamiento digital (D-DynEQ, D-MSComp, D-Meter LUFS, Reflex 1/2/3)", "dim")],
        [("  ", "default"), ("[X] 4. Community FX Suites (Saike, Sonic Anomaly, Tilr)", "green"), ("   (34.1 MB)", "cyan")],
        [("       Herramientas de la comunidad integradas y optimizadas", "dim")],
        [("  ", "default"), ("[X] 5. Plantillas de Pistas y Proyectos", "green"), ("                   (5.6 MB)", "cyan")],
        [("       17 categorías de TrackTemplates y ProjectTemplates por género", "dim")],
        [("  ", "default"), ("[X] 6. SWS AutoColor, Iconos y Datos", "green"), ("                      (43.8 MB)", "cyan")],
        [("       310+ reglas de auto-color, iconos de pista, toolbar icons HiDPI", "dim")],
        [("  ", "default"), ("[X] 7. Menús, Barras de Herramientas y Screensets", "green"), ("         (3.0 MB)", "cyan")],
        [("       Barras flotantes personalizadas, atajos de teclado y espacios de trabajo", "dim")],
        [("  ", "default"), ("[X] 8. Suite de Scripts ReaScripts", "green"), ("                        (150.4 MB)", "cyan")],
        [("       FTC Tools, HeDa Track Inspector 2, Lokasenna GUI v2, ReaFull Manager", "dim")],
        [("  ", "default"), ("[X] 9. Presets y Cadenas FXChains", "green"), ("                         (11.2 MB)", "cyan")],
        [("       Presets de fábrica analógicos/digitales, cadenas de mezcla y mastering", "dim")],
        [("  ", "default"), ("[X] 10. Tipografías de Estudio (Fonts)", "green"), ("                    (1.1 MB)", "cyan")],
        [("       Fuentes instaladas en ~/.local/share/fonts/ReaFull/", "dim")],
        [("  ", "default"), ("[X] 11. Optimización del Motor de Audio Linux", "green"), ("             (0 B)", "cyan")],
        [("       Ajustes de tiempo real PipeWire/ALSA, prioridad de hilos, HQ Resampling", "dim")],
        [("  ", "default"), ("[X] 12. Documentación y Recursos", "green"), ("                          (965 B)", "cyan")],
        [("       Guías de referencia rápida y documentación oficial", "dim")],
        [("", "default")],
        [("-" * 72, "dim")],
        [("  Total a instalar: ", "default"), ("858.5 MB", "green"), (" (11482 archivos)", "default")],
        [("-" * 72, "dim")],
        [("  Comandos: ", "bold"), ("a (todos) | m (mínimo) | f (solo FX) | enter (instalar)", "dim")],
        [("", "default")],
        [("Opción > ", "bold"), ("c", "green")],
    ]
    render_terminal("jules@studio: ~/ReaFull (Interactive Setup)", lines, "docs/terminal_interactive.png")

def make_install_and_verify_screenshot():
    lines = [
        [("======================================================", "cyan")],
        [("           Resumen de Instalación de ReaFull          ", "cyan")],
        [("======================================================", "cyan")],
        [("  Directorio Destino   : ", "default"), ("~/.config/REAPER", "bold")],
        [("  Perfil de Instalación: ", "default"), ("OVERLAY", "green"), (" (Atajos y menús preservados)", "dim")],
        [("  Espacio Requerido    : ", "default"), ("858.5 MB", "green"), (" (11482 archivos)", "default")],
        [("-" * 54, "dim")],
        [("", "default")],
        [("[05:24:13 BACKUP] ", "cyan"), ("Creando copia de respaldo de seguridad completa:", "default")],
        [("  -> Destino: ~/.config/REAPER_backup_pre_reafull_20260817", "dim")],
        [("[05:24:13 DEPLOY] ", "cyan"), ("Desplegando componentes en: ~/.config/REAPER (OVERLAY)", "default")],
        [("[05:24:13 COMPONENT] ", "cyan"), ("Instalando: Temas Visuales y Splash Screen...", "default")],
        [("[05:24:13 COMPONENT] ", "cyan"), ("Instalando: ReaFull Analog FX Suite (JSFX)...", "default")],
        [("[05:24:13 COMPONENT] ", "cyan"), ("Instalando: ReaFull Digital FX Suite (JSFX)...", "default")],
        [("[05:24:13 COMPONENT] ", "cyan"), ("Instalando: Plantillas de Pistas y Proyectos...", "default")],
        [("[05:24:13 FONTS] ", "cyan"), ("Instalando fuentes de estudio en ~/.local/share/fonts/ReaFull...", "default")],
        [("[05:24:13 CONFIG] ", "cyan"), ("Aplicando configuraciones y plantillas sanitizadas...", "default")],
        [("[05:24:13 INFO] ", "blue"), ("  -> reapack.ini existente: fusionando repositorios ReaPack", "dim")],
        [("[05:24:13 WARN] ", "yellow"), ("  [PRESERVADO] reaper-kb.ini existente del usuario intacto.", "yellow")],
        [("[05:24:13 OK] ", "green"), ("Instalación de ReaFull completada exitosamente.", "green")],
        [("", "default")],
        [("-" * 54, "dim")],
        [("=== ReaFull Health Check for: ~/.config/REAPER ===", "bold")],
        [("", "default")],
        [("[OK] ", "green"), ("REAPER config directory exists.", "default")],
        [("[OK] ", "green"), ("ReaFull Pro theme installed.", "default")],
        [("[OK] ", "green"), ("ReaFull Analog FX & Digital FX JSFX suites verified.", "default")],
        [("[OK] ", "green"), ("ReaFull typography available in fontconfig.", "default")],
        [("[OK] ", "green"), ("TrackTemplates installed (17 categories).", "default")],
        [("[OK] ", "green"), ("SWS AutoColor & Icons configuration installed.", "default")],
        [("[OK] ", "green"), ("No raw {{...}} template placeholders detected.", "default")],
        [("[OK] ", "green"), ("Clean Linux configuration: zero Windows drive paths detected.", "default")],
        [("", "default")],
        [("======================================================", "green")],
        [("  Status: REAFULL INSTALLATION HEALTHY & VERIFIED!    ", "green")],
        [("======================================================", "green")],
    ]
    render_terminal("jules@studio: ~/ReaFull (Install & Health Check)", lines, "docs/terminal_install.png")

if __name__ == "__main__":
    make_interactive_menu_screenshot()
    make_install_and_verify_screenshot()
