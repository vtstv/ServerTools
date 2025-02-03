#!/bin/bash

BACKUP_DIR="/home/backupuser"
USERS=("admin" "vts" "testuser")  
DAYS=7                            # Number of days/copies for each user

# Create the directory if it doesn't exist
mkdir -p "$BACKUP_DIR"
cd "$BACKUP_DIR" || exit 1

# Generate test files
for user in "${USERS[@]}"; do
  for ((i=1; i<=DAYS; i++)); do
    # Format the date (2025-02-01, 2025-02-02...)
    timestamp=$(printf "2025-02-%02d_12-00-00" "$i")
    filename="${user}.${timestamp}.tar"
    touch "$filename"
    echo "Created: $filename"
  done
done

echo "Done! Created $(( DAYS * ${#USERS[@]} )) test files in $BACKUP_DIR"
