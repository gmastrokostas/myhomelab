#!/bin/bash
# Check disk space and send alert if low
# Usage: ./check-disk-space.sh

set -e

# Configuration
THRESHOLD=80  # Alert if usage above this percentage
ALERT_EMAIL="${ALERT_EMAIL:-admin@homelab.local}"

# Check each mounted filesystem
df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 }' | while read output; do
    usage=$(echo $output | awk '{ print $1}' | sed 's/%//g')
    partition=$(echo $output | awk '{ print $2 }')
    
    if [ $usage -ge $THRESHOLD ]; then
        echo "WARNING: Disk space on $partition is at ${usage}%"
        
        # Send email alert (requires mail command)
        # echo "Disk space on $partition is at ${usage}%" | \
        #     mail -s "Disk Space Alert - $partition" "$ALERT_EMAIL"
    fi
done
