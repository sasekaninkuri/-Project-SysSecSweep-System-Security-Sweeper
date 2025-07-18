#!/bin/bash

# SysAudit - Basic Linux Security Audit Script
# Author: Sasekani Maluleke
# Date: 2025-07-17

REPORT="audit-report.txt"
DATE=$(date)
HOSTNAME=$(hostname)
ISSUES=0

echo "==== SysAudit Linux Security Check ====" > $REPORT
echo "Date: $DATE" >> $REPORT
echo "Hostname: $HOSTNAME" >> $REPORT
echo "" >> $REPORT

echo "[+] Checking for world-writable files..." | tee -a $REPORT
WWFILES=$(find / -xdev -type f -perm -0002 2>/dev/null)
if [ -n "$WWFILES" ]; then
    echo "$WWFILES" | tee -a $REPORT
    ((ISSUES++))
else
    echo "[OK] No world-writable files found." | tee -a $REPORT
fi
echo "" >> $REPORT

echo "[+] Checking open ports..." | tee -a $REPORT
ss -tuln | grep -v "State" | tee -a $REPORT
echo "" >> $REPORT

echo "[+] Checking for users with UID 0 (should only be root)..." | tee -a $REPORT
UID0=$(awk -F: '$3 == 0 {print $1}' /etc/passwd)
if [ "$UID0" != "root" ]; then
    echo "[!] Warning: Users with UID 0: $UID0" | tee -a $REPORT
    ((ISSUES++))
else
    echo "[OK] Only root has UID 0." | tee -a $REPORT
fi
echo "" >> $REPORT

echo "[+] Checking password expiration settings..." | tee -a $REPORT
chage -l root | tee -a $REPORT
echo "" >> $REPORT

echo "[+] Checking sudo users..." | tee -a $REPORT
SUDOERS=$(getent group sudo | cut -d: -f4)
if [ -n "$SUDOERS" ]; then
    echo "Users with sudo: $SUDOERS" | tee -a $REPORT
else
    echo "[OK] No sudo users found." | tee -a $REPORT
fi
echo "" >> $REPORT

echo "[+] Checking sudoers file permissions..." | tee -a $REPORT
PERMS=$(stat -c "%a" /etc/sudoers)
if [ "$PERMS" != "440" ]; then
    echo "[!] Warning: /etc/sudoers has incorrect permissions: $PERMS" | tee -a $REPORT
    ((ISSUES++))
else
    echo "[OK] /etc/sudoers permissions are secure (440)." | tee -a $REPORT
fi
echo "" >> $REPORT

echo "[+] Checking failed SSH login attempts..." | tee -a $REPORT
FAILED=$(grep "Failed password" /var/log/auth.log 2>/dev/null | wc -l)
echo "Failed SSH logins: $FAILED" | tee -a $REPORT
echo "" >> $REPORT

echo "[+] System info:" | tee -a $REPORT
uname -a | tee -a $REPORT
uptime | tee -a $REPORT
echo "" >> $REPORT

# Risk Summary
echo "==== Summary ====" >> $REPORT
echo "Total Issues Found: $ISSUES" | tee -a $REPORT
if [ "$ISSUES" -eq 0 ]; then
    echo "Risk Level: Low" | tee -a $REPORT
elif [ "$ISSUES" -le 2 ]; then
    echo "Risk Level: Moderate" | tee -a $REPORT
else
    echo "Risk Level: High" | tee -a $REPORT
fi

echo ""
echo "[+] Audit complete. Report saved to $REPORT"
