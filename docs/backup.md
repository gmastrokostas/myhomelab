# Backup Strategy

This document outlines the backup strategy for the homelab environment.

## Backup Philosophy

Follow the **3-2-1 Rule**:
- **3** copies of data
- **2** different media types
- **1** copy offsite

## Backup Categories

### Critical Data
- Configuration files
- Docker volumes
- Databases
- SSL certificates
- Personal documents
Priority: **Highest** | RPO: 1 hour | RTO: 1 hour

### Important Data
- Media libraries
- Photos and videos
- Application data
Priority: **High** | RPO: 24 hours | RTO: 4 hours

### Replaceable Data
- Container images
- System packages
- Downloaded content
Priority: **Low** | RPO: 7 days | RTO: 24 hours

## Backup Schedule

### Automated Backups

| Data Type | Frequency | Time | Method | Retention |
|-----------|-----------|------|--------|-----------|
| Docker Volumes | Daily | 2:00 AM | rsync | 7 days |
| Configurations | Daily | 2:30 AM | Git commit | Indefinite |
| Databases | Daily | 1:00 AM | mysqldump/pg_dump | 7 days |
| VM Snapshots | Weekly | Sunday 1:00 AM | Proxmox | 4 weeks |
| Full System | Monthly | 1st Sunday 3:00 AM | Clonezilla | 3 months |

### Manual Backups

- Before major changes
- Before system updates
- Before configuration changes
- Before data migration

## Backup Methods

### 1. Docker Volume Backups

```bash
# Backup a docker volume
docker run --rm \
  -v volume_name:/data \
  -v /backup:/backup \
  alpine tar czf /backup/volume_name-$(date +%Y%m%d).tar.gz /data

# Restore a docker volume
docker run --rm \
  -v volume_name:/data \
  -v /backup:/backup \
  alpine sh -c "cd /data && tar xzf /backup/volume_name-20240101.tar.gz --strip 1"
```

### 2. Configuration Backups

```bash
# Backup configurations to git
cd /path/to/homelab
git add .
git commit -m "Backup: $(date +%Y-%m-%d)"
git push
```

### 3. Database Backups

```bash
# MySQL backup
docker exec mysql mysqldump -u root -p${MYSQL_ROOT_PASSWORD} --all-databases > backup.sql

# PostgreSQL backup
docker exec postgres pg_dumpall -U postgres > backup.sql

# MongoDB backup
docker exec mongo mongodump --out /backup
```

### 4. VM Snapshots

```bash
# Create Proxmox VM snapshot
qm snapshot <vmid> <snapshot-name>

# List snapshots
qm listsnapshot <vmid>

# Restore snapshot
qm rollback <vmid> <snapshot-name>
```

## Backup Locations

### Primary (Local)
- **Location**: NAS at 192.168.30.10
- **Capacity**: 4TB
- **Type**: RAID 5
- **Purpose**: Fast recovery, recent backups

### Secondary (Local)
- **Location**: External USB drive
- **Capacity**: 2TB
- **Type**: Single drive
- **Purpose**: Offline backup, disaster recovery

### Tertiary (Offsite)
- **Location**: Cloud storage (Backblaze B2, AWS S3, etc.)
- **Capacity**: As needed
- **Type**: Object storage
- **Purpose**: Offsite backup, catastrophic failure recovery

## Backup Scripts

### Automated Backup Script

```bash
#!/bin/bash
# /opt/homelab/scripts/backup.sh

BACKUP_DIR="/mnt/nas/backups"
DATE=$(date +%Y%m%d)
LOG_FILE="/var/log/homelab-backup.log"

echo "Starting backup at $(date)" >> $LOG_FILE

# Backup Docker volumes
echo "Backing up Docker volumes..." >> $LOG_FILE
for volume in $(docker volume ls -q); do
    docker run --rm \
        -v $volume:/data \
        -v $BACKUP_DIR:/backup \
        alpine tar czf /backup/${volume}-${DATE}.tar.gz /data
done

# Backup configurations
echo "Backing up configurations..." >> $LOG_FILE
tar czf $BACKUP_DIR/configs-${DATE}.tar.gz /opt/homelab

# Cleanup old backups (keep last 7 days)
echo "Cleaning up old backups..." >> $LOG_FILE
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete

echo "Backup completed at $(date)" >> $LOG_FILE
```

