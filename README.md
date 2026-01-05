# My Homelab

This repository contains the infrastructure-as-code, configurations, and documentation for my homelab environment.

## 📋 Overview

This homelab setup provides a comprehensive infrastructure for self-hosting services, learning, and experimentation with various technologies including containers, orchestration, automation, and monitoring.

## 🗂️ Repository Structure

```
.
├── docker/              # Docker Compose configurations
├── kubernetes/          # Kubernetes manifests and configurations
├── ansible/             # Ansible playbooks for automation
├── terraform/           # Terraform infrastructure definitions
├── monitoring/          # Monitoring and observability configs
├── networking/          # Network configuration and documentation
├── scripts/             # Utility scripts for maintenance
└── docs/               # Additional documentation
```

## 🚀 Quick Start

### Prerequisites

- Physical server or VM with minimum 8GB RAM, 4 CPU cores, 100GB storage
- Docker and Docker Compose
- Basic Linux command-line knowledge
- Git

### Getting Started

**For detailed setup instructions, see the [Getting Started Guide](docs/getting-started.md).**

Quick setup:

1. Clone this repository:
   ```bash
   git clone https://github.com/gmastrokostas/myhomelab.git
   cd myhomelab
   ```

2. Copy and configure environment variables:
   ```bash
   cp .env.example .env
   # Edit .env with your specific settings
   ```

3. Deploy monitoring stack:
   ```bash
   cd monitoring
   docker-compose up -d
   ```

4. Access Grafana at http://your-server-ip:3000 (default: admin/admin)

## 📦 Services

See [Services Inventory](docs/services-inventory.md) for a complete list of deployed services and their purposes.

## 🔧 Configuration

Each directory contains its own README with specific configuration instructions:

- [Docker Services](docker/README.md)
- [Kubernetes Setup](kubernetes/README.md)
- [Ansible Playbooks](ansible/README.md)
- [Terraform Infrastructure](terraform/README.md)
- [Monitoring Stack](monitoring/README.md)

## 🔐 Security

- All sensitive data should be stored in `.env` files (not committed to git)
- Use secrets management for production credentials
- Review the [Security Best Practices](docs/security.md) guide

## 📖 Documentation

Additional documentation can be found in the [docs](docs/) directory:

- [Getting Started Guide](docs/getting-started.md) - **Start here!**
- [Architecture Overview](docs/architecture.md)
- [Network Configuration](docs/network.md)
- [Backup Strategy](docs/backup.md)
- [Security Best Practices](docs/security.md)
- [Troubleshooting Guide](docs/troubleshooting.md)
- [Services Inventory](docs/services-inventory.md)

## 🤝 Contributing

Feel free to fork this repository and adapt it for your own homelab. If you have improvements or suggestions, pull requests are welcome!

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Resources

- [Awesome Homelab](https://github.com/awesome-selfhosted/awesome-selfhosted)
- [r/homelab](https://www.reddit.com/r/homelab/)
- [Self-Hosted Podcast](https://selfhosted.show/)
