#!/bin/bash

echo "====== SSL Certificate Expiery Checker ======"

read -p "Enter wbsite domain: " DOMAIN

EXPIERY_DATE=$(echo | openssl s_client -servername "$DOMAIN" -connect "$DOMAIN:443" 2>/dev/null \
| openssl x509 -noout -enddate 2>/dev/null \
| cut -d= -f2)

if [ -z "$EXPIERY_DATE" ]; then
    echo "ERROR: could not fetch SSL certificate for $DOMAIN"
    exit 1
fi

EXPIERY_SECONDS=$(date -d "$EXPIERY_DATE" +%s)
CURRENT_SECONDS=$(date +%s)

DAYS_LEFT=$(( (EXPIERY_SECONDS - CURRENT_SECONDS) / 86400))

echo "Website         : $DOMAIN"
echo "Expiery date    : $EXPIERY_DATE"
echo "Days Left       : $DAYS_LEFT"
echo "Expiery Seconds : $EXPIERY_SECONDS"
echo "Current Secconds: $CURRENT_SECONDS"

if [ "$DAYS_LEFT" -lt 0 ]; then
     echo "status        : CRITICAL - Certificate already expired"
elif [ "$DAYS_LEFT"  -le 30 ]; then
     echo "Status        : WARNING  - Certificate expires within 30 days"
else
     echo "Status        : OK  - Certificate is valid"
fi
