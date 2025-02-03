sudo su - backupuser

crontab -e

0 0 * * * /home/backupuser/backup_cleaner.sh
