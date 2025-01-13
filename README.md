# Secure Manager Script
### by Adrian Copta

---

## Overview
The Secure Manager Script is a bash script designed to automate the process of organizing a directory, securing file permissions, and monitoring for brute-force login attempts. The script is meant to improve the management and security of your system by sorting files based on extensions, applying secure permissions, and blocking potentially harmful login attempts.

---

### Features:
1. **Organize Files:** Automatically categorizes files in a given directory into subdirectories based on their file extensions (e.g., images, documents, code files, videos, etc.).
2. **Secure Permissions:** Changes the file permissions of all files and directories in the specified directory to ensure security. Files are given 600 permissions, and directories are given 700 permissions.
3. **Prevent Brute-Force Attacks:** Detects failed login attempts from multiple IP addresses by analyzing the system’s auth.log file. It blocks IP addresses that exceed a defined number of failed login attempts (default is 5).

---

## Prerequisites:
- Linux-based operating system (e.g., Ubuntu)
- **iptables** (for blocking IP addresses)
- Access to `/var/log/auth.log` (or equivalent authentication log file)
- **bash** shell

---

### How to Use
1. Run './test_generator.sh <test_folder_path>' to generate some test data
2. Run './final_task.sh <test_folder_path> to organize the files, secure file permossions and monitor logs'