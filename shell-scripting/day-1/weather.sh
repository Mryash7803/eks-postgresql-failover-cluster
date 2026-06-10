#!/bin/bash

API_KEY="fd3608e7eece47ac96675934261006"
CITY="AHMEDABAD"

response=$(curl -s "https://api.weatherapi.com/v1/current.json?key=$API_KEY&q=$CITY&aqi=no")

temp=$(echo "$response" | jq -r '.current.temp_c')

echo "Current temperature in $CITY: ${temp}°C"
echo "$(date): ${temp}°C" >> weather_log.txt
