#!/usr/bin/env bash
# ==============================================================================
#  ReaFull: Uninstaller & Backup Restoration Utility for Linux REAPER
#  Author: Jules Martins / ReaFull Team
# ==============================================================================

set -euo pipefail

C_RESET='\033[0m'
C_BOLD='\033[1m'
C_RED='\033[91m'
C_GREEN='\033[92m'
C_YELLOW='\033[93m'
C_BLUE='\033[94m'
C_CYAN='\033[96m'

echo -e "${C_BOLD}${C_CYAN}"
echo "  ____            _____       _ _ "
echo " |  _ \\ ___  __ _|  ___|   _ | | |"
echo " | |_) / _ \\/ _\` | |_ | | | || | |"
echo " |  _ <  __/ (_| |  _|| |_| || | |"
echo " |_| \\_\\___|\\__,_|_|   \\__,_||_|_|"
echo -e "${C_RESET}"
echo -e "${C_BOLD}Herramienta de Desinstalación y Restauración de ReaFull${C_RESET}\n"

# 1. Resolve Target REAPER Directory
NATIVE_DIR="$HOME/.config/REAPER"
FLATPAK_DIR="$HOME/.var/app/fm.reaper.Reaper/config/REAPER"
CONFIG_DIR=""

if [ -n "${1:-}" ]; then
    CONFIG_DIR="$1"
elif [ -d "$NATIVE_DIR" ] && [ -d "$FLATPAK_DIR" ]; then
    echo -e "${C_YELLOW}[?] Se detectaron múltiples instalaciones de REAPER:${C_RESET}"
    echo "    1. REAPER Nativo ($NATIVE_DIR)"
    echo "    2. REAPER Flatpak ($FLATPAK_DIR)"
    read -r -p "Selecciona destino [1/2] (por defecto 1): " CHOICE_DIR
    if [ "$CHOICE_DIR" = "2" ]; then
        CONFIG_DIR="$FLATPAK_DIR"
    else
        CONFIG_DIR="$NATIVE_DIR"
    fi
elif [ -d "$FLATPAK_DIR" ]; then
    CONFIG_DIR="$FLATPAK_DIR"
else
    CONFIG_DIR="$NATIVE_DIR"
fi

echo -e "Directorio objetivo: ${C_BOLD}$CONFIG_DIR${C_RESET}\n"

# 2. Check if REAPER is currently running
if pgrep -i reaper >/dev/null 2>&1; then
    echo -e "${C_YELLOW}[WARN] REAPER está ejecutándose actualmente.${C_RESET}"
    read -r -p "¿Deseas continuar de todas formas? [y/N]: " PROCEED_RUNNING
    if ! [[ "$PROCEED_RUNNING" =~ ^[yYsS] ]]; then
        echo "Operación cancelada para cerrar REAPER primero."
        exit 0
    fi
fi

# 3. Main Action Menu
echo -e "${C_BOLD}Selecciona la acción a realizar:${C_RESET}"
echo "  1. Restaurar una copia de seguridad previa (Backup Restore)"
echo "  2. Desinstalar componentes de ReaFull (Temas, FX, fuentes)"
echo "  3. Eliminar copias de seguridad antiguas de ReaFull (Liberar espacio)"
echo "  4. Cancelar y salir"
echo ""
read -r -p "Opción [1-4]: " ACTION_CHOICE

