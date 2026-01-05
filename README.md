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

- Docker and Docker Compose
- kubectl (for Kubernetes deployments)
- Ansible (for automation)
- Terraform (for infrastructure provisioning)

### Getting Started

1. Clone this repository:
   ```bash
   git clone https://github.com/gmastrokostas/myhomelab.git
   cd myhomelab
   ```

2. Copy the example environment file and configure:
   ```bash
   cp .env.example .env
   # Edit .env with your specific settings
   ```

3. Review the services inventory to understand available services:
   ```bash
   cat docs/services-inventory.md
   ```

4. Deploy services using Docker Compose:
   ```bash
   cd docker
   docker-compose up -d
   ```

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

- [Architecture Overview](docs/architecture.md)
- [Network Configuration](docs/network.md)
- [Backup Strategy](docs/backup.md)
- [Troubleshooting Guide](docs/troubleshooting.md)

## 🤝 Contributing

Feel free to fork this repository and adapt it for your own homelab. If you have improvements or suggestions, pull requests are welcome!

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Resources

- [Awesome Homelab](https://github.com/awesome-selfhosted/awesome-selfhosted)
- [r/homelab](https://www.reddit.com/r/homelab/)
- [Self-Hosted Podcast](https://selfhosted.show/)
