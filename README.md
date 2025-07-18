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
