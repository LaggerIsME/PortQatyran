#!/bin/bash

rustscan --greppable --accessible --scan-order "$SCAN_MODE" --batch-size "$BATCH_SIZE" -a "$PREY_IPS" > /app/output.txt 2>> /var/log/portqatyran.err

# If file is empty
if [ ! -s "/app/output.txt" ]; then
echo "No ports was finded"
else
cat /app/output.txt >> /var/log/portqatyran.log
fi


printf "Scan completed. \nRaw output written to /app/output.txt \nErrors written to /var/log/portqatyran.err \nLogs written to /var/log/portqatyran.log\n" >> /var/log/portqatyran.log