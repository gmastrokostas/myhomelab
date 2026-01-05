# Network Configuration

This document describes the network configuration for the homelab environment.

## Network Topology

```
Internet
    |
    v
Router/Firewall
    |
    v
Core Switch
    |
    +-- VLAN 10: Management (192.168.10.0/24)
    +-- VLAN 20: Servers (192.168.20.0/24)
    +-- VLAN 30: Storage (192.168.30.0/24)
    +-- VLAN 40: IoT/Smart Home (192.168.40.0/24)
    +-- VLAN 99: Guest (192.168.99.0/24)
```

## VLANs

### VLAN 10 - Management
- **Network**: 192.168.10.0/24
- **Gateway**: 192.168.10.1
- **Purpose**: Network equipment management, hypervisor management
- **Access**: Restricted to admin devices

### VLAN 20 - Servers
- **Network**: 192.168.20.0/24
- **Gateway**: 192.168.20.1
- **Purpose**: Docker hosts, VMs, application servers
- **Access**: Internal only, reverse proxy for external access

### VLAN 30 - Storage
- **Network**: 192.168.30.0/24
- **Gateway**: 192.168.30.1
- **Purpose**: NAS, storage arrays, backup servers
- **Access**: Server VLAN only

### VLAN 40 - IoT/Smart Home
- **Network**: 192.168.40.0/24
- **Gateway**: 192.168.40.1
- **Purpose**: IoT devices, smart home devices
- **Access**: Isolated, no internet access for security

### VLAN 99 - Guest
- **Network**: 192.168.99.0/24
- **Gateway**: 192.168.99.1
- **Purpose**: Guest devices
- **Access**: Internet only, isolated from other VLANs

## IP Address Allocation

### Static IP Assignments

| IP Address | Hostname | Purpose |
|------------|----------|---------|
| 192.168.20.10 | docker-host-01 | Primary Docker host |
| 192.168.20.11 | docker-host-02 | Secondary Docker host |
| 192.168.20.20 | k8s-master | Kubernetes master node |
| 192.168.20.21-23 | k8s-worker-* | Kubernetes worker nodes |
| 192.168.30.10 | nas | NAS storage |
| 192.168.30.20 | backup | Backup server |

### DHCP Ranges

- VLAN 10: 192.168.10.100-192.168.10.200
- VLAN 20: 192.168.20.100-192.168.20.200
- VLAN 40: 192.168.40.100-192.168.40.200
- VLAN 99: 192.168.99.100-192.168.99.200

## DNS Configuration

### Internal DNS
- Primary DNS: 192.168.10.1 (Pi-hole)
- Secondary DNS: 1.1.1.1 (Cloudflare)

### DNS Records

| Record | Type | Value |
|--------|------|-------|
| homelab.local | A | 192.168.20.10 |
| *.homelab.local | A | 192.168.20.10 |
| nas.homelab.local | A | 192.168.30.10 |

## Firewall Rules

### Inter-VLAN Rules

1. Management → All: Allow (for administration)
2. Servers → Storage: Allow
3. Servers → IoT: Allow (for Home Assistant, etc.)
4. IoT → Internet: Deny
5. Guest → All VLANs: Deny
6. Guest → Internet: Allow

### Port Forwarding

| External Port | Internal IP | Internal Port | Service |
|---------------|-------------|---------------|---------|
| 443 | 192.168.20.10 | 443 | HTTPS (Reverse Proxy) |

## Reverse Proxy

Using Nginx Proxy Manager or Traefik:
- All external HTTPS traffic → 192.168.20.10:443
- SSL/TLS termination at proxy
- Internal routing to services

## VPN Access

- OpenVPN/WireGuard server for remote access
- VPN clients placed in Management VLAN
- Split tunneling for better performance

## Network Security

### Best Practices
1. Disable unused ports on switches
2. Enable MAC address filtering on sensitive VLANs
3. Use strong passwords for network equipment
4. Regularly update firmware
5. Monitor network traffic for anomalies
6. Use VLANs to segment traffic
7. Implement firewall rules between VLANs
8. Disable WPS on WiFi
9. Use WPA3 where possible
10. Regular security audits

### IDS/IPS
Consider implementing:
- Suricata or Snort for intrusion detection
- pfSense or OPNsense for firewall/routing

## Monitoring

Network monitoring tools:
- SNMP for device monitoring
- NetFlow/sFlow for traffic analysis
- Uptime monitoring for services
- Bandwidth monitoring

## Documentation

Keep updated documentation of:
- Network diagram
- IP address assignments
- VLAN configurations
- Firewall rules
- DNS records
- Device configurations

## Troubleshooting

### Common Issues

1. **No internet access**
   - Check gateway configuration
   - Verify DNS settings
   - Check firewall rules

2. **Can't access services**
   - Verify service is running
   - Check firewall rules
   - Verify reverse proxy configuration

3. **VLAN isolation issues**
   - Check switch VLAN configuration
   - Verify trunk ports
   - Check inter-VLAN firewall rules
