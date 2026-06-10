#!/bin/bash

URL="https://api.github.com"

status_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 "$URL")

if [ "$status_code" -eq 200 ]; then
    echo "Service is UP (HTTP $status_code)"
else
    echo "Service is DOWN or having issues (HTTP $status_code)"
fi
