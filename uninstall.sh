#!/usr/bin/env bash
# ==============================================================================
#  ReaFull: Uninstaller & Backup Restoration Script
# ==============================================================================

set -e

C_RESET='\033[0m'
C_BOLD='\033[1m'
C_RED='\033[91m'
C_GREEN='\033[92m'
C_YELLOW='\033[93m'
C_BLUE='\033[94m'

CONFIG_DIR="${1:-$HOME/.config/REAPER}"

echo -e "${C_BOLD}${C_BLUE}[*] ReaFull Backup Restoration Utility${C_RESET}"
echo -e "Target REAPER Directory: ${C_BOLD}$CONFIG_DIR${C_RESET}\n"

# Search for available backups
BACKUPS=($(ls -d ${CONFIG_DIR}_backup_pre_* 2>/dev/null | sort -r))

if [ ${#BACKUPS[@]} -eq 0 ]; then
    echo -e "${C_YELLOW}[!] No ReaFull backups found matching pattern: ${CONFIG_DIR}_backup_pre_*${C_RESET}"
    exit 1
fi

echo -e "Available backups:"
for i in "${!BACKUPS[@]}"; do
    echo -e "  [$i] $(basename "${BACKUPS[$i]}")"
done

echo ""
read -p "Select backup index to restore [0-$((${#BACKUPS[@]}-1))]: " CHOICE

if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || [ "$CHOICE" -ge "${#BACKUPS[@]}" ]; then
    echo -e "${C_RED}[ERROR] Invalid selection.${C_RESET}"
    exit 1
fi

SELECTED_BACKUP="${BACKUPS[$CHOICE]}"
echo -e "\n${C_YELLOW}Restoring from: $SELECTED_BACKUP${C_RESET}"
read -p "Are you sure you want to overwrite $CONFIG_DIR with this backup? [y/N]: " CONFIRM

if [[ "$CONFIRM" =~ ^[yYsS] ]]; then
    rm -rf "$CONFIG_DIR"
    cp -r "$SELECTED_BACKUP" "$CONFIG_DIR"
    echo -e "${C_GREEN}[+] Backup restored successfully!${C_RESET}"
else
    echo "Restoration cancelled."
fi
