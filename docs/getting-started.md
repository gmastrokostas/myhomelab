# Getting Started with Your Homelab

This guide will help you get started with setting up your homelab environment.

## Prerequisites

Before you begin, ensure you have:

- [ ] Physical server or VM host with sufficient resources
  - Minimum: 8GB RAM, 4 CPU cores, 100GB storage
  - Recommended: 16GB+ RAM, 8+ CPU cores, 500GB+ storage
- [ ] Network equipment (router, switch)
- [ ] Basic understanding of Linux, Docker, and networking
- [ ] Git installed on your local machine

## Step 1: Clone the Repository

```bash
git clone https://github.com/gmastrokostas/myhomelab.git
cd myhomelab
```

## Step 2: Plan Your Setup

Before deploying anything, review and customize:

1. **Network Configuration** - Review [docs/network.md](network.md)
   - Plan your IP addressing scheme
   - Design VLAN segmentation
   - Configure DNS and DHCP

2. **Services Inventory** - Review [docs/services-inventory.md](services-inventory.md)
   - Decide which services you want to run
   - Plan resource allocation
   - Prioritize critical services

3. **Security** - Review [docs/security.md](security.md)
   - Plan authentication strategy
   - Configure firewall rules
   - Set up VPN access

## Step 3: Initial Server Setup

### Option A: Using Ansible (Recommended)

1. Configure your inventory:
   ```bash
   cd ansible
   cp inventory/hosts.yml.example inventory/hosts.yml
   # Edit inventory/hosts.yml with your server details
   ```

2. Run the setup playbook:
   ```bash
   ansible-playbook -i inventory/hosts.yml playbooks/setup.yml
   ```

### Option B: Manual Setup

1. Update your system:
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

2. Install Docker:
   ```bash
   curl -fsSL https://get.docker.com -o get-docker.sh
   sudo sh get-docker.sh
   sudo usermod -aG docker $USER
   ```

3. Install Docker Compose:
   ```bash
   sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
   sudo chmod +x /usr/local/bin/docker-compose
   ```

## Step 4: Configure Environment Variables

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` with your specific settings:
   ```bash
   nano .env
   ```

   Update at minimum:
   - `TZ` - Your timezone
   - `DOMAIN` - Your domain name
   - `DATA_ROOT` - Path to your data storage
   - `CONFIG_ROOT` - Path to configuration storage

## Step 5: Deploy Services

### Deploy Basic Monitoring Stack

1. Navigate to the monitoring directory:
   ```bash
   cd monitoring
   ```

2. Deploy the stack:
   ```bash
   docker-compose up -d
   ```

3. Access Grafana:
   - URL: http://your-server-ip:3000
   - Default credentials: admin/admin (change immediately!)

### Deploy Additional Services

1. Navigate to the docker directory:
   ```bash
   cd ../docker
   ```

2. Review and customize `docker-compose.yml`

3. Deploy services:
   ```bash
   docker-compose up -d
   ```

## Step 6: Configure Backups

1. Review the backup strategy: [docs/backup.md](backup.md)

2. Configure backup destination:
   ```bash
   # Edit backup scripts
   nano scripts/backup-docker-volumes.sh
   # Update BACKUP_DIR variable
   ```

3. Set up automated backups with cron:
   ```bash
   crontab -e
   # Add daily backup at 2 AM
   0 2 * * * /opt/homelab/scripts/backup-docker-volumes.sh
   ```

## Step 7: Set Up Monitoring

1. Access Grafana (http://your-server-ip:3000)

2. Add Prometheus datasource:
   - Configuration → Data Sources → Add data source
   - Select Prometheus
   - URL: http://prometheus:9090
   - Save & Test

3. Import dashboards:
   - Dashboards → Import
   - Enter dashboard ID:
     - Node Exporter Full: 1860
     - Docker Monitoring: 193
   - Select Prometheus datasource
   - Import

4. Add Loki datasource for logs:
   - Configuration → Data Sources → Add data source
   - Select Loki
   - URL: http://loki:3100
   - Save & Test

## Step 8: Secure Your Setup

1. **Change Default Passwords**
   - Grafana admin password
   - Any service admin passwords

2. **Configure Firewall**
   ```bash
   sudo ufw default deny incoming
   sudo ufw default allow outgoing
   sudo ufw allow 22/tcp  # SSH
   sudo ufw allow 443/tcp # HTTPS
   sudo ufw enable
   ```

3. **Set Up SSH Key Authentication**
   ```bash
   ssh-copy-id user@your-server
   ```

4. **Review Security Checklist**: [docs/security.md](security.md)

## Step 9: Test Your Setup

1. Run the health check script:
   ```bash
   ./scripts/health-check.sh
   ```

2. Verify services are running:
   ```bash
   docker ps
   ```

3. Test backups:
   ```bash
   ./scripts/verify-backups.sh
   ```

## Step 10: Document Your Setup

1. Update [docs/services-inventory.md](services-inventory.md) with:
   - Services you've deployed
   - Service URLs
   - Credentials (securely!)
   - Status of each service

2. Document any customizations you've made

3. Keep configuration in version control:
   ```bash
   git add .
   git commit -m "Initial homelab setup"
   git push
   ```

## Next Steps

### Expand Your Services

Consider adding:
- **Storage**: Nextcloud, PhotoPrism
- **Media**: Plex, Jellyfin
- **Automation**: Home Assistant, Node-RED
- **Security**: Vaultwarden, Authelia
- **Development**: GitLab, Gitea

### Improve Infrastructure

- Set up Kubernetes cluster
- Implement GitOps workflow
- Add centralized authentication (Authelia)
- Configure reverse proxy (Nginx Proxy Manager, Traefik)
- Set up VPN (WireGuard)
- Implement IDS/IPS

### Optimize Operations

- Automate updates
- Set up alerting
- Implement offsite backups
- Create runbooks for common tasks
- Document troubleshooting procedures

## Resources

- [Awesome Self-Hosted](https://github.com/awesome-selfhosted/awesome-selfhosted)
- [r/homelab](https://www.reddit.com/r/homelab/)
- [r/selfhosted](https://www.reddit.com/r/selfhosted/)
- [Self-Hosted Podcast](https://selfhosted.show/)
- [Docker Documentation](https://docs.docker.com/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)

## Getting Help

If you run into issues:

1. Check the [Troubleshooting Guide](troubleshooting.md)
2. Review service logs: `docker logs <container-name>`
3. Check system resources: `./scripts/health-check.sh`
4. Search for similar issues online
5. Ask in homelab communities

## Maintenance Schedule

Set up a regular maintenance schedule:

- **Daily**: Check monitoring dashboards
- **Weekly**: Review logs, update containers
- **Monthly**: System updates, backup verification
- **Quarterly**: Security audit, disaster recovery test

Good luck with your homelab journey! 🚀
