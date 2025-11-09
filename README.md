# 🌟 System Maintenance Suite (Bash Script)

A fully automated **System Maintenance Suite** written in Bash, designed to help Linux users perform routine system maintenance tasks such as **backups**, **system updates**, **cleanup**, and **real-time log monitoring** with color-coded output, animations, and logging.

---

## 📂 Features

- **System Backup**
  - Compress and backup specified directories.
  - Logs backup status with timestamps.
  - Error handling for missing directories.

- **System Update & Cleanup**
  - Updates system packages using `apt`.
  - Cleans old packages with `autoremove` and `autoclean`.
  - Logs update and cleanup processes.

- **Real-time Log Monitoring**
  - Monitors system logs for keywords: `error`, `fail`, `critical`, `warn`.
  - Displays filtered results in real-time.

- **Interactive Menu**
  - Color-coded and animated menu for easy navigation.
  - Handles invalid input gracefully.

- **Logging**
  - Creates logs for backup and update operations for later reference.

---

## 🎨 Colors & Animations

- Uses ANSI escape codes for colors:
  - Red: Errors  
  - Green: Success  
  - Yellow: Warnings / Processing  
  - Blue: Info  
  - Cyan / Magenta: Menu & highlights  

- Animated spinner during long-running tasks like backups and updates.

---

## ⚙️ Configuration

Before running, you may customize paths:

```bash
# Directory to backup
BACKUP_SRC="/home/$USER/Documents"

# Backup storage location
BACKUP_DEST="/home/$USER/backup"

# Logs
BACKUP_LOG="$BACKUP_DEST/backup_log.txt"
UPDATE_LOG="/home/$USER/system_update_log.txt"

# System log for monitoring
MONITOR_LOG="/var/log/syslog"  # Use /var/log/messages if your distro differs

```


## 📝 Usage

Clone or Download the script:
```bash
git clone <your-repo-link>
cd system-maintenance-suite
```
Make the script executable:
```bash
chmod +x maintenance_suite.sh
```
Run the script:
```bash
./maintenance_suite.sh
```
Follow the menu to choose tasks:
```bash
==============================
  System Maintenance Suite
==============================
1. System Update & Cleanup
2. Start Log Monitoring (Background)
3. Stop Log Monitoring
4. Backup
5. Exit
==============================
Enter your choice [1-5]:
```

## 🔧 Commands Used in Script

- Backup:
```bash
mkdir -p "$BACKUP_DEST"
tar -czf "$BACKUP_DEST/backup_$TIMESTAMP.tar.gz" "$BACKUP_SRC"
```

- Update & Cleanup:
```bash
sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt autoclean -y
```
- Log Monitoring:
```bash
sudo tail -f "$MONITOR_LOG" | grep --line-buffered -iE "error|fail|critical|warn"
```
- Spinner Animation:
```bash
spinner() { ... }
```

## ⚠️ Requirements
- Linux system (Ubuntu/Debian recommended)
- Bash shell
- Sudo privileges for system update and log monitoring
- Internet connection for updates

## 🚀 Notes
- Make sure the backup destination has enough storage.
- Stop log monitoring using Ctrl + C.
- Customize monitored log file based on your Linux distro.
