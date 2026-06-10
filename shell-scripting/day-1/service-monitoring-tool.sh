#!/bin/bash

DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/1503828376144576522/ZXdp6KaDeH3RvzbjkjzpsX9KdtQqPKbz4Q-TzTyBJXEEEA000suiOfY_V-O5rEq1EAOy"
URL_FILE="urls.txt"

check_service() {
    url="$1"

    status_code=$(curl -s -o /dev/null -w "%{http_code}" -L --max-time 5 "$url")

    if [[ "$status_code" =~ ^2 ]]; then
        echo "$url is UP - HTTP $status_code"
    else
        echo "$url is DOWN - HTTP $status_code"

        curl -s -H "Content-Type: application/json" \
            -X POST \
            -d "{\"content\":\"ALERT: $url is DOWN. HTTP Status: $status_code\"}" \
            "$DISCORD_WEBHOOK_URL"
    fi
}

while IFS= read -r url || [ -n "$url" ]; do
    [[ -z "$url" ]] && continue
    check_service "$url"
done < "$URL_FILE"