### Cron Schedule

```cron
# Daily backups at 2 AM
0 2 * * * /opt/homelab/scripts/backup.sh

# Weekly verification
0 3 * * 0 /opt/homelab/scripts/verify-backup.sh
```

## Backup Verification

### Regular Tests
- Monthly restore tests
- Verify backup integrity
- Check backup completeness
- Document restore procedures

### Verification Script

```bash
#!/bin/bash
# /opt/homelab/scripts/verify-backup.sh

BACKUP_DIR="/mnt/nas/backups"
DATE=$(date +%Y%m%d)

# Check if backups exist
if [ ! "$(ls -A $BACKUP_DIR)" ]; then
    echo "ERROR: No backups found!" | mail -s "Backup Verification Failed" admin@homelab.local
    exit 1
fi

# Check backup age
LATEST_BACKUP=$(ls -t $BACKUP_DIR/*.tar.gz | head -1)
BACKUP_AGE=$(($(date +%s) - $(stat -c %Y $LATEST_BACKUP)))

if [ $BACKUP_AGE -gt 172800 ]; then  # 48 hours
    echo "ERROR: Latest backup is too old!" | mail -s "Backup Verification Failed" admin@homelab.local
    exit 1
fi

echo "Backup verification passed"
```

## Restore Procedures

### Docker Volume Restore

1. Stop the container
2. Remove the volume (if needed)
3. Create new volume
4. Extract backup to volume
5. Start the container

### Configuration Restore

1. Clone repository
2. Review changes
3. Apply configurations
4. Restart services

### VM Restore

1. Upload VM backup to Proxmox
2. Restore from backup/snapshot
3. Configure network
4. Start VM

## Monitoring Backups

### Alerts

Set up alerts for:
- Backup job failures
- Missing backups
- Disk space issues
- Backup verification failures

### Dashboard

Monitor in Grafana:
- Backup success rate
- Backup size trends
- Backup duration
- Available backup space

## Security

### Backup Security
- Encrypt sensitive backups
- Secure backup storage access
- Rotate backup encryption keys
- Audit backup access logs

### Encryption

```bash
# Encrypt backup
gpg --encrypt --recipient admin@homelab.local backup.tar.gz

# Decrypt backup
gpg --decrypt backup.tar.gz.gpg > backup.tar.gz
```

## Documentation

Maintain documentation for:
- Backup procedures
- Restore procedures
- Backup schedules
- Storage locations
- Encryption keys (secured separately)
- Recovery time objectives

## Testing

### Monthly Tests
- [ ] Verify recent backups exist
- [ ] Test restoring a Docker volume
- [ ] Test restoring a configuration file
- [ ] Verify offsite backup sync

### Quarterly Tests
- [ ] Full restore of a VM
- [ ] Full restore of a service
- [ ] Disaster recovery simulation
- [ ] Update disaster recovery documentation

## Best Practices

1. **Automate everything** - Manual backups are forgotten
2. **Test restores regularly** - Backups are worthless if you can't restore
3. **Monitor backup health** - Know when backups fail
4. **Document procedures** - Future you will thank present you
5. **Keep offsite backups** - Protect against site disasters
6. **Encrypt sensitive data** - Protect backup confidentiality
7. **Version your backups** - Keep multiple versions
8. **Clean old backups** - Manage storage space
9. **Verify integrity** - Ensure backups aren't corrupted
10. **Update regularly** - Keep backup scripts and tools current
