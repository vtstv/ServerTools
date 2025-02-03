#!/bin/bash

BACKUP_DIR="/home/backupuser/"
KEEP=7  # Number of backup copies to keep

cd "$BACKUP_DIR" || exit 1

# Get a list of unique users
usernames=$(find . -maxdepth 1 -type f -name '*.tar' -printf '%f\n' | cut -d. -f1 | sort -u)

if [ -z "$usernames" ]; then
    echo "No backup copies found."
    exit 0
fi

# Process each user
for username in $usernames; do
    echo "Processing backups for: $username"
    # Collect and sort files (newest first)
    backups=$(find . -maxdepth 1 -type f -name "${username}.*.tar" -printf '%f\n' | sort -r)
    if [ -z "$backups" ]; then
        continue
    fi

    # Determine the number of copies to delete
    total=$(echo "$backups" | wc -l)
    if [ $total -le $KEEP ]; then
        echo "No extra copies. Total: $total, keeping: $KEEP."
        continue
    fi

    # Delete old copies
    num_to_delete=$((total - KEEP))
    echo "Deleting $num_to_delete old copies out of $total."
    echo "$backups" | tail -n +$(($KEEP + 1)) | xargs -I {} rm -v "./{}"
done

echo "Cleanup completed."
