# Utility Scripts

This directory contains utility scripts for homelab management and maintenance.

## Available Scripts

### Backup Scripts
- `backup-docker-volumes.sh` - Backup all Docker volumes
- `backup-configs.sh` - Backup configuration files
- `verify-backups.sh` - Verify backup integrity

### Maintenance Scripts
- `update-containers.sh` - Update all Docker containers
- `cleanup-docker.sh` - Clean up unused Docker resources
- `check-disk-space.sh` - Monitor disk space usage

### Monitoring Scripts
- `health-check.sh` - Check service health
- `generate-report.sh` - Generate system report

## Usage

### Make Scripts Executable

```bash
chmod +x scripts/*.sh
```

### Run a Script

```bash
./scripts/backup-docker-volumes.sh
```

### Schedule with Cron

```bash
# Edit crontab
crontab -e

# Add script
0 2 * * * /opt/homelab/scripts/backup-docker-volumes.sh
```

## Best Practices

- Test scripts in non-production first
- Log script output
- Send alerts on failures
- Keep scripts simple and focused
- Document script parameters
- Use version control
