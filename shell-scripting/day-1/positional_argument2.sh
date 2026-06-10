#!/bin/bash

# Check if $1 is NOT empty AND $1 IS a directory
if [ -n "$1" ] && [ -d "$1" ]; then
    echo "Counting files in: $1"
    count=$(ls "$1" | wc -l)
    echo "Total files: $count"
else
    echo "Error: You must provide a valid directory path."
    exit 1
fi
