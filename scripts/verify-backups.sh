#!/bin/bash
# Verify backup integrity
# Usage: ./verify-backups.sh

set -e

BACKUP_DIR="${BACKUP_DIR:-/mnt/nas/backups}"
LOG_FILE="${LOG_FILE:-/var/log/backup-verification.log}"

echo "[$(date)] Starting backup verification" | tee -a "$LOG_FILE"

# Check if backup directory exists
if [ ! -d "$BACKUP_DIR" ]; then
    echo "[$(date)] ERROR: Backup directory not found: $BACKUP_DIR" | tee -a "$LOG_FILE"
    exit 1
fi

# Check if backups exist
backup_count=$(find "$BACKUP_DIR" -name "*.tar.gz" | wc -l)

if [ $backup_count -eq 0 ]; then
    echo "[$(date)] ERROR: No backups found in $BACKUP_DIR" | tee -a "$LOG_FILE"
    exit 1
fi

echo "[$(date)] Found $backup_count backup files" | tee -a "$LOG_FILE"

# Check age of latest backup
latest_backup=$(find "$BACKUP_DIR" -name "*.tar.gz" -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -f2- -d" ")
backup_age=$(($(date +%s) - $(stat -c %Y "$latest_backup")))
backup_age_hours=$((backup_age / 3600))

echo "[$(date)] Latest backup is $backup_age_hours hours old" | tee -a "$LOG_FILE"

if [ $backup_age_hours -gt 48 ]; then
    echo "[$(date)] WARNING: Latest backup is too old!" | tee -a "$LOG_FILE"
    exit 1
fi

# Test integrity of latest backup
echo "[$(date)] Testing integrity of latest backup" | tee -a "$LOG_FILE"
if tar tzf "$latest_backup" > /dev/null 2>&1; then
    echo "[$(date)] Backup integrity check passed" | tee -a "$LOG_FILE"
else
    echo "[$(date)] ERROR: Backup integrity check failed" | tee -a "$LOG_FILE"
    exit 1
fi

echo "[$(date)] Backup verification completed successfully" | tee -a "$LOG_FILE"
