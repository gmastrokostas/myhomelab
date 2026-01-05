#!/bin/bash
# Backup Docker volumes
# Usage: ./backup-docker-volumes.sh

set -e

# Configuration
BACKUP_DIR="${BACKUP_DIR:-/mnt/nas/backups/docker-volumes}"
DATE=$(date +%Y%m%d-%H%M%S)
LOG_FILE="${LOG_FILE:-/var/log/docker-backup.log}"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

echo "[$(date)] Starting Docker volume backup" | tee -a "$LOG_FILE"

# Get list of all volumes
volumes=$(docker volume ls -q)

if [ -z "$volumes" ]; then
    echo "[$(date)] No volumes found to backup" | tee -a "$LOG_FILE"
    exit 0
fi

# Backup each volume
for volume in $volumes; do
    echo "[$(date)] Backing up volume: $volume" | tee -a "$LOG_FILE"
    
    backup_file="$BACKUP_DIR/${volume}-${DATE}.tar.gz"
    
    # Create backup
    docker run --rm \
        -v "$volume":/data \
        -v "$BACKUP_DIR":/backup \
        alpine tar czf "/backup/$(basename "$backup_file")" -C /data .
    
    if [ $? -eq 0 ]; then
        echo "[$(date)] Successfully backed up $volume" | tee -a "$LOG_FILE"
    else
        echo "[$(date)] ERROR: Failed to backup $volume" | tee -a "$LOG_FILE"
    fi
done

# Cleanup old backups (keep last 7 days)
echo "[$(date)] Cleaning up old backups" | tee -a "$LOG_FILE"
find "$BACKUP_DIR" -name "*.tar.gz" -mtime +7 -delete

echo "[$(date)] Docker volume backup completed" | tee -a "$LOG_FILE"
