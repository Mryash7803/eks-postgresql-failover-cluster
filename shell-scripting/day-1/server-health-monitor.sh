#!/bin/bash
# Script to check server health
LOG_FILE=~/server_health.log
DATE=$(date '+%Y-%m-%d %H:%M:%S')

CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
MEM=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
DISK=$(df / | grep / | awk '{print $5}' | sed 's/%//')

echo "[$DATE] CPU: ${CPU}% | Memory: ${MEM}% | Disk: ${DISK}%" >> $LOG_FILE
echo "Health check saved to $LOG_FILE"
