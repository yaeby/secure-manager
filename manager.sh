#!/bin/bash

: '
Secure Manager Script
by c8a
' 

# Directory to organize
TARGET_DIR="$1"

# Function to organize files by file type
organize_files() {
  echo -e "\n\t Organizing files in $TARGET_DIR"
  
    mkdir -p "$TARGET_DIR/images" \
           "$TARGET_DIR/documents" \
           "$TARGET_DIR/videos" \
           "$TARGET_DIR/others" \
           "$TARGET_DIR/spreadsheets" \
           "$TARGET_DIR/presentations" \
           "$TARGET_DIR/c" \
           "$TARGET_DIR/cpp" \
           "$TARGET_DIR/java" \
           "$TARGET_DIR/csharp" \
           "$TARGET_DIR/python" \
           "$TARGET_DIR/web/html" \
           "$TARGET_DIR/web/css" \
           "$TARGET_DIR/web/js"

  find "$TARGET_DIR" -maxdepth 1 -type f -iname "*.jpg" -exec mv {} "$TARGET_DIR/images/" \;
  find "$TARGET_DIR" -maxdepth 1 -type f -iname "*.png" -exec mv {} "$TARGET_DIR/images/" \;
  find "$TARGET_DIR" -maxdepth 1 -type f -iname "*.gif" -exec mv {} "$TARGET_DIR/images/" \;
  find "$TARGET_DIR" -maxdepth 1 -type f -iname "*.pdf" -exec mv {} "$TARGET_DIR/documents/" \;
  find "$TARGET_DIR" -maxdepth 1 -type f -iname "*.txt" -exec mv {} "$TARGET_DIR/documents/" \;
  find "$TARGET_DIR" -maxdepth 1 -type f -iname "*.docx" -exec mv {} "$TARGET_DIR/documents/" \;
  find "$TARGET_DIR" -maxdepth 1 -type f -iname "*.xls" -exec mv {} "$TARGET_DIR/spreadsheets/" \;
  find "$TARGET_DIR" -maxdepth 1 -type f -iname "*.xlsx" -exec mv {} "$TARGET_DIR/spreadsheets/" \;
  find "$TARGET_DIR" -maxdepth 1 -type f -iname "*.ppt" -exec mv {} "$TARGET_DIR/presentations/" \;
  find "$TARGET_DIR" -maxdepth 1 -type f -iname "*.pptx" -exec mv {} "$TARGET_DIR/presentations/" \;
  find "$TARGET_DIR" -maxdepth 1 -type f -iname "*.java" -exec mv {} "$TARGET_DIR/java/" \;
  find "$TARGET_DIR" -maxdepth 1 -type f -iname "*.cpp" -exec mv {} "$TARGET_DIR/cpp/" \;
  find "$TARGET_DIR" -maxdepth 1 -type f -iname "*.c" -exec mv {} "$TARGET_DIR/c/" \;
  find "$TARGET_DIR" -maxdepth 1 -type f -iname "*.cs" -exec mv {} "$TARGET_DIR/csharp/" \;
  find "$TARGET_DIR" -maxdepth 1 -type f -iname "*.html" -exec mv {} "$TARGET_DIR/web/html/" \;
  find "$TARGET_DIR" -maxdepth 1 -type f -iname "*.css" -exec mv {} "$TARGET_DIR/web/css/" \;
  find "$TARGET_DIR" -maxdepth 1 -type f -iname "*.js" -exec mv {} "$TARGET_DIR/web/js/" \;

  find "$TARGET_DIR" -maxdepth 1 -type f -exec mv {} "$TARGET_DIR/others/" \;
  
  echo -e "\nFiles organized!"
}

# Function to securely manage file permissions
manage_permissions() {
  echo -e "\nSecuring file permissions..."
  
  # Set restrictive permissions for sensitive files
  chmod -R go-rwx "$TARGET_DIR"  # Remove read/write/execute permissions for others
  
  # Set more open permissions for public files
  chmod 755 "$TARGET_DIR/images"
  chmod 755 "$TARGET_DIR/documents"
  chmod 755 "$TARGET_DIR/videos"
  
  echo -e "\nFile permissions secured!"
}

# Function to detect and prevent brute-force login attempts
prevent_bruteforce() {
  echo -e "\nChecking for potential brute-force login attempts..."

  # Configure the fail2ban service if it's installed
  if systemctl list-units --type=service | grep -q "fail2ban"; then
    echo -e "\nfail2ban is installed, configuring..."
    sudo systemctl restart fail2ban
  else
    echo -e "\nfail2ban not found, installing..."
    sudo apt-get install fail2ban -y
    sudo systemctl start fail2ban
    sudo systemctl enable fail2ban
  fi

  echo -e "\nBrute-force login protection is now active!"
}


# Main
if [ -z "$TARGET_DIR" ]; then
  echo -e "\nUsage: $0 <directory>"
  exit 1
fi

# Check if the target directory exists
if [ ! -d "$TARGET_DIR" ]; then
  echo -e "\Invalid directory: $TARGET_DIR . Check the path and try again."
  exit 1
fi

# Call the functions
organize_files
manage_permissions
prevent_bruteforce

echo -e "\nManage completed!"