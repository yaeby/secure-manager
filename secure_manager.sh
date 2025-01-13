#!/bin/bash

: '
Secure Manager Script
by c8a
'

# Directory to organize
TARGET_DIR="$1"
LOG_FILE="permissions_log.txt"
BLOCKED_IPS_LOG="blocked_ips.log"

# Function to organize files by file type
organize_files() {
  echo -e "\nOrganizing files in $TARGET_DIR..."

  declare -A extensions_map=(
    ["images"]="jpg jpeg png gif bmp"
    ["documents"]="pdf txt docx doc"
    ["spreadsheets"]="xls xlsx csv"
    ["presentations"]="ppt pptx"
    ["code/c"]="c"
    ["code/cpp"]="cpp"
    ["code/java"]="java"
    ["code/python"]="py"
    ["code/javascript"]="js"
    ["code/html"]="html"
    ["code/css"]="css"
    ["videos"]="mp4 mkv avi"
    ["others"]=""
  )

  for category in "${!extensions_map[@]}"; do
    mkdir -p "$TARGET_DIR/$category"
    for ext in ${extensions_map[$category]}; do
      find "$TARGET_DIR" -maxdepth 1 -type f -iname "*.$ext" -exec mv {} "$TARGET_DIR/$category/" \;
    done
  done

  find "$TARGET_DIR" -maxdepth 1 -type f ! -iname ".*" -exec mv {} "$TARGET_DIR/others/" \;

  # Summary
  echo -e "\nSummary of files moved:"
  for category in "${!extensions_map[@]}"; do
    count=$(find "$TARGET_DIR/$category" -type f | wc -l)
    echo "$category: $count files"
  done
}

# Function to securely manage file permissions
manage_permissions() {
  echo -e "\nSecuring file permissions..."
  > "$LOG_FILE"

  find "$TARGET_DIR" -type f ! -iname ".*" | while read -r file; do
    current_perm=$(stat -c "%a" "$file")
    chmod 600 "$file"
    echo "File: $file, Old Perm: $current_perm, New Perm: 600" >> "$LOG_FILE"
  done

  find "$TARGET_DIR" -type d | while read -r dir; do
    current_perm=$(stat -c "%a" "$dir")
    chmod 700 "$dir"
    echo "Directory: $dir, Old Perm: $current_perm, New Perm: 700" >> "$LOG_FILE"
  done

  echo -e "\nPermissions logged in $LOG_FILE."
}

# Function to detect and prevent brute-force login attempts
prevent_bruteforce() {
  echo -e "\nMonitoring brute-force login attempts..."
  > "$BLOCKED_IPS_LOG"
  AUTH_LOG="/var/log/auth.log"
  if [[ ! -f "$AUTH_LOG" ]]; then
    echo "Error: $AUTH_LOG not found. Ensure your system logs are correctly configured."
    return 1
  fi

  awk '/Failed password/ {print $(NF-3)}' "$AUTH_LOG" | sort | uniq -c | while read -r count ip; do
    if [[ "$count" -gt 5 ]]; then
      iptables -A INPUT -s "$ip" -j DROP
      echo "$ip blocked due to $count failed attempts" >> "$BLOCKED_IPS_LOG"
    fi
  done

  echo -e "\nBlocked IPs logged in $BLOCKED_IPS_LOG."
}

# Main script execution
if [ -z "$TARGET_DIR" ]; then
  echo -e "\nUsage: $0 <directory>"
  exit 1
fi

if [ ! -d "$TARGET_DIR" ]; then
  echo -e "\nInvalid directory: $TARGET_DIR. Check the path and try again."
  exit 1
fi

organize_files
manage_permissions
prevent_bruteforce

echo -e "\nTask completed!"
