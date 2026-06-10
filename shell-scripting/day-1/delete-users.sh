#!/bin/bash

LOGFILE="/var/log/user_deletion.log"

if [ "$EUID" -ne 0 ]; then
   echo "Please run as root: sudo ./delete-users.sh"
   exit 1
fi


while read -r username; do
  [[ -z "$username" ]] && continue


   if id "$username" &>/dev/null; then
      userdel -r "$username"
      echo "$(date): $username deleted with home directory" >> "$LOGFILE"
   else
      echo "$(date): $username does not exist" >> "$LOGFILE"
   fi

done < users.txt
