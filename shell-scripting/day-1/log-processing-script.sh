#!/bin/bash

LOGFILE="/var/log/messages"
LOGFILE2="/var/log/secure"
REPORT="/tmp/log_report.txt"

MSG_ERROR=$(grep -ic "error" "$LOGFILE")
MSG_WARNING=$(grep -ic "warning" "$LOGFILE")

SEC_ERROR=$(grep -ic "error" "$LOGFILE2")
SEC_WARNING=$(grep -ic "warning" "$LOGFILE2")
SEC_FAILED=$(grep -Eic "failed|failure|invalid|denied|authentication" "$LOGFILE")
echo "===== Log Report =====" > "$REPORT"
echo "Generated: $(date)" >> "$REPORT"
echo "" >> "$REPORT"

echo "Messages Log ($LOGFILE)" >> "$REPORT"
echo "Errors   : $MSG_ERROR" >> "$REPORT"
echo "Warnings : $MSG_WARNING" >> "$REPORT"
echo "" >> "$REPORT"

echo "Secure Log ($LOGFILE2)" >> "$REPORT"
echo "Errors   : $SEC_ERROR" >> "$REPORT"
echo "Warnings : $SEC_WARNING" >> "$REPORT"
echo "Failed/Auth issues : $SEC_FAILED" >> "$REPORT"

cat "$REPORT"
