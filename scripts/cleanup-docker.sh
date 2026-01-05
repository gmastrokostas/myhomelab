#!/bin/bash
# Clean up unused Docker resources
# Usage: ./cleanup-docker.sh

set -e

LOG_FILE="${LOG_FILE:-/var/log/docker-cleanup.log}"

echo "[$(date)] Starting Docker cleanup" | tee -a "$LOG_FILE"

# Remove stopped containers
echo "[$(date)] Removing stopped containers" | tee -a "$LOG_FILE"
docker container prune -f

# Remove unused images
echo "[$(date)] Removing unused images" | tee -a "$LOG_FILE"
docker image prune -af

# Remove unused volumes
echo "[$(date)] Removing unused volumes" | tee -a "$LOG_FILE"
docker volume prune -f

# Remove unused networks
echo "[$(date)] Removing unused networks" | tee -a "$LOG_FILE"
docker network prune -f

# Show disk space saved
echo "[$(date)] Docker cleanup completed" | tee -a "$LOG_FILE"
docker system df
