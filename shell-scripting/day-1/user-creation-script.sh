#!/bin/bash

LOGFILE="/var/log/user_creation.log"

while read -r username; do

    if id "$username" &>/dev/null; then
         echo "$(date): $username already exists" >> "$LOGFILE"
    else
         useradd -m "$username"
         echo "$(date): $username created" >> "$LOGFILE"
    fi
done < users.txt


