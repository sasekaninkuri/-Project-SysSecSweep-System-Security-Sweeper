# -Project-SysSecSweep-System-Security-Sweeper

# 🛡️ SysSecSweep – System Security Sweeper

**SysSecSweep** is a lightweight Bash-based tool designed to perform a quick security audit on Linux systems. It helps system administrators and cybersecurity students gain visibility into potential misconfigurations, privilege escalation risks, and user activity.

## 🚀 Features

- 🧑‍💻 Lists logged-in users
- ❌ Detects recent failed login attempts
- 🔐 Finds SUID and SGID binaries (potential privilege escalation)
- 🔧 Displays running services
- 🌐 Lists open ports
- 🕵️ Shows recent sudo usage
- 📦 Lists installed packages
- 📁 Saves output in a `logs/sweep-log.txt` file

## 💡 Usage

```bash
chmod +x syssecsweep.sh
sudo ./syssecsweep.sh



SysSecSweep - Linux System Security Audit Script
SysSecSweep is a lightweight Bash script designed to quickly audit Linux systems for common security risks and system health indicators. It helps sysadmins and security analysts identify potential issues like unauthorized access attempts, privilege escalation risks, suspicious files, and system resource usage — all automated with a single script.

Features
Lists logged-in users and recent failed login attempts

Finds SUID and SGID files (possible privilege escalation vectors)

Shows running services and open network ports

Displays recent sudo command usage

Detects users with empty passwords and world-writable files

Lists hidden files in user home directories and suspicious cron jobs

Reports installed and upgradable packages

Provides CPU, memory, and disk usage snapshots

Logs all output to a timestamped file for easy review

