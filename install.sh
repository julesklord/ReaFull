#!/usr/bin/env bash
# ==============================================================================
#  ReaFull: The Ultimate REAPER Production Suite for Linux
#  Interactive & Modular Installer Wrapper
# ==============================================================================

set -euo pipefail

C_RESET='\033[0m'
C_BOLD='\033[1m'
C_RED='\033[91m'
C_GREEN='\033[92m'
C_YELLOW='\033[93m'
C_CYAN='\033[96m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Check Python3 (Mandatory)
if ! command -v python3 >/dev/null 2>&1; then
    echo -e "${C_RED}[ERROR] Python 3 is not installed.${C_RESET}"
    echo "Install Python 3 using your Linux distribution's package manager (e.g. sudo apt install python3 / sudo pacman -S python)."
    exit 1
fi

# 2. Check Optional Tools
RECOMMENDED_MISSING=()
if ! command -v fc-cache >/dev/null 2>&1; then
    RECOMMENDED_MISSING+=("fontconfig")
fi

if [ ${#RECOMMENDED_MISSING[@]} -ne 0 ]; then
    echo -e "${C_YELLOW}[!] Missing recommended packages: ${RECOMMENDED_MISSING[*]}${C_RESET}"
    echo -e "    (Recommended to automatically update the font cache)\n"
fi

# 3. Permissions & Exec
chmod +x "$SCRIPT_DIR/install.py" "$SCRIPT_DIR/uninstall.sh" "$SCRIPT_DIR/scripts/verify_installation.py" 2>/dev/null || true

exec python3 "$SCRIPT_DIR/install.py" "$@"
