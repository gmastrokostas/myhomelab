#!/bin/bash
# Update Docker containers
# Usage: ./update-containers.sh

set -e

LOG_FILE="${LOG_FILE:-/var/log/docker-update.log}"

echo "[$(date)] Starting container updates" | tee -a "$LOG_FILE"

# Navigate to docker directory
DOCKER_DIR="${DOCKER_DIR:-/opt/homelab/docker}"

if [ ! -d "$DOCKER_DIR" ]; then
    echo "[$(date)] ERROR: Docker directory not found: $DOCKER_DIR" | tee -a "$LOG_FILE"
    exit 1
fi

cd "$DOCKER_DIR"

# Pull latest images
echo "[$(date)] Pulling latest images" | tee -a "$LOG_FILE"
docker-compose pull

# Recreate containers with new images
echo "[$(date)] Recreating containers" | tee -a "$LOG_FILE"
docker-compose up -d --force-recreate

# Clean up old images
echo "[$(date)] Cleaning up old images" | tee -a "$LOG_FILE"
docker image prune -af --filter "until=24h"

echo "[$(date)] Container updates completed" | tee -a "$LOG_FILE"
