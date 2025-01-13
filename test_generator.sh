#!/bin/bash

# Script to generate test data and system logs for the OS final exam script

# Ensure a directory is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <test_directory>"
  exit 1
fi

TEST_DIR="$1"
AUTH_LOG="/var/log/auth.log"

# Create test directory if it doesn't exist
mkdir -p "$TEST_DIR"

# Step 1: Create files with various extensions for testing
extensions=("txt" "log" "csv" "json")
for ext in "${extensions[@]}"; do
  for i in {1..5}; do
    touch "$TEST_DIR/file_$i.$ext"
  done
  echo "Created 5 .$ext files in $TEST_DIR"
done

# Step 2: Create hidden files for testing
for i in {1..3}; do
  touch "$TEST_DIR/.hidden_$i"
  echo "Created hidden file: .hidden_$i"
done

# Step 3: Generate dummy system logs with failed login attempts
if [ ! -f "$AUTH_LOG" ]; then
  echo "Creating dummy auth log at $AUTH_LOG"
  touch "$AUTH_LOG"
fi

failed_ips=("192.168.1.100" "192.168.1.101" "192.168.1.102")
for ip in "${failed_ips[@]}"; do
  for attempt in {1..7}; do
    echo "$(date) sshd[12345]: Failed password for invalid user testuser from $ip port 22 ssh2" >> "$AUTH_LOG"
  done
  echo "Logged 7 failed attempts for $ip in $AUTH_LOG"
done

# Step 4: Set random permissions for testing
chmod 777 "$TEST_DIR"
for file in "$TEST_DIR"/*; do
  if [ -f "$file" ]; then
    chmod 666 "$file"
  elif [ -d "$file" ]; then
    chmod 777 "$file"
  fi
  echo "Set random permissions for $file"
done

echo "Test data and logs generated successfully."
