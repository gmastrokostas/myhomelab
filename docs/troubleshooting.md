# Troubleshooting Guide

Common issues and their solutions for the homelab environment.

## General Troubleshooting Steps

1. **Check the basics**
   - Is the service running?
   - Are there any error messages in logs?
   - Has anything changed recently?

2. **Gather information**
   - Check service status
   - Review logs
   - Verify network connectivity
   - Check resource usage

3. **Isolate the problem**
   - Test components individually
   - Verify dependencies
   - Check configuration

4. **Apply fix and verify**
   - Make changes incrementally
   - Test after each change
   - Document the solution

## Docker Issues

### Container Won't Start

```bash
# Check container logs
docker logs <container-name>

# Check container inspect for errors
docker inspect <container-name>

# Try running interactively
docker run -it <image-name> /bin/sh
```

**Common causes:**
- Port already in use
- Volume mount issues
- Missing environment variables
- Image pull failures
- Resource constraints

### Container Keeps Restarting

```bash
# Check restart count and logs
docker ps -a
docker logs <container-name> --tail 100

# Check resource limits
docker stats <container-name>
```

**Common causes:**
- Application crash on startup
- Health check failures
- Configuration errors
- Missing dependencies

### Volume Issues

```bash
# List volumes
docker volume ls

# Inspect volume
docker volume inspect <volume-name>

# Check volume mount permissions
docker run --rm -v <volume-name>:/data alpine ls -la /data
```

**Common causes:**
- Permission issues
- Volume full
- Corrupted data
- Wrong mount paths

## Network Issues

### Can't Access Service

```bash
# Check if service is listening
netstat -tlnp | grep <port>
ss -tlnp | grep <port>

# Test locally
curl localhost:<port>

# Test from another machine
curl <hostname>:<port>

# Check firewall
ufw status
iptables -L -n
```

**Common causes:**
- Service not running
- Wrong port number
- Firewall blocking
- DNS issues
- Reverse proxy misconfiguration

### DNS Resolution Problems

```bash
# Test DNS resolution
nslookup example.com
dig example.com

# Check DNS configuration
cat /etc/resolv.conf

# Test with specific DNS server
nslookup example.com 8.8.8.8
```

**Common causes:**
- DNS server down
- Wrong DNS configuration
- Pi-hole blocking
- Firewall blocking DNS

### VLAN Connectivity Issues

```bash
# Check VLAN configuration
ip link show
ip addr show

# Test VLAN connectivity
ping <gateway-ip>

# Check routing
ip route show
```

**Common causes:**
- VLAN not configured on switch
- Wrong VLAN tag
- Firewall blocking inter-VLAN
- Switch port not in trunk mode

## Kubernetes Issues

### Pods Not Starting

```bash
# Check pod status
kubectl get pods -n <namespace>

# Describe pod for events
kubectl describe pod <pod-name> -n <namespace>

# Check logs
kubectl logs <pod-name> -n <namespace>
```

**Common causes:**
- Image pull failures
- Resource constraints
- ConfigMap/Secret missing
- Volume mount issues

### Service Not Accessible

```bash
# Check service
kubectl get svc -n <namespace>

# Check endpoints
kubectl get endpoints <service-name> -n <namespace>

# Test from another pod
kubectl run -it --rm debug --image=alpine --restart=Never -- sh
wget -O- http://<service-name>.<namespace>
```

**Common causes:**
- Service selector mismatch
- Pod labels incorrect
- Network policy blocking
- DNS issues

## Proxmox Issues

### VM Won't Start

```bash
# Check VM status
qm status <vmid>

# Check VM configuration
qm config <vmid>

# Check system logs
journalctl -u pve-cluster
```

**Common causes:**
- Insufficient resources
- Storage issues
- Configuration errors
- Lock files

### Storage Issues

```bash
# Check storage status
pvesm status

# Check disk usage
df -h
zpool status  # if using ZFS
```

**Common causes:**
- Storage full
- Storage offline
- Permission issues
- Thin provisioning over-allocated

## Performance Issues

### High CPU Usage

```bash
# Check CPU usage
top
htop

# Find top CPU processes
ps aux --sort=-%cpu | head

# Check per-container CPU
docker stats
```

**Solutions:**
- Identify and optimize/stop CPU-intensive processes
- Add resource limits to containers
- Scale horizontally
- Upgrade hardware

