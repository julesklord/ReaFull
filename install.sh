#!/usr/bin/env bash
# ==============================================================================
#  ReaFull: The Ultimate REAPER Production Suite for Linux
#  Interactive & Modular Installer Wrapper (Supports direct curl one-liner & local runs)
# ==============================================================================

set -euo pipefail

C_RESET='\033[0m'
C_BOLD='\033[1m'
C_RED='\033[91m'
C_GREEN='\033[92m'
C_YELLOW='\033[93m'
C_CYAN='\033[96m'

# Reconnect stdin to TTY if executing via curl pipe
if [ ! -t 0 ] && [ -e /dev/tty ]; then
    exec < /dev/tty
fi

# 1. Check Python3 (Mandatory)
if ! command -v python3 >/dev/null 2>&1; then
    echo -e "${C_RED}[ERROR] Python 3 no está instalado.${C_RESET}"
    echo "Instala Python 3 mediante el gestor de paquetes de tu distribución Linux (ej: sudo apt install python3 / sudo pacman -S python)."
    exit 1
fi

# 2. Check Optional Tools
RECOMMENDED_MISSING=()
if ! command -v fc-cache >/dev/null 2>&1; then
    RECOMMENDED_MISSING+=("fontconfig")
fi

if [ ${#RECOMMENDED_MISSING[@]} -ne 0 ]; then
    echo -e "${C_YELLOW}[!] Paquetes recomendados ausentes: ${RECOMMENDED_MISSING[*]}${C_RESET}"
    echo -e "    (Recomendado para actualizar la caché de fuentes tipográficas automáticamente)\n"
fi

# 3. Resolve Installation Source Directory (Local Repo vs Remote One-Liner)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || echo "")"
TEMP_DIR=""

if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/install.py" ] && [ -d "$SCRIPT_DIR/assets" ]; then
    INSTALL_SRC="$SCRIPT_DIR"
else
    echo -e "${C_BOLD}${C_CYAN}[*] Iniciando instalador de ReaFull desde la nube...${C_RESET}"
    TEMP_DIR="$(mktemp -d /tmp/reafull_setup_XXXXXX)"
    trap 'rm -rf "$TEMP_DIR"' EXIT INT TERM

    if command -v git >/dev/null 2>&1; then
        echo -e "  -> Descargando última versión de ReaFull vía git..."
        git clone --depth 1 https://github.com/julesklord/ReaFull.git "$TEMP_DIR" >/dev/null 2>&1
    else
        echo -e "  -> Descargando archivo de ReaFull..."
        curl -fsSL https://github.com/julesklord/ReaFull/archive/refs/heads/main.tar.gz | tar -xz -C "$TEMP_DIR" --strip-components=1
    fi
    INSTALL_SRC="$TEMP_DIR"
fi

# 4. Permissions & Launch Installer
chmod +x "$INSTALL_SRC/install.py" "$INSTALL_SRC/uninstall.sh" "$INSTALL_SRC/scripts/verify_installation.py" 2>/dev/null || true

python3 "$INSTALL_SRC/install.py" "$@"
