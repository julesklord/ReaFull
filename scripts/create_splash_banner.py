#!/usr/bin/env python3
"""
ReaFull: Ultra-Minimalist High-End Studio Splash Screen.
Inspired by Scandinavian audio design (Teenage Engineering, LUNA, Bitwig, Leica):
- Deep anthracite obsidian matte finish
- Flawless minimalist typography with precision kerning
- Subtle champagne/gold hairline accents and minimalist monogram
- Clean, uncluttered recessed OLED loading bay for REAPER dynamic initialization
"""

import os
import math
from PIL import Image, ImageDraw, ImageFont, ImageFilter

WIDTH = 760
HEIGHT = 440

# Fonts
FONT_DEJAVU_BOLD = "/usr/share/fonts/TTF/DejaVuSans-Bold.ttf"
if not os.path.exists(FONT_DEJAVU_BOLD):
    FONT_DEJAVU_BOLD = "/usr/share/fonts/TTF/DejaVuSansMono-Bold.ttf"

FONT_DEJAVU = "/usr/share/fonts/TTF/DejaVuSans.ttf"
if not os.path.exists(FONT_DEJAVU):
    FONT_DEJAVU = "/usr/share/fonts/TTF/DejaVuSansMono.ttf"

def render_premium_splash():
    # 1. Base Canvas - Deep Slate Navy (#0F172A)
    img = Image.new("RGBA", (WIDTH, HEIGHT), (15, 23, 42, 255))
    draw = ImageDraw.Draw(img)

    # 2. Subtle Precision Outer Frame (1px flat border)
    draw.rectangle([0, 0, WIDTH - 1, HEIGHT - 1], outline=(30, 41, 59, 255), width=1)
    draw.rectangle([1, 1, WIDTH - 2, HEIGHT - 2], outline=(15, 23, 42, 255), width=1)

    # 3. Paste the Official Flat Logomark
    logo_path = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "docs", "logo_mark.png")
    if os.path.exists(logo_path):
        logo_img = Image.open(logo_path).convert("RGBA")
        # Resize logomark to 110x110
        logo_resized = logo_img.resize((110, 110), Image.Resampling.LANCZOS)
        logo_x = (WIDTH - 110) // 2
        logo_y = 36
        img.paste(logo_resized, (logo_x, logo_y), logo_resized)
    else:
        # Fallback procedural drawing of wave bars
        pass

    # 4. Wordmark: "R E A F U L L"
    font_main = ImageFont.truetype(FONT_DEJAVU_BOLD, 32)
    wordmark = "R E A F U L L"
    bbox = font_main.getbbox(wordmark)
    tw = bbox[2] - bbox[0]
    wx = (WIDTH - tw) // 2
    wy = 160

    # Crisp white wordmark
    draw.text((wx, wy), wordmark, font=font_main, fill=(248, 250, 252, 255))

    # 5. Clean Subtitle
    font_sub = ImageFont.truetype(FONT_DEJAVU, 10)
    subtitle = "STUDIO PRODUCTION & MIXING SUITE FOR LINUX"
    s_bbox = font_sub.getbbox(subtitle)
    stw = s_bbox[2] - s_bbox[0]
    sx = (WIDTH - stw) // 2
    sy = 206
    draw.text((sx, sy), subtitle, font=font_sub, fill=(148, 163, 184, 255))

    # 6. Flat Accent Divider with Teal Cyan Pip
    divider_w = 260
    d_x1 = (WIDTH - divider_w) // 2
    d_x2 = d_x1 + divider_w
    d_y = 236
    draw.line([d_x1, d_y, d_x2, d_y], fill=(30, 41, 59, 255), width=1)
    # Teal cyan center pip (#00D2BE)
    draw.ellipse([WIDTH // 2 - 3, d_y - 3, WIDTH // 2 + 3, d_y + 3], fill=(0, 210, 190, 255))

    # Version tag & discrete engine badge
    font_micro = ImageFont.truetype(FONT_DEJAVU, 8)
    draw.text((45, 26), "64-BIT LINUX DSP", font=font_micro, fill=(100, 116, 139, 255))
    draw.text((WIDTH - 120, 26), "REAPER EDITION", font=font_micro, fill=(100, 116, 139, 255))

    # 7. Integrated Loading Bay for REAPER
    bay_margin_x = 45
    bay_y1 = 325
    bay_y2 = 405
    bay_w = WIDTH - bay_margin_x * 2

    # Flat recessed container
    draw.rounded_rectangle([bay_margin_x, bay_y1, bay_margin_x + bay_w, bay_y2], radius=4, fill=(10, 15, 29, 255), outline=(30, 41, 59, 255), width=1)

    # Top indicator inside the bay
    draw.text((bay_margin_x + 14, bay_y1 + 8), "SYSTEM READY", font=font_micro, fill=(0, 210, 190, 255))
    draw.text((bay_margin_x + bay_w - 60, bay_y1 + 8), "v2026.2.0", font=font_micro, fill=(100, 116, 139, 255))

    # Guide line
    groove_y = bay_y2 - 14
    draw.line([bay_margin_x + 14, groove_y, bay_margin_x + bay_w - 14, groove_y], fill=(20, 30, 50, 255), width=2)

    # Save
    out_branding = "assets/branding/Splash ReaFull.png"
    out_assets = "assets/Splash ReaFull.png"
    out_docs = "docs/Splash ReaFull.png"

    os.makedirs("assets/branding", exist_ok=True)
    os.makedirs("docs", exist_ok=True)

    img.save(out_branding)
    img.save(out_assets)
    img.save(out_docs)

    print(f"[+] Rendered flat visual identity splash: {WIDTH}x{HEIGHT}")

if __name__ == "__main__":
    render_premium_splash()
