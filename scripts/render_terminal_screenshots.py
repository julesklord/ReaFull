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
        [("                                                                    ", "cyan")],
        [("                           ", "cyan")],
        [("                      ", "cyan")],
        [("                        ", "cyan")],
        [("                          ", "cyan")],
        [("                         ", "cyan")],
        [("                             ", "cyan")],
        [("", "default")],
        [("   Studio Production Suite for Linux REAPER (v2026.3.1)", "bold")],
        [("", "default")],
        [("Select the components you want to install:", "bold")],
        [("", "default")],
        [("  Default: ReaTooled workflow with ReArtist design & SWS autocolor.", "dim")],
        [("", "default")],
        [("  ", "default"), ("[X]  1. Visual Themes & Splash Screen", "green"), ("                      (14.7 MB)", "cyan")],
        [("       ReaFull PT Dark (default), PT Classic, Pro, Dark, Gray, Light themes", "dim")],
        [("  ", "default"), ("[ ]  2. ReaFull Analog FX Suite (JSFX)", "default"), ("                     (379.9 MB)", "cyan")],
        [("       Analog emulations (SolidBus, DisTres-C, Pulse-EQ, Tape, Tube-Pre, FET-76)", "dim")],
        [("  ", "default"), ("[ ]  3. ReaFull Digital FX Suite (JSFX)", "default"), ("                    (221.3 MB)", "cyan")],
        [("       Digital processing (D-DynEQ, D-MSComp, D-Meter LUFS, Reflex 1/2/3)", "dim")],
        [("  ", "default"), ("[ ]  4. Community FX Suites (Saike, Sonic Anomaly, Tilr)", "default"), ("   (34.1 MB)", "cyan")],
        [("       Integrated and optimized community tools", "dim")],
        [("  ", "default"), ("[ ]  5. Track & Project Templates", "default"), ("                          (5.6 MB)", "cyan")],
        [("       17 TrackTemplate categories (Drums, Vocals, Guitars, Master)", "dim")],
        [("  ", "default"), ("[X]  6. SWS AutoColor, Icons & Data", "green"), ("                         (43.8 MB)", "cyan")],
        [("       310+ auto-color rules, track icons, HiDPI toolbar icons", "dim")],
        [("  ", "default"), ("[X]  7. Menus, Toolbars & Screensets", "green"), ("                        (3.0 MB)", "cyan")],
        [("       Custom floating toolbars, keyboard shortcuts, and workspaces", "dim")],
        [("  ", "default"), ("[ ]  8. ReaScripts Suite", "default"), ("                                   (148.8 MB)", "cyan")],
        [("       FTC Tools, HeDa Track Inspector 2, Lokasenna GUI v2, ReaFull Manager", "dim")],
        [("  ", "default"), ("[ ]  9. Presets & FXChains", "default"), ("                                 (11.4 MB)", "cyan")],
        [("       Factory analog and digital presets, mastering and mixing chains", "dim")],
        [("  ", "default"), ("[X] 10. Studio Typography (Fonts)", "green"), ("                           (1.1 MB)", "cyan")],
        [("       TrueType/OpenType fonts installed to ~/.local/share/fonts/ReaFull/", "dim")],
        [("  ", "default"), ("[ ] 11. Linux Audio Engine Optimization", "default"), ("                    (0 KB)", "cyan")],
        [("       Realtime settings (ALSA/JACK/PipeWire), thread priority, HQ Resampling", "dim")],
        [("  ", "default"), ("[ ] 12. StripTease Modular Mixer Strip Suite", "default"), ("               (334.3 KB)", "cyan")],
        [("       Modular MCP channel strip interface with real-time GR meters", "dim")],
        [("  ", "default"), ("[ ] 13. Documentation & Resources", "default"), ("                          (881 B)", "cyan")],
        [("       Quick reference guides and documentation links", "dim")],
        [("  ", "default"), ("[X] 14. Native Extensions (SWS & ReaPack)", "green"), ("                  (0 KB)", "cyan")],
        [("       Verified Linux native binaries (SWS 2.14.0.7 & ReaPack 1.2.6)", "dim")],
        [("  ", "default"), ("[X] 15. Pro Tools Mode (ReaTooled)", "green"), ("                         (2.8 KB)", "cyan")],
        [("       Pro Tools–style editing workflow: per-track ripple, grid snap, smart tool", "dim")],
        [("", "default")],
        [("-" * 70, "dim")],
        [("  Total to install: ", "default"), ("62.5 MB", "green"), (" (2558 files)", "default")],
        [("-" * 70, "dim")],
        [("  Commands: ", "bold"), ("r (ReaTooled) | a (all) | k (core) | m (min) | c (continue)", "dim")],
        [("", "default")],
        [("Choice > ", "bold"), ("c", "green")],
    ]
    render_terminal("jules@studio: ~/ReaFull (Interactive Setup)", lines, "docs/terminal_interactive.png")

