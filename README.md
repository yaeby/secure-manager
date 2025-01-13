# Secure Manager Script

A comprehensive bash utility for file organization, permission management, and security monitoring.

## Overview

The Secure Manager Script is a robust bash utility designed to enhance system organization and security. It provides automated file management, implements secure permission policies, and includes intrusion detection capabilities to protect against unauthorized access attempts.

## Features

### File Organization
- Automatically categorizes files based on extensions
- Creates structured directory hierarchies
- Supports multiple file types including:
  - Images (jpg, jpeg, png, gif, bmp)
  - Documents (pdf, txt, docx, doc)
  - Spreadsheets (xls, xlsx, csv)
  - Presentations (ppt, pptx)
  - Source Code (c, cpp, java, python, javascript, html, css)
  - Videos (mp4, mkv, avi)
  - Others (uncategorized files)

### Permission Management
- Implements secure file permissions (600) for all files
- Sets restricted directory permissions (700)
- Generates detailed permission change logs
- Maintains audit trail of all permission modifications

### Security Monitoring
- Detects potential brute-force login attempts
- Automatically blocks suspicious IP addresses
- Configurable threshold for failed login attempts
- Maintains logs of blocked IP addresses

## Requirements

- Linux-based operating system
- Root or sudo privileges
- Bash shell (version 4.0 or higher)
- Required packages:
  - `iptables` (for IP blocking)
  - `find` (for file operations)
  - `chmod` (for permission management)
  - `awk` (for log processing)

## Usage

### Basic Usage
```bash
./secure_manager.sh <target_directory>
```

### Example
```bash
./secure_manager.sh /path/to/directory
```

### Testing
To test the script with sample data:
```bash
./test_generator.sh /path/to/test/directory
./secure_manager.sh /path/to/test/directory
```

## Code Breakdown and Explanation

### 1. File Organization Function
```bash
organize_files() {
    # Define file extensions map
    declare -A extensions_map=(
        ["images"]="jpg jpeg png gif bmp"
        ["documents"]="pdf txt docx doc"
        # ... other extensions
    )
    
    # Process each category
    for category in "${!extensions_map[@]}"; do
        mkdir -p "$TARGET_DIR/$category"
        for ext in ${extensions_map[$category]}; do
            find "$TARGET_DIR" -maxdepth 1 -type f -iname "*.$ext" \
                -exec mv {} "$TARGET_DIR/$category/" \;
        done
    done
}
```
This function:
- Creates an associative array mapping categories to file extensions
- Creates directories for each category
- Moves files to appropriate directories based on their extensions
- Uses `find` with `-exec` for efficient file operations

### 2. Permission Management Function
```bash
manage_permissions() {
    > "$LOG_FILE"
    # Secure files
    find "$TARGET_DIR" -type f ! -iname ".*" | while read -r file; do
        current_perm=$(stat -c "%a" "$file")
        chmod 600 "$file"
        echo "File: $file, Old Perm: $current_perm, New Perm: 600" >> "$LOG_FILE"
    done
    
    # Secure directories
    find "$TARGET_DIR" -type d | while read -r dir; do
        current_perm=$(stat -c "%a" "$dir")
        chmod 700 "$dir"
        echo "Directory: $dir, Old Perm: $current_perm, New Perm: 700" \
            >> "$LOG_FILE"
    done
}
```
This function:
- Processes all files and directories separately
- Changes file permissions to 600 (user read/write only)
- Changes directory permissions to 700 (user full access only)
- Logs all permission changes for audit purposes

### 3. Brute-Force Prevention Function
```bash
prevent_bruteforce() {
    > "$BLOCKED_IPS_LOG"
    AUTH_LOG="/var/log/auth.log"
    
    # Process auth log for failed attempts
    awk '/Failed password/ {print $(NF-3)}' "$AUTH_LOG" | \
        sort | uniq -c | while read -r count ip; do
        if [[ "$count" -gt 5 ]]; then
            iptables -A INPUT -s "$ip" -j DROP
            echo "$ip blocked due to $count failed attempts" >> "$BLOCKED_IPS_LOG"
        fi
    done
}
```
This function:
- Monitors the authentication log for failed login attempts
- Uses `awk` to extract IP addresses from failed login entries
- Counts failed attempts per IP address
- Blocks IPs with more than 5 failed attempts using iptables
- Maintains a log of blocked IPs

## Logging

The script generates two main log files:

1. `permissions_log.txt`
   - Records all permission changes
   - Includes original and new permissions
   - Logs affected files and directories

2. `blocked_ips.log`
   - Lists blocked IP addresses
   - Records number of failed attempts
   - Timestamps for blocking events

---
Created by Adrian Copta - System Security Engineer