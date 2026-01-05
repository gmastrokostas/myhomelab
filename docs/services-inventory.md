# Services Inventory

This document maintains a list of all services running in the homelab.

## Core Services

### Infrastructure

| Service | Category | URL | Purpose | Status |
|---------|----------|-----|---------|--------|
| Portainer | Management | https://portainer.homelab.local | Docker container management | ⚪ Planned |
| Proxmox | Virtualization | https://proxmox.homelab.local:8006 | VM/Container host | ⚪ Planned |

### Networking

| Service | Category | URL | Purpose | Status |
|---------|----------|-----|---------|--------|
| Pi-hole | DNS | https://pihole.homelab.local | DNS-based ad blocking | ⚪ Planned |
| Nginx Proxy Manager | Proxy | https://npm.homelab.local | Reverse proxy | ⚪ Planned |
| WireGuard | VPN | N/A | VPN access | ⚪ Planned |

### Monitoring

| Service | Category | URL | Purpose | Status |
|---------|----------|-----|---------|--------|
| Grafana | Monitoring | https://grafana.homelab.local | Metrics visualization | ⚪ Planned |
| Prometheus | Monitoring | https://prometheus.homelab.local | Metrics collection | ⚪ Planned |
| Loki | Logging | https://loki.homelab.local | Log aggregation | ⚪ Planned |
| Uptime Kuma | Monitoring | https://uptime.homelab.local | Uptime monitoring | ⚪ Planned |

### Storage

| Service | Category | URL | Purpose | Status |
|---------|----------|-----|---------|--------|
| Nextcloud | File Sync | https://nextcloud.homelab.local | File sync and share | ⚪ Planned |
| PhotoPrism | Photos | https://photos.homelab.local | Photo management | ⚪ Planned |

### Media

| Service | Category | URL | Purpose | Status |
|---------|----------|-----|---------|--------|
| Plex | Media Server | https://plex.homelab.local | Media streaming | ⚪ Planned |
| Jellyfin | Media Server | https://jellyfin.homelab.local | Open-source media streaming | ⚪ Planned |

### Automation

| Service | Category | URL | Purpose | Status |
|---------|----------|-----|---------|--------|
| Home Assistant | Smart Home | https://ha.homelab.local | Home automation | ⚪ Planned |
| Node-RED | Automation | https://nodered.homelab.local | Workflow automation | ⚪ Planned |

### Security

| Service | Category | URL | Purpose | Status |
|---------|----------|-----|---------|--------|
| Vaultwarden | Password Manager | https://vault.homelab.local | Password management | ⚪ Planned |
| Authelia | Auth | https://auth.homelab.local | SSO authentication | ⚪ Planned |

### Development

| Service | Category | URL | Purpose | Status |
|---------|----------|-----|---------|--------|
| GitLab | Git | https://gitlab.homelab.local | Git repository hosting | ⚪ Planned |
| Gitea | Git | https://git.homelab.local | Lightweight Git server | ⚪ Planned |

## Service Status Legend

- 🟢 **Running**: Service is operational
- 🟡 **Degraded**: Service is running but with issues
- 🔴 **Down**: Service is not operational
- ⚪ **Planned**: Service is planned but not deployed
- 🔵 **Testing**: Service is in testing phase

## Resource Allocation

### CPU Allocation

| Service | CPU Cores | Notes |
|---------|-----------|-------|
| Proxmox | 8 | Hypervisor host |
| Docker Host 1 | 4 | Primary Docker host |
| Docker Host 2 | 4 | Secondary Docker host |

### Memory Allocation

| Service | RAM | Notes |
|---------|-----|-------|
| Proxmox | 32GB | Hypervisor host |
| Docker Host 1 | 16GB | Primary Docker host |
| Docker Host 2 | 16GB | Secondary Docker host |

### Storage Allocation

| Service | Storage | Type | Notes |
|---------|---------|------|-------|
| NAS | 4TB | HDD RAID | Media and backups |
| Docker Volumes | 500GB | SSD | Container persistent data |
| VM Storage | 1TB | SSD | Virtual machine disks |

## Backup Schedule

| Service | Frequency | Method | Retention |
|---------|-----------|--------|-----------|
| Docker Volumes | Daily | rsync | 7 days |
| VM Snapshots | Weekly | Proxmox | 4 weeks |
| Configuration | Daily | Git | Indefinite |
| Media | Weekly | rsync | 2 copies |

## Maintenance Schedule

| Task | Frequency | Day/Time |
|------|-----------|----------|
| System Updates | Weekly | Sunday 2 AM |
| Container Updates | Weekly | Sunday 3 AM |
| Backup Verification | Monthly | 1st Sunday |
| Security Audit | Quarterly | End of quarter |

## Access Methods

### Internal Access
- Direct IP/hostname access from internal network
- mDNS for discovery (.local domains)

### External Access
- VPN (WireGuard) for secure access
- Cloudflare Tunnel (optional) for select services
- Reverse proxy with SSL/TLS

## Dependencies

Key service dependencies:
- Most services depend on Docker host
- Docker services depend on Proxmox
- All services depend on network infrastructure
- Monitoring services should be highly available

## Notes

- Keep this inventory updated when adding/removing services
- Document any special configurations
- Note any inter-service dependencies
- Track resource usage to prevent overallocation
