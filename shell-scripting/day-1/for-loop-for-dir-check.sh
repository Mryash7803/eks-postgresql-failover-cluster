#!/bin/bash

# Use the first argument if provided, otherwise default to /var/log
DIR="${1:-/var/log}"

for file in "$DIR"/*; do
    # Check if it is a file AND if it is empty
    if [ -f "$file" ] && [ ! -s "$file" ]; then
        echo "$(basename "$file") : Empty"
    
    # Check if it is a file AND if it is NOT empty
    elif [ -f "$file" ] && [ -s "$file" ]; then
        echo "$(basename "$file") : Not Empty"
    fi
done
