#!/bin/bash

while read -r ip; do
    if ping -c 1 "$ip" > /dev/null 2>&1; then
        echo "$ip is UP"
    else
        echo "$ip is down"
    fi
done < servers.txt
