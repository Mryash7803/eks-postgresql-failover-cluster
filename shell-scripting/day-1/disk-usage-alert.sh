#!/bin/bash
: '
THRASHOLD=80
LOGFILE="/tmp/disk_usage.log"

disk_usage=$(df -h / | awk 'NR==2 {print $5}' | tr -d % )


if [ "$disk_usage" -ge "$THRASHOLD" ]; then

   echo "$(date); ALERT -Disk usage is ${disk_usage}%"  >> "$LOGFILE"

   echo "DISK usage is high: ${disk_usage}%"

else

   echo "$(date): Ok - Disk usage is ${disk_usage}%"  >> "$LOGFILE"

   echo "Disk usage is normal: ${disk_usage}%"
fi

'

THRESHOLD=80
LOGFILE="/tmp/disk_usage.log"

df -h --output=target,pcent | tail -n +2 | while read -r mount usage; do

    usage=${usage%\%}

    if [ "$usage" -ge "$THRESHOLD" ]; then
        echo "$(date): ALERT - $mount usage is ${usage}%" >> "$LOGFILE"
        echo "ALERT: $mount usage is ${usage}%"
    else
        echo "$(date): OK - $mount usage is ${usage}%" >> "$LOGFILE"
        echo "OK: $mount usage is ${usage}%"
    fi

done