def make_install_and_verify_screenshot():
    lines = [
        [("===============================================================================", "cyan")],
        [("                     ReaFull Installation Pre-Flight Summary                   ", "cyan")],
        [("===============================================================================", "cyan")],
        [("  Target Directory     : ", "default"), ("~/.config/REAPER", "bold")],
        [("  Installation Profile : ", "default"), ("OVERLAY", "green"), (" (Shortcuts and custom INIs preserved)", "dim")],
        [("  Space Required       : ", "default"), ("62.5 MB", "green"), (" (2558 files)", "default")],
        [("  Preset               : ", "default"), ("ReaTooled + ReArtist SWS AutoColor & Design", "cyan")],
        [("-" * 65, "dim")],
        [("", "default")],
        [("[00:33:44 BACKUP] ", "cyan"), ("Creating full safety backup: ~/.config/REAPER_backup_...", "default")],
        [("[00:33:44 DEPLOY] ", "cyan"), ("Deploying selected components to: ~/.config/REAPER (OVERLAY)", "default")],
        [("[00:33:44 COMPONENT] ", "cyan"), ("Installing: Visual Themes & Splash Screen...", "default")],
        [("[00:33:44 COMPONENT] ", "cyan"), ("Installing: SWS AutoColor, Icons & Data (317 rules)...", "default")],
        [("[00:33:44 COMPONENT] ", "cyan"), ("Installing: Menus, Toolbars & Screensets...", "default")],
        [("[00:33:44 FONTS] ", "cyan"), ("Installing studio typography to ~/.local/share/fonts/ReaFull...", "default")],
        [("[00:33:44 COMPONENT] ", "cyan"), ("Installing: Native Extensions (SWS 2.14 & ReaPack 1.2.6)...", "default")],
        [("[00:33:44 COMPONENT] ", "cyan"), ("Installing: Pro Tools Mode (ReaTooled Workflow)...", "default")],
        [("[00:33:44 CONFIG] ", "cyan"), ("Applying sanitized configurations and templates...", "default")],
        [("[00:33:44 WARN] ", "yellow"), ("  [PRESERVED] Existing user reaper-kb.ini kept intact.", "yellow")],
        [("[00:33:44 OK] ", "green"), ("ReaFull files deployed successfully.", "green")],
        [("", "default")],
        [("-" * 65, "dim")],
        [("=== ReaFull Health Check for: ~/.config/REAPER ===", "bold")],
        [("", "default")],
        [("[OK] ", "green"), ("REAPER config directory exists.", "default")],
        [("[OK] ", "green"), ("ReaFull PT Dark & Pro themes installed.", "default")],
        [("[OK] ", "green"), ("SWS AutoColor & Icons configuration installed (317 rules).", "default")],
        [("[OK] ", "green"), ("Pro Tools Mode (ReaTooled) active: keymaps + config applied.", "default")],
        [("[OK] ", "green"), ("Native REAPER extensions (SWS/ReaPack) verified.", "default")],
        [("[OK] ", "green"), ("Studio typography available in fontconfig.", "default")],
        [("[OK] ", "green"), ("Clean Linux configuration: zero Windows drive paths detected.", "default")],
        [("", "default")],
        [("===============================================================================", "green")],
        [("  Status: REAFULL INSTALLATION HEALTHY & VERIFIED!                             ", "green")],
        [("===============================================================================", "green")],
    ]
    render_terminal("jules@studio: ~/ReaFull (Install & Health Check)", lines, "docs/terminal_install.png")

if __name__ == "__main__":
    make_interactive_menu_screenshot()
    make_install_and_verify_screenshot()
