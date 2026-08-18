#!/usr/bin/env bash
# ==============================================================================
#  ReaFull: The Ultimate REAPER Production Suite for Linux
#  Interactive & Modular Installer Wrapper (Lightweight Git + GitHub Releases Assets)
# ==============================================================================

set -euo pipefail

C_RESET='\033[0m'
C_BOLD='\033[1m'
C_RED='\033[91m'
C_GREEN='\033[92m'
C_YELLOW='\033[93m'
C_CYAN='\033[96m'

VERSION="2026.2.0"
ASSETS_RELEASE_URL="https://github.com/julesklord/ReaFull/releases/download/v${VERSION}/reafull-assets-v${VERSION}.tar.gz"

# Reconnect stdin to TTY only if executing via curl pipe in interactive mode
IS_QUIET=0
for arg in "$@"; do
    if [ "$arg" = "--quiet" ] || [ "$arg" = "-q" ]; then
        IS_QUIET=1
        break
    fi
done

if [ "$IS_QUIET" -eq 0 ] && [ ! -t 0 ] && [ -r /dev/tty ] && [ -w /dev/tty ]; then
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

if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/install.py" ]; then
    INSTALL_SRC="$SCRIPT_DIR"
else
    echo -e "${C_BOLD}${C_CYAN}[*] Obteniendo el instalador de ReaFull desde GitHub...${C_RESET}"
    TEMP_DIR="$(mktemp -d /tmp/reafull_setup_XXXXXX)"
    trap 'rm -rf "$TEMP_DIR"' EXIT INT TERM

    if command -v git >/dev/null 2>&1; then
        git clone --depth 1 https://github.com/julesklord/ReaFull.git "$TEMP_DIR" >/dev/null 2>&1
    else
        curl -fsSL https://github.com/julesklord/ReaFull/archive/refs/heads/main.tar.gz | tar -xz -C "$TEMP_DIR" --strip-components=1
    fi
    INSTALL_SRC="$TEMP_DIR"
fi

# 4. Check & Download Assets from GitHub Releases if not present locally
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/reafull"

if [ ! -d "$INSTALL_SRC/assets" ]; then
    if [ -d "$CACHE_DIR/assets" ] && [ -d "$CACHE_DIR/assets/Effects" ]; then
        echo -e "${C_GREEN}[*] Utilizando assets de ReaFull en caché (~/.cache/reafull/assets)${C_RESET}"
        ln -s "$CACHE_DIR/assets" "$INSTALL_SRC/assets" 2>/dev/null || cp -rs "$CACHE_DIR/assets" "$INSTALL_SRC/assets"
    else
        echo -e "${C_BOLD}${C_CYAN}[*] Descargando componentes de estudio de ReaFull (GitHub Releases CDN)...${C_RESET}"
        mkdir -p "$CACHE_DIR"
        
        if command -v curl >/dev/null 2>&1; then
            curl -# -L -o "$CACHE_DIR/assets.tar.gz" "$ASSETS_RELEASE_URL"
        elif command -v wget >/dev/null 2>&1; then
            wget --show-progress -q -O "$CACHE_DIR/assets.tar.gz" "$ASSETS_RELEASE_URL"
        else
            echo -e "${C_RED}[ERROR] Se requiere 'curl' o 'wget' para descargar los assets.${C_RESET}"
            exit 1
        fi

        echo -e "  -> Descomprimiendo suites JSFX, temas, plantillas y fuentes..."
        tar -xzf "$CACHE_DIR/assets.tar.gz" -C "$CACHE_DIR"
        ln -s "$CACHE_DIR/assets" "$INSTALL_SRC/assets" 2>/dev/null || cp -rs "$CACHE_DIR/assets" "$INSTALL_SRC/assets"
        echo -e "${C_GREEN}[OK] Componentes de audio listos.${C_RESET}\n"
    fi
fi

# 5. Permissions & Launch Installer
chmod +x "$INSTALL_SRC/install.py" "$INSTALL_SRC/uninstall.sh" "$INSTALL_SRC/scripts/verify_installation.py" 2>/dev/null || true

python3 "$INSTALL_SRC/install.py" "$@"
