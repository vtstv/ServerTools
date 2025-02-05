#!/bin/bash

BACKUP_DIR="/home/backupuser/"
KEEP=7  # Number of backup copies to keep

# Change to main backup directory
cd "$BACKUP_DIR" || exit 1

# Create backups directory if not exists
mkdir -p backups

# Move any tar files from main directory to backups directory
mv *.tar backups/ 2>/dev/null || true

# Change to backups directory for processing
cd backups || exit 1

# Get a list of unique users based on backup filenames
usernames=$(find . -maxdepth 1 -type f -name '*.tar' -printf '%f\n' | cut -d. -f1 | sort -u)

if [ -z "$usernames" ]; then
    echo "No backup copies found in backups directory."
    exit 0
fi

# Process each user's backups to delete old copies
for username in $usernames; do
    echo "Processing backups for: $username"
    
    # Collect and sort backup files (newest first)
    backups=$(find . -maxdepth 1 -type f -name "${username}.*.tar" -printf '%f\n' | sort -r)
    
    if [ -z "$backups" ]; then
        continue
    fi
    
    # Calculate the number of backups to delete
    total=$(echo "$backups" | wc -l)
    
    if [ $total -le $KEEP ]; then
        echo "No extra copies in backups directory. Total: $total, keeping: $KEEP."
        continue
    fi
    
    # Delete the oldest backups exceeding the KEEP limit
    num_to_delete=$((total - KEEP))
    echo "Deleting $num_to_delete old copies out of $total from backups directory."
    echo "$backups" | tail -n +$(($KEEP + 1)) | xargs -I {} rm -v "./{}"
done

echo "Cleanup in backups directory completed."
