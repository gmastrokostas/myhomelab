# Security Best Practices

This document outlines security best practices for the homelab environment.

## General Security Principles

### Defense in Depth
Implement multiple layers of security:
1. Network perimeter security
2. Host-level security
3. Application security
4. Data security

### Principle of Least Privilege
- Grant minimum necessary permissions
- Use service accounts with limited access
- Regular access reviews
- Remove unused accounts

### Zero Trust
- Verify everything
- Never trust, always verify
- Segment networks
- Authenticate all access

## Network Security

### Firewall Configuration

```bash
# Block all incoming by default
ufw default deny incoming
ufw default allow outgoing

# Allow SSH (consider changing default port)
ufw allow 22/tcp

# Allow specific services
ufw allow 80/tcp
ufw allow 443/tcp

# Enable firewall
ufw enable
```

### VLAN Segmentation
- Separate management, services, IoT, and guest networks
- Implement firewall rules between VLANs
- Restrict inter-VLAN communication
- Monitor cross-VLAN traffic

### VPN Security
- Use WireGuard or OpenVPN
- Strong encryption (AES-256)
- Certificate-based authentication
- Split tunneling where appropriate
- Regular key rotation

## Access Control

### SSH Security

```bash
# Disable root login
PermitRootLogin no

# Use key-based authentication only
PasswordAuthentication no
PubkeyAuthentication yes

# Disable empty passwords
PermitEmptyPasswords no

# Change default port (security through obscurity)
Port 2222

# Limit user access
AllowUsers admin

# Enable fail2ban
apt install fail2ban
```

### Password Policy
- Minimum 16 characters for admin accounts
- Minimum 12 characters for user accounts
- Use password manager (Vaultwarden)
- Enable 2FA where possible
- Regular password rotation for critical accounts

### Two-Factor Authentication
Implement 2FA for:
- SSH access
- Admin panels
- VPN access
- Critical services

## Application Security

### Container Security

```yaml
# Docker security best practices
services:
  app:
    # Run as non-root user
    user: "1000:1000"
    
    # Read-only root filesystem
    read_only: true
    
    # Drop capabilities
    cap_drop:
      - ALL
    cap_add:
      - NET_BIND_SERVICE
    
    # No new privileges
    security_opt:
      - no-new-privileges:true
    
    # Resource limits
    mem_limit: 512m
    cpus: 0.5
```

### Secrets Management

**Never commit secrets to git!**

```bash
# Use environment variables
DB_PASSWORD=${DB_PASSWORD}

# Use Docker secrets
docker secret create db_password ./db_password.txt

# Use Ansible Vault
ansible-vault create secrets.yml
```

### SSL/TLS Configuration

```nginx
# Strong SSL configuration
ssl_protocols TLSv1.2 TLSv1.3;
ssl_ciphers HIGH:!aNULL:!MD5;
ssl_prefer_server_ciphers on;

# HSTS
add_header Strict-Transport-Security "max-age=31536000" always;

# Other security headers
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
```

## System Security

### System Updates

```bash
# Automated security updates (Debian/Ubuntu)
apt install unattended-upgrades
dpkg-reconfigure -plow unattended-upgrades

# Manual updates
apt update && apt upgrade -y
```

### File Integrity Monitoring

```bash
# Install AIDE
apt install aide

# Initialize database
aideinit

# Check for changes
aide --check
```

### Audit Logging

```bash
# Install auditd
apt install auditd

# Monitor important files
auditctl -w /etc/passwd -p wa -k passwd_changes
auditctl -w /etc/shadow -p wa -k shadow_changes

# View audit logs
ausearch -k passwd_changes
```

## Data Security

### Encryption at Rest

```bash
# Encrypt sensitive volumes with LUKS
cryptsetup luksFormat /dev/sdX
cryptsetup luksOpen /dev/sdX encrypted_volume
mkfs.ext4 /dev/mapper/encrypted_volume
```

### Encryption in Transit
- Always use HTTPS/TLS
- Use VPN for remote access
- Encrypt database connections
- Use SSH for file transfers

### Backup Security
- Encrypt backup files
- Secure backup storage
- Test backup restoration
- Offsite backup copies

## Monitoring & Detection

### Log Management

```yaml
# Centralized logging with Loki
- Collect logs from all services
- Set retention policies
- Create alerts for suspicious activity
- Regular log review
```

### Intrusion Detection

```bash
# Install and configure fail2ban
apt install fail2ban

# Custom jail for service
[custom-service]
enabled = true
port = 8080
filter = custom-service
logpath = /var/log/custom-service.log
maxretry = 5
```

### Security Alerts

Monitor and alert on:
- Failed login attempts
- Unusual network traffic
- Service outages
- Certificate expiration
- Vulnerability disclosures

## Vulnerability Management

### Regular Scanning

```bash
# Run security scans
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image nginx:latest

# System vulnerability scan
apt install lynis
lynis audit system
```

### Patch Management
- Subscribe to security mailing lists
- Regular system updates
- Test updates in non-production first
- Maintain update schedule
- Document critical patches

## Incident Response

### Preparation
1. Document procedures
2. Keep contact information current
3. Maintain offline backups
4. Test recovery procedures

### Detection
- Monitor logs and alerts
- Watch for anomalies
- Regular security audits
- Vulnerability scans

### Response
1. Isolate affected systems
2. Preserve evidence
3. Analyze the incident
4. Contain and eradicate
5. Recover systems
6. Document lessons learned

### Recovery
- Restore from clean backups
- Rebuild compromised systems
- Change all credentials
- Update security measures

## Compliance Checklist

### Monthly
- [ ] Review user access
- [ ] Check for system updates
- [ ] Review firewall rules
- [ ] Verify backup integrity
- [ ] Check SSL certificate expiration

### Quarterly
- [ ] Security audit
- [ ] Vulnerability scan
- [ ] Review logs for anomalies
- [ ] Test incident response
- [ ] Update documentation

### Annually
- [ ] Comprehensive security review
- [ ] Penetration testing
- [ ] Disaster recovery test
- [ ] Security training review
- [ ] Policy updates

## Security Tools

### Recommended Tools
- **Firewall**: pfSense, OPNsense, UFW
- **IDS/IPS**: Suricata, Snort
- **Vulnerability Scanner**: Nessus, OpenVAS, Trivy
- **Password Manager**: Vaultwarden, Bitwarden
- **2FA**: Authelia, Authentik
- **Monitoring**: Prometheus, Grafana, Wazuh
- **Log Analysis**: ELK Stack, Loki

## Resources

### Security Advisories
- [NVD](https://nvd.nist.gov/)
- [US-CERT](https://www.us-cert.gov/)
- [Docker Security](https://docs.docker.com/engine/security/)

### Best Practices
- [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks/)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)

### Learning
- [HackTheBox](https://www.hackthebox.eu/)
- [TryHackMe](https://tryhackme.com/)
- [Security Now Podcast](https://twit.tv/shows/security-now)

## Remember

> "Security is not a product, but a process." - Bruce Schneier

- Stay informed about new threats
- Regular security updates
- Multiple layers of defense
- Plan for compromise
- Test your defenses
- Document everything
