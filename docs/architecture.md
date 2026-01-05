# Architecture Overview

This document provides a high-level overview of the homelab architecture.

## Infrastructure Layers

```
┌─────────────────────────────────────────────────┐
│              Application Layer                   │
│  (Docker Containers, VMs, Services)             │
└─────────────────────────────────────────────────┘
                      ▲
                      │
┌─────────────────────────────────────────────────┐
│           Orchestration Layer                    │
│  (Docker Compose, Kubernetes, Proxmox)          │
└─────────────────────────────────────────────────┘
                      ▲
                      │
┌─────────────────────────────────────────────────┐
│              Compute Layer                       │
│  (Physical/Virtual Servers)                     │
└─────────────────────────────────────────────────┘
                      ▲
                      │
┌─────────────────────────────────────────────────┐
│              Network Layer                       │
│  (VLANs, Firewall, Router, Switch)             │
└─────────────────────────────────────────────────┘
                      ▲
                      │
┌─────────────────────────────────────────────────┐
│              Storage Layer                       │
│  (NAS, SAN, Local Storage)                      │
└─────────────────────────────────────────────────┘
```

## Design Principles

### 1. Infrastructure as Code (IaC)
- All configurations version controlled
- Reproducible deployments
- Easy rollback capabilities
- Documentation through code

### 2. Separation of Concerns
- Network segmentation with VLANs
- Service isolation with containers
- Role-based access control
- Separate development/production

### 3. High Availability
- Redundant services where critical
- Regular backups
- Monitoring and alerting
- Disaster recovery plan

### 4. Security First
- Defense in depth
- Principle of least privilege
- Regular security updates
- Network segmentation
- SSL/TLS everywhere

### 5. Observability
- Centralized logging
- Metrics collection
- Distributed tracing
- Real-time alerting

## Component Architecture

### Compute Infrastructure

#### Hypervisor Layer (Proxmox)
- **Purpose**: Virtualization and containerization
- **Components**:
  - VM hosting
  - LXC containers
  - Resource management
  - Backup management

#### Container Platform (Docker)
- **Purpose**: Application containerization
- **Components**:
  - Docker Engine
  - Docker Compose
  - Container networking
  - Volume management

#### Orchestration (Kubernetes) - Optional
- **Purpose**: Container orchestration at scale
- **Components**:
  - Control plane
  - Worker nodes
  - Ingress controller
  - Persistent storage

### Network Architecture

#### Edge Layer
- **Router/Firewall**: pfSense/OPNsense
- **VPN**: WireGuard for remote access
- **IDS/IPS**: Suricata for threat detection

#### Core Layer
- **Switch**: Managed switch with VLAN support
- **DNS**: Pi-hole for ad-blocking and DNS
- **Reverse Proxy**: Nginx/Traefik for routing

### Storage Architecture

#### Primary Storage
- **NAS**: Network attached storage for media and backups
- **SAN**: (Optional) Block storage for VMs

#### Backup Strategy
- **Local Backups**: Incremental backups to secondary storage
- **Offsite Backups**: Cloud backup for critical data
- **Snapshot**: VM/Container snapshots for quick recovery

### Monitoring Architecture

#### Metrics Collection
- **Prometheus**: Time-series metrics
- **Node Exporter**: System metrics
- **cAdvisor**: Container metrics

#### Visualization
- **Grafana**: Dashboards and alerts
- **Uptime Kuma**: Service uptime tracking

#### Logging
- **Loki**: Log aggregation
- **Promtail**: Log shipping

### Security Architecture

#### Identity & Access
- **Authelia**: SSO and 2FA
- **Vaultwarden**: Password management

#### Network Security
- **Firewall**: VLAN-based segmentation
- **VPN**: Secure remote access
- **WAF**: Web application firewall

#### Secrets Management
- **Ansible Vault**: Encrypted variables
- **Docker Secrets**: Container secrets
- **.env Files**: Environment variables (not in git)

## Data Flow

### External Request Flow

```
Internet Request
    ↓
Router/Firewall (Port Forward)
    ↓
Reverse Proxy (SSL Termination)
    ↓
Authentication (Authelia - if required)
    ↓
Internal Service
    ↓
Response
```

### Internal Service Communication

```
Service A (Container)
    ↓
Docker Network / K8s Service
    ↓
Service B (Container)
```

### Monitoring Data Flow

```
Application/Service
    ↓
Metrics Exporter
    ↓
Prometheus (Scraping)
    ↓
Grafana (Visualization)
    ↓
Alertmanager (Alerting)
```

## Deployment Workflow

### 1. Infrastructure Provisioning
- Terraform provisions base infrastructure
- Ansible configures OS and base services

### 2. Service Deployment
- Docker Compose deploys containerized services
- Kubernetes deploys orchestrated workloads

### 3. Configuration Management
- Git manages all configuration files
- Automated deployments via CI/CD (optional)

### 4. Monitoring Setup
- Prometheus scrapes metrics
- Grafana displays dashboards
- Alerts configured for issues

## Scaling Strategy

### Vertical Scaling
- Add more resources to existing hosts
- Upgrade CPU, RAM, storage

### Horizontal Scaling
- Add more compute nodes
- Load balance across nodes
- Distribute services

## Disaster Recovery

### Recovery Time Objective (RTO)
- Critical Services: < 1 hour
- Non-Critical Services: < 24 hours

### Recovery Point Objective (RPO)
- Critical Data: < 1 hour
- Non-Critical Data: < 24 hours

### Backup Locations
1. Local NAS (primary backup)
2. External drive (secondary backup)
3. Cloud storage (tertiary backup)

## Technology Stack

### Virtualization
- Proxmox VE
- Docker
- Kubernetes (optional)

### Configuration Management
- Ansible
- Terraform

### Monitoring
- Prometheus
- Grafana
- Loki

### Networking
- pfSense/OPNsense
- Pi-hole
- Nginx/Traefik

### Storage
- ZFS (optional)
- NFS/SMB shares

## Future Enhancements

- [ ] Implement GitOps workflow
- [ ] Add Kubernetes cluster
- [ ] Set up offsite backup
- [ ] Implement IDS/IPS
- [ ] Add centralized authentication
- [ ] Set up CI/CD pipeline
- [ ] Implement disaster recovery testing
