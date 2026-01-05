# Networking Directory

This directory contains network-related configurations and documentation.

## Contents

- Network diagrams
- Router/Firewall configurations
- VLAN configurations
- DNS configurations
- VPN configurations

## Documentation

See [Network Configuration](../docs/network.md) for detailed network documentation.

## Configuration Examples

### Router Configuration
- Static routes
- Port forwarding rules
- NAT configurations

### Firewall Rules
- Inter-VLAN rules
- Port filtering
- IDS/IPS rules

### VPN Configuration
- WireGuard configurations
- OpenVPN configurations
- Client configurations

## Network Diagram

```
          Internet
              |
          [Router]
              |
        [Core Switch]
         /    |    \
    VLAN10 VLAN20 VLAN30
     (Mgmt) (Srv) (Storage)
```

## IP Addressing

See the main [network documentation](../docs/network.md) for detailed IP addressing schemes.