### High Memory Usage

```bash
# Check memory usage
free -h
vmstat 1

# Find memory-intensive processes
ps aux --sort=-%mem | head

# Check for memory leaks
watch -n 1 free -h
```

**Solutions:**
- Identify and restart memory-leaking processes
- Add memory limits to containers
- Optimize application memory usage
- Add more RAM

### Disk I/O Issues

```bash
# Check disk I/O
iostat -x 1
iotop

# Check disk usage
df -h
du -sh /* | sort -h
```

**Solutions:**
- Identify I/O-intensive processes
- Use faster storage (SSD)
- Optimize database queries
- Implement caching

## Monitoring Issues

### Prometheus Not Scraping

```bash
# Check targets in Prometheus UI
# Navigate to: Status -> Targets

# Check Prometheus configuration
docker logs prometheus

# Test scrape endpoint
curl <target-url>/metrics
```

**Common causes:**
- Incorrect target configuration
- Network connectivity
- Exporter not running
- Firewall blocking

### Grafana Dashboard Issues

```bash
# Check Grafana logs
docker logs grafana

# Verify datasource connection
# In Grafana UI: Configuration -> Data Sources -> Test

# Check query syntax
# Use Explore feature to test queries
```

**Common causes:**
- Datasource misconfigured
- Query syntax errors
- No data in time range
- Permissions issues

## Backup/Restore Issues

### Backup Fails

```bash
# Check backup logs
cat /var/log/homelab-backup.log

# Verify backup destination accessible
df -h /mnt/nas/backups

# Test backup manually
/opt/homelab/scripts/backup.sh
```

**Common causes:**
- Destination full
- Permission issues
- Network issues
- Service not stopped for backup

### Restore Fails

```bash
# Verify backup integrity
tar tzf backup.tar.gz

# Check restore destination
ls -la /restore/path

# Verify permissions
id
```

**Common causes:**
- Corrupted backup
- Permission issues
- Insufficient space
- Wrong restore path

## Security Issues

### Locked Out

**SSH access lost:**
1. Use console access (Proxmox, iLO, etc.)
2. Reset password or add SSH key
3. Review SSH configuration

**Lost password:**
1. Boot into recovery mode
2. Reset root password
3. Review authentication logs

### Suspected Compromise

1. **Isolate** - Disconnect from network
2. **Analyze** - Check logs, running processes
3. **Preserve** - Save evidence
4. **Clean** - Rebuild from clean backup
5. **Harden** - Update and improve security

```bash
# Check for suspicious processes
ps aux | grep -v "\[.*\]"

# Check network connections
netstat -antp

# Check login history
last
lastb

# Check for rootkits
apt install rkhunter
rkhunter --check
```

## Useful Commands

### System Information

```bash
# System info
uname -a
hostnamectl

# Resource usage
htop
free -h
df -h

# Network info
ip addr show
ip route show
```

### Service Management

```bash
# Systemd services
systemctl status <service>
systemctl restart <service>
systemctl enable <service>
journalctl -u <service> -f

# Docker services
docker ps
docker logs -f <container>
docker restart <container>
```

### Log Viewing

```bash
# System logs
journalctl -f
tail -f /var/log/syslog

# Docker logs
docker logs -f <container>
docker-compose logs -f

# Kubernetes logs
kubectl logs -f <pod> -n <namespace>
```

## Getting Help

### Before Asking for Help

1. Check logs for errors
2. Review recent changes
3. Search for similar issues
4. Try basic troubleshooting

### Where to Get Help

- **Documentation**: Check service-specific docs
- **Forums**: Reddit r/homelab, r/selfhosted
- **Discord**: Homelab Discord servers
- **GitHub**: Project issue trackers
- **Stack Overflow**: Technical questions

### Providing Information

When asking for help, include:
- Exact error messages
- Relevant logs
- System information
- What you've tried
- Recent changes

## Prevention

### Best Practices
- Regular backups
- Monitor disk space
- Keep systems updated
- Document changes
- Test before deploying
- Monitor services
- Review logs regularly

### Maintenance Schedule
- Daily: Check monitoring dashboards
- Weekly: Review logs, update containers
- Monthly: System updates, backup verification
- Quarterly: Security audit, disaster recovery test
