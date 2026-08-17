#!/usr/bin/env python3
r"""
Sanitizes reaper-fxfolders.ini to remove broken Windows C:\Program Files paths
while preserving JSFX plugins, Cockos plugins, and clean folder structures.
"""
import os
import re

REPO_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CONFIG_TEMPLATES_DIR = os.path.join(REPO_DIR, "config_templates")
FXFOLDERS_PATH = os.path.join(CONFIG_TEMPLATES_DIR, "reaper-fxfolders.ini")

def clean_fxfolders():
    if not os.path.exists(FXFOLDERS_PATH):
        return

    with open(FXFOLDERS_PATH, "r", encoding="utf-8", errors="ignore") as f:
        lines = f.readlines()

    out_lines = []
    cur_sec = None
    items_in_sec = []

    def flush_section():
        nonlocal cur_sec, items_in_sec, out_lines
        if cur_sec is None:
            return
        out_lines.append(f"[{cur_sec}]\n")
        if cur_sec == "developer":
            for item in items_in_sec:
                out_lines.append(item)
        else:
            idx = 0
            for item in items_in_sec:
                if "=" in item:
                    k, v = item.split("=", 1)
                    v_clean = v.strip()
                    if re.match(r'^[a-zA-Z]:\\', v_clean):
                        m = re.search(r'\\(rea[a-z0-9_]+)\.dll', v_clean, re.IGNORECASE)
                        if m:
                            v_clean = f"VST:{m.group(1)} (Cockos)"
                        else:
                            continue
                    if v_clean.startswith("JS:"):
                        v_clean = v_clean.replace("\\", "/")
                    v_clean = v_clean.replace("ReArtist Analog FX", "ReaFull Analog FX").replace("ReArtist Digital FX", "ReaFull Digital FX")
                    out_lines.append(f"Item{idx}={v_clean}\n")
                    idx += 1
                else:
                    out_lines.append(item)
            out_lines.append(f"Nb={idx}\n")
        items_in_sec = []

    for line in lines:
        line_s = line.strip()
        if line_s.startswith("[") and line_s.endswith("]"):
            flush_section()
            cur_sec = line_s[1:-1]
        else:
            if not line_s.startswith("Nb="):
                items_in_sec.append(line)

    flush_section()

    with open(FXFOLDERS_PATH, "w", encoding="utf-8") as f:
        f.writelines(out_lines)
    print("[+] reaper-fxfolders.ini sanitized successfully.")

if __name__ == "__main__":
    clean_fxfolders()
