# Docker Services

This directory contains Docker Compose configurations for various self-hosted services.

## Structure

```
docker/
├── docker-compose.yml          # Main compose file
├── .env.example               # Example environment variables
└── services/                  # Individual service configurations
```

## Usage

### Starting Services

```bash
# Start all services
docker-compose up -d

# Start specific service
docker-compose up -d <service-name>

# View logs
docker-compose logs -f <service-name>
```

### Stopping Services

```bash
# Stop all services
docker-compose down

# Stop specific service
docker-compose stop <service-name>
```

### Updating Services

```bash
# Pull latest images
docker-compose pull

# Recreate containers with new images
docker-compose up -d --force-recreate
```

## Configuration

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` with your specific configuration:
   - Domain names
   - Ports
   - Passwords
   - API keys

3. Adjust `docker-compose.yml` as needed for your setup

## Available Services

Services can be added to the compose file as needed. Common homelab services include:

- **Media**: Plex, Jellyfin, Emby
- **Automation**: Home Assistant, Node-RED
- **Monitoring**: Prometheus, Grafana, Uptime Kuma
- **Networking**: Pi-hole, Nginx Proxy Manager, Traefik
- **Storage**: Nextcloud, PhotoPrism
- **Security**: Vaultwarden, Authelia

## Networks

Services are organized into networks:
- `frontend` - Services exposed to users
- `backend` - Internal services
- `monitoring` - Monitoring stack

## Volumes

Persistent data is stored in named volumes or bind mounts. Backup these regularly!

## Security Notes

- Always change default passwords
- Use strong passwords stored in `.env`
- Keep images updated
- Limit exposed ports
- Use reverse proxy for SSL/TLS
