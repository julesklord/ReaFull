#!/usr/bin/env bash
# ==============================================================================
#  ReaFull: The Ultimate REAPER Production Suite for Linux
#  Interactive & Modular Installer Wrapper
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

# 1. Dependency checks
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
    echo -e "${C_YELLOW}[!] Advertencia: Faltan dependencias recomendadas: ${MISSING_DEPS[*]}${C_RESET}"
    echo -e "    Instálalas con tu gestor de paquetes (ej: sudo pacman -S ${MISSING_DEPS[*]} o apt install ${MISSING_DEPS[*]})."
fi

# Make scripts executable
chmod +x "$SCRIPT_DIR/install.py" "$SCRIPT_DIR/uninstall.sh" 2>/dev/null || true

# Run Python interactive/modular installer
exec python3 "$SCRIPT_DIR/install.py" "$@"
