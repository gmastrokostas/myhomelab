#!/bin/bash
# Check health of key services
# Usage: ./health-check.sh

set -e

echo "=== Homelab Health Check ==="
echo "Date: $(date)"
echo ""

# Check system resources
echo "=== System Resources ==="
echo "CPU Usage:"
top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'

echo ""
echo "Memory Usage:"
free -h | awk 'NR==2{printf "Used: %s / %s (%.2f%%)\n", $3, $2, $3*100/$2}'

echo ""
echo "Disk Usage:"
df -h / | awk 'NR==2{printf "Used: %s / %s (%s)\n", $3, $2, $5}'

echo ""
echo "=== Docker Status ==="
if command -v docker &> /dev/null; then
    echo "Docker service: Running"
    echo "Running containers: $(docker ps -q | wc -l)"
    echo "Total containers: $(docker ps -aq | wc -l)"
else
    echo "Docker service: Not installed"
fi

echo ""
echo "=== Network Connectivity ==="
if ping -c 1 8.8.8.8 &> /dev/null; then
    echo "Internet: Connected"
else
    echo "Internet: Disconnected"
fi

if ping -c 1 192.168.1.1 &> /dev/null; then
    echo "Gateway: Reachable"
else
    echo "Gateway: Unreachable"
fi

echo ""
echo "=== Service Status ==="

# Check common services
services=("docker" "ssh")

for service in "${services[@]}"; do
    if systemctl is-active --quiet "$service"; then
        echo "$service: ✓ Running"
    else
        echo "$service: ✗ Not running"
    fi
done

echo ""
echo "=== Recent Errors (last 10 minutes) ==="
journalctl --since "10 minutes ago" --priority=err --no-pager | tail -5

echo ""
echo "=== Health Check Complete ==="
