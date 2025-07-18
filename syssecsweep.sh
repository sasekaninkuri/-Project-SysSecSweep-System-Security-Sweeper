#!/bin/bash

# SysSecSweep - Quick Linux System Security Audit Script
# Author: Sasekani Maluleke

LOG_DIR="./logs"
LOG_FILE="$LOG_DIR/sweep-log.txt"
mkdir -p "$LOG_DIR"

echo "[*] Running SysSecSweep - System Security Sweeper" | tee "$LOG_FILE"
echo "--------------------------------------------------" | tee -a "$LOG_FILE"
echo "[*] Date: $(date)" | tee -a "$LOG_FILE"

# Check for root
if [[ $EUID -ne 0 ]]; then
  echo "[!] Please run as root." | tee -a "$LOG_FILE"
  exit 1
fi

# 1. List logged-in users
echo "[*] Logged in users:" | tee -a "$LOG_FILE"
who | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# 2. Check failed login attempts
echo "[*] Failed login attempts:" | tee -a "$LOG_FILE"
lastb -a | head -10 | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# 3. Show SUID/SGID files (privilege escalation risks)
echo "[*] SUID and SGID files:" | tee -a "$LOG_FILE"
find / -type f \( -perm -4000 -o -perm -2000 \) -exec ls -lh {} \; 2>/dev/null | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# 4. Running services
echo "[*] Running services:" | tee -a "$LOG_FILE"
systemctl list-units --type=service --state=running | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# 5. Open network ports
echo "[*] Open ports:" | tee -a "$LOG_FILE"
ss -tulnp | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# 6. Recent sudo usage
echo "[*] Recent sudo commands:" | tee -a "$LOG_FILE"
grep 'sudo' /var/log/auth.log | tail -10 | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# 7. Installed packages
echo "[*] Top installed packages:" | tee -a "$LOG_FILE"
dpkg -l | head -10 | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# 🔐 Additional Security Checks

# Unauthorized SUID Files
echo "[*] Checking for unauthorized SUID files:" | tee -a "$LOG_FILE"
find / -perm -4000 -type f 2>/dev/null | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# World-Writable Files
echo "[*] Checking for world-writable files:" | tee -a "$LOG_FILE"
find / -type f -perm -0002 2>/dev/null | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# Detect Users with Empty Passwords
echo "[*] Checking for users with empty passwords:" | tee -a "$LOG_FILE"
awk -F: '($2=="\")"{print $1}' /etc/shadow 2>/dev/null | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# 📦 Package & Updates

# Recently Installed Packages
echo "[*] Recently installed packages:" | tee -a "$LOG_FILE"
grep "install " /var/log/dpkg.log 2>/dev/null | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# Check for Upgradable Packages
echo "[*] Packages available for upgrade:" | tee -a "$LOG_FILE"
apt list --upgradable 2>/dev/null | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# 🕵️ Forensics Artifacts

# Recent Bash History for All Users
echo "[*] Recent bash history for all users:" | tee -a "$LOG_FILE"
for home in /home/*; do
  cat $home/.bash_history 2>/dev/null | tee -a "$LOG_FILE"
done
echo "" | tee -a "$LOG_FILE"

# Cron Jobs
echo "[*] Cron jobs for all users:" | tee -a "$LOG_FILE"
for user in $(cut -f1 -d: /etc/passwd); do
  crontab -l -u $user 2>/dev/null | tee -a "$LOG_FILE"
done
echo "" | tee -a "$LOG_FILE"

# 📁 Hidden Files & Suspicious Binaries

# Hidden Files in Home
 echo "[*] Hidden files in /home:" | tee -a "$LOG_FILE"
 find /home -type f -name ".*" 2>/dev/null | tee -a "$LOG_FILE"
 echo "" | tee -a "$LOG_FILE"

# Unusual Files in /tmp
echo "[*] Unusual files in /tmp:" | tee -a "$LOG_FILE"
ls -la /tmp | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# 🧠 System Monitoring

# CPU and Memory Usage
echo "[*] CPU and memory usage snapshot:" | tee -a "$LOG_FILE"
top -b -n 1 | head -20 | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# Disk Usage
echo "[*] Disk usage overview:" | tee -a "$LOG_FILE"
df -h | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# ✅ Complete
echo "[✓] Sweep complete. Logs saved to $LOG_FILE"

