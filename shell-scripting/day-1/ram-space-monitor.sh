#!/bin/bash

usage=$(free -m | awk 'NR==2 {print $3}')

echo "Current RAM usage: ${usage}MiB"

if [ "$usage" -gt 4096 ]; then
    echo "Warning: RAM usage is high!"
else
    echo "RAM usage is healthy."
fi
