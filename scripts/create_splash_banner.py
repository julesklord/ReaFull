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
    # 1. Base Canvas - Deep Obsidian Anthracite
    img = Image.new("RGBA", (WIDTH, HEIGHT), (14, 16, 20, 255))
    draw = ImageDraw.Draw(img)

    # Subtle radial luminance at upper center (studio backlight effect)
    cx, cy = WIDTH // 2, 160
    for y in range(HEIGHT):
        for x in range(0, WIDTH, 2):
            dx = (x - cx) / (WIDTH * 0.55)
            dy = (y - cy) / (HEIGHT * 0.45)
            dist_sq = dx * dx + dy * dy
            if dist_sq < 1.0:
                glow = math.exp(-dist_sq * 2.2) * 12
                # Sample base color and add subtle glow
                r = int(14 + glow * 0.9)
                g = int(16 + glow * 1.0)
                b = int(21 + glow * 1.3)
                draw.point((x, y), fill=(r, g, b, 255))
                draw.point((x + 1, y), fill=(r, g, b, 255))

    # 2. Subtle Precision Outer Frame (1px hairline)
    draw.rectangle([0, 0, WIDTH - 1, HEIGHT - 1], outline=(28, 33, 42, 255), width=1)
    draw.rectangle([1, 1, WIDTH - 2, HEIGHT - 2], outline=(18, 21, 27, 255), width=1)

    # 3. Minimalist Monogram / Geometric Audio Wave Emblem
    # A sleek, modern minimalist audio pulse glyph above the wordmark
    emblem_y = 112
    emblem_cx = WIDTH // 2

    # 5 subtle vertical bars with rounded caps (minimal audio wave)
    bar_heights = [14, 26, 40, 26, 14]
    bar_width = 3
    bar_spacing = 8
    start_bx = emblem_cx - (len(bar_heights) * bar_spacing) // 2

    for i, bh in enumerate(bar_heights):
        bx = start_bx + i * bar_spacing
        by1 = emblem_y - bh // 2
        by2 = emblem_y + bh // 2
        alpha = 255 if i == 2 else (200 if i in [1, 3] else 140)
        # Subtle warm champagne gold accent for the center bar
        color = (212, 175, 55, alpha) if i == 2 else (148, 163, 184, alpha)
        draw.rounded_rectangle([bx, by1, bx + bar_width, by2], radius=1, fill=color)

    # 4. Wordmark: "R E A F U L L"
    font_main = ImageFont.truetype(FONT_DEJAVU_BOLD, 34)
    wordmark = "R E A F U L L"
    bbox = font_main.getbbox(wordmark)
    tw = bbox[2] - bbox[0]
    wx = (WIDTH - tw) // 2
    wy = 158

    # Soft ambient drop shadow
    shadow_layer = Image.new("RGBA", (WIDTH, HEIGHT), (0, 0, 0, 0))
    sdraw = ImageDraw.Draw(shadow_layer)
    sdraw.text((wx, wy + 2), wordmark, font=font_main, fill=(0, 0, 0, 180))
    shadow_layer = shadow_layer.filter(ImageFilter.GaussianBlur(radius=3))
    img = Image.alpha_composite(img, shadow_layer)
    draw = ImageDraw.Draw(img)

    # Crisp white-silver wordmark
    draw.text((wx, wy), wordmark, font=font_main, fill=(245, 247, 250, 255))

    # 5. Clean Subtitle
    font_sub = ImageFont.truetype(FONT_DEJAVU, 10)
    subtitle = "STUDIO CONSOLE & PRODUCTION SUITE FOR LINUX"
    s_bbox = font_sub.getbbox(subtitle)
    stw = s_bbox[2] - s_bbox[0]
    sx = (WIDTH - stw) // 2
    sy = 212
    draw.text((sx, sy), subtitle, font=font_sub, fill=(130, 142, 160, 255))

    # 6. Ultra-thin Accent Divider
    divider_w = 260
    d_x1 = (WIDTH - divider_w) // 2
    d_x2 = d_x1 + divider_w
    d_y = 246
    draw.line([d_x1, d_y, d_x2, d_y], fill=(36, 42, 54, 255), width=1)
    # Subtle champagne center pip
    draw.ellipse([WIDTH // 2 - 2, d_y - 2, WIDTH // 2 + 2, d_y + 2], fill=(212, 175, 55, 200))

    # Version tag & discrete engine badge
    font_micro = ImageFont.truetype(FONT_DEJAVU, 8)
    draw.text((45, 30), "DISCRETE 64-BIT DSP", font=font_micro, fill=(70, 80, 98, 255))
    draw.text((WIDTH - 110, 30), "LINUX NATIVE", font=font_micro, fill=(70, 80, 98, 255))

    # 7. Integrated Loading Bay (Clean, Recessed OLED Strip)
    # REAPER renders status text at the bottom. This container frames it with perfection.
    bay_margin_x = 45
    bay_y1 = 330
    bay_y2 = 405
    bay_w = WIDTH - bay_margin_x * 2

    # Recessed well background
    draw.rounded_rectangle([bay_margin_x, bay_y1, bay_margin_x + bay_w, bay_y2], radius=4, fill=(9, 11, 14, 255), outline=(24, 28, 36, 255), width=1)

    # Top indicator inside the bay
    draw.text((bay_margin_x + 14, bay_y1 + 8), "SYSTEM READY", font=font_micro, fill=(56, 189, 248, 220))
    draw.text((bay_margin_x + bay_w - 60, bay_y1 + 8), "v2026.1.0", font=font_micro, fill=(100, 112, 130, 255))

    # REAPER dynamic progress bar groove / guide line
    groove_y = bay_y2 - 14
    draw.line([bay_margin_x + 14, groove_y, bay_margin_x + bay_w - 14, groove_y], fill=(18, 22, 28, 255), width=2)

    # Save
    out_branding = "assets/branding/Splash ReaFull.png"
    out_assets = "assets/Splash ReaFull.png"
    out_docs = "docs/Splash ReaFull.png"

    os.makedirs("assets/branding", exist_ok=True)
    os.makedirs("docs", exist_ok=True)

    img.save(out_branding)
    img.save(out_assets)
    img.save(out_docs)

    print(f"[+] Rendered minimalist premium splash: {WIDTH}x{HEIGHT}")

if __name__ == "__main__":
    render_premium_splash()
