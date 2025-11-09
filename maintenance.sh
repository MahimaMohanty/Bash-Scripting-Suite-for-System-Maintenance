#!/bin/bash
# ==============================================================
#   🌟 SYSTEM MAINTENANCE SUITE (Revamped Version)
#   Automates Backups, Updates, Cleanup & Log Monitoring
#   With Colors, Animations, Error Handling & Logging
# ==============================================================

# ---------- COLORS ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[1;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ---------- CONFIGURATION ----------
BACKUP_SRC="$HOME/Documents"
BACKUP_DEST="$HOME/backup"
BACKUP_LOG="$BACKUP_DEST/backup_log.txt"
UPDATE_LOG="$HOME/system_update_log.txt"
MONITOR_LOG="/var/log/syslog"  # Modify for other distros
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')

# ---------- ANIMATION ----------
spinner() {
    local pid=$!
    local delay=0.1
    local spin='|/-\'
    while kill -0 $pid 2>/dev/null; do
        for c in $spin; do
            printf "\r[%c]  " "$c"
            sleep $delay
        done
    done
    printf "\r     \r"
}

# ---------- UTILITY ----------
log_message() {
    local logfile=$1
    local message=$2
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message" >> "$logfile"
}

# ---------- BACKUP FUNCTION ----------
backup_system() {
    echo -e "\n${CYAN}${BOLD}🔄 Starting System Backup...${NC}"
    mkdir -p "$BACKUP_DEST"

    if [ ! -d "$BACKUP_SRC" ]; then
        echo -e "${RED}❌ Source directory not found!${NC}"
        log_message "$BACKUP_LOG" "Backup failed: source missing."
        return 1
    fi

    echo -ne "${YELLOW}Compressing files...${NC}"
    tar -czf "$BACKUP_DEST/backup_$TIMESTAMP.tar.gz" "$BACKUP_SRC" & spinner

    if [ $? -eq 0 ]; then
        echo -e "\n${GREEN}✅ Backup successful!${NC}"
        log_message "$BACKUP_LOG" "Backup completed successfully."
    else
        echo -e "\n${RED}❌ Backup failed!${NC}"
        log_message "$BACKUP_LOG" "Backup failed!"
    fi
}

# ---------- SYSTEM UPDATE FUNCTION ----------
update_cleanup() {
    echo -e "\n${CYAN}${BOLD}🔧 Running System Update & Cleanup...${NC}"
    log_message "$UPDATE_LOG" "Update started."

    echo -ne "${YELLOW}Updating system...${NC}"
    (sudo apt update -y && sudo apt upgrade -y >> "$UPDATE_LOG" 2>&1) & spinner

    echo -ne "${YELLOW}\nCleaning unnecessary packages...${NC}"
    (sudo apt autoremove -y && sudo apt autoclean -y >> "$UPDATE_LOG" 2>&1) & spinner

    if [ $? -eq 0 ]; then
        echo -e "\n${GREEN}✅ Update & cleanup done!${NC}"
        log_message "$UPDATE_LOG" "System update completed successfully."
    else
        echo -e "\n${RED}❌ Update encountered errors!${NC}"
        log_message "$UPDATE_LOG" "System update failed."
    fi
}

# ---------- LOG MONITOR FUNCTION ----------
monitor_logs() {
    echo -e "\n${MAGENTA}${BOLD}🧾 Real-time Log Monitoring (Ctrl+C to stop)${NC}"
    FILTER="error|fail|critical|warn"
    echo -e "${YELLOW}Showing entries matching: ${FILTER}${NC}"
    sudo tail -F "$MONITOR_LOG" | grep --line-buffered -iE "$FILTER"
}

# ---------- EXIT FUNCTION ----------
exit_suite() {
    echo -e "\n${BLUE}${BOLD}👋 Exiting Maintenance Suite. Bye!${NC}"
    exit 0
}

# ---------- MAIN MENU ----------
while true; do
    clear
    echo -e "${BLUE}${BOLD}================================================="
    echo "         🧰 SYSTEM MAINTENANCE SUITE"
    echo "=================================================${NC}"

    echo -e "${YELLOW}1️⃣  Run System Backup"
    echo "2️⃣  Run System Update & Cleanup"
    echo "3️⃣  Monitor Logs"
    echo "4️⃣  Exit${NC}"

    echo -ne "${CYAN}Enter your choice [1-4]: ${NC}"
    read -r choice

    case $choice in
        1) backup_system ;;
        2) update_cleanup ;;
        3) monitor_logs ;;
        4) exit_suite ;;
        *) echo -e "${RED}⚠️ Invalid choice!${NC}" ;;
    esac

    echo
    read -p "Press Enter to return to menu..."
done
