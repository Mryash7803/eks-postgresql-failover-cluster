#!/bin/bash

usage=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

echo "current disk usage: ${usage}%"

if [ "$usage" -gt 80 ]; then 
   echo "warning: disk space is running low"
else
   echo "Disk space is healthy "
fi
