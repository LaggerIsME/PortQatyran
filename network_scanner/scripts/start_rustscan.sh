#!/bin/bash
echo "[DATE_OF_SCRIPT_WORK]"

rustscan --greppable --accessible --scan-order $SCAN_MODE --batch-size $BATCH_SIZE -a $PREY_IPS > /app/output.txt 2>> /var/log/cron.err

echo /app/output.txt >> /var/log/cron.log

echo "Scan completed. Output written to /app/output.txt. Errors written to /var/log/cron.err" >> /var/log/cron.log