case "$ACTION_CHOICE" in
    1)
        # Restore Backup
        echo -e "\n${C_BLUE}[*] Buscando copias de seguridad de ReaFull...${C_RESET}"
        mapfile -t BACKUPS < <(find "$(dirname "$CONFIG_DIR")" -maxdepth 1 -name "$(basename "$CONFIG_DIR")_backup_pre_*" -type d | sort -r)

        if [ ${#BACKUPS[@]} -eq 0 ]; then
            echo -e "${C_YELLOW}[!] No se encontraron copias de seguridad previas para $CONFIG_DIR.${C_RESET}"
            exit 1
        fi

        echo -e "\nCopias de seguridad disponibles:"
        for i in "${!BACKUPS[@]}"; do
            BACKUP_NAME=$(basename "${BACKUPS[$i]}")
            BACKUP_SIZE=$(du -sh "${BACKUPS[$i]}" 2>/dev/null | cut -f1)
            echo -e "  [$i] ${C_BOLD}${BACKUP_NAME}${C_RESET} (${BACKUP_SIZE})"
        done
        echo ""
        read -r -p "Selecciona el índice de la copia a restaurar [0-$((${#BACKUPS[@]}-1))]: " B_IDX

        if ! [[ "$B_IDX" =~ ^[0-9]+$ ]] || [ "$B_IDX" -ge "${#BACKUPS[@]}" ]; then
            echo -e "${C_RED}[ERROR] Selección no válida.${C_RESET}"
            exit 1
        fi

        SELECTED_BACKUP="${BACKUPS[$B_IDX]}"
        echo -e "\n${C_YELLOW}Restaurando desde: $SELECTED_BACKUP${C_RESET}"
        read -r -p "¿Estás seguro de sobrescribir $CONFIG_DIR con este respaldo? [y/N]: " CONFIRM_RESTORE

        if [[ "$CONFIRM_RESTORE" =~ ^[yYsS] ]]; then
            rm -rf "$CONFIG_DIR"
            cp -r "$SELECTED_BACKUP" "$CONFIG_DIR"
            echo -e "${C_GREEN}[OK] ¡Copia de seguridad restaurada exitosamente!${C_RESET}"
        else
            echo "Restauración cancelada."
        fi
        ;;

    2)
        # Uninstall ReaFull Components
        echo -e "\n${C_YELLOW}[!] Desinstalando componentes de ReaFull...${C_RESET}"
        read -r -p "¿Confirmas la eliminación de los temas, suites JSFX y fuentes de ReaFull? [y/N]: " CONFIRM_UNINSTALL

        if [[ "$CONFIRM_UNINSTALL" =~ ^[yYsS] ]]; then
            # Remove themes
            rm -f "$CONFIG_DIR/ColorThemes/ReaFull"*.ReaperThemeZip
            rm -f "$CONFIG_DIR/Splash ReaFull.png"
            # Remove JSFX Suites
            rm -rf "$CONFIG_DIR/Effects/ReaFull Analog FX"
            rm -rf "$CONFIG_DIR/Effects/ReaFull Digital FX"
            # Remove ReaFull scripts
            rm -rf "$CONFIG_DIR/Scripts/ReaFull"
            # Remove Fonts
            FONTS_DIR="$HOME/.local/share/fonts/ReaFull"
            if [ -d "$FONTS_DIR" ]; then
                rm -rf "$FONTS_DIR"
                if command -v fc-cache >/dev/null 2>&1; then
                    fc-cache -f "$HOME/.local/share/fonts" >/dev/null 2>&1 || true
                fi
                echo -e "  -> Fuentes tipográficas de ReaFull desinstaladas."
            fi
            echo -e "${C_GREEN}[OK] Componentes de ReaFull desinstalados con éxito.${C_RESET}"
        else
            echo "Desinstalación cancelada."
        fi
        ;;

    3)
        # Clean Old Backups
        mapfile -t BACKUPS < <(find "$(dirname "$CONFIG_DIR")" -maxdepth 1 -name "$(basename "$CONFIG_DIR")_backup_pre_*" -type d | sort -r)
        if [ ${#BACKUPS[@]} -eq 0 ]; then
            echo -e "${C_YELLOW}[!] No hay copias de seguridad de ReaFull para eliminar.${C_RESET}"
            exit 0
        fi

        echo -e "\n${C_YELLOW}Se encontraron ${#BACKUPS[@]} copias de seguridad:${C_RESET}"
        for b in "${BACKUPS[@]}"; do
            echo "  - $(basename "$b") ($(du -sh "$b" | cut -f1))"
        done
        echo ""
        read -r -p "¿Deseas eliminar TODAS las copias de seguridad anteriores? [y/N]: " CONFIRM_CLEAN_BACKUPS

        if [[ "$CONFIRM_CLEAN_BACKUPS" =~ ^[yYsS] ]]; then
            for b in "${BACKUPS[@]}"; do
                rm -rf "$b"
                echo "  -> Eliminado: $(basename "$b")"
            done
            echo -e "${C_GREEN}[OK] Copias de seguridad eliminadas correctamente.${C_RESET}"
        else
            echo "Operación cancelada."
        fi
        ;;

    *)
        echo "Operación cancelada."
        exit 0
        ;;
esac
