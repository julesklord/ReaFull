#!/usr/bin/env bash
# ==============================================================================
#  ReaFull: The Ultimate REAPER Production Suite for Linux
#  Installer Script
# ==============================================================================

set -e

# Colors
C_RESET='\033[0m'
C_BOLD='\033[1m'
C_RED='\033[91m'
C_GREEN='\033[92m'
C_YELLOW='\033[93m'
C_BLUE='\033[94m'
C_CYAN='\033[96m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${C_BOLD}${C_CYAN}"
cat << "EOF"
  ____            _____       _ _ 
 |  _ \ ___  __ _|  ___|   _ | | |
 | |_) / _ \/ _` | |_ | | | || | |
 |  _ <  __/ (_| |  _|| |_| || | |
 |_| \_\___|\__,_|_|   \__,_||_|_|
                                  
  Professional DAW Suite for Linux
EOF
echo -e "${C_RESET}"

# 1. Dependency checks
echo -e "${C_BOLD}${C_BLUE}[*] Checking system dependencies...${C_RESET}"

MISSING_DEPS=()

if ! command -v python3 &>/dev/null; then
    MISSING_DEPS+=("python3")
fi

if ! command -v fc-cache &>/dev/null; then
    MISSING_DEPS+=("fontconfig")
fi

if ! command -v curl &>/dev/null; then
    MISSING_DEPS+=("curl")
fi

if [ ${#MISSING_DEPS[@]} -ne 0 ]; then
    echo -e "${C_YELLOW}[!] Warning: Missing recommended dependencies: ${MISSING_DEPS[*]}${C_RESET}"
    echo -e "    Please install them with your package manager (e.g. pacman -S ${MISSING_DEPS[*]} / apt install ${MISSING_DEPS[*]})."
fi

# Check SWS and ReaPack
if [ ! -f "/usr/lib/sws/reaper_sws-x86_64.so" ] && [ ! -f "$HOME/.config/REAPER/UserPlugins/reaper_sws-x86_64.so" ]; then
    echo -e "${C_YELLOW}[i] SWS extension not found in system paths. We recommend installing it via your package manager or ReaPack.${C_RESET}"
fi

# Run the installer engine
chmod +x "$SCRIPT_DIR/install.py"
python3 "$SCRIPT_DIR/install.py" "$@"
