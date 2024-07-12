#!/bin/bash
rustscan --greppable --accessible --scan-order $SCAN_MODE --batch-size $BATCH_SIZE -a $PREY_IPS > /app/output.txt 2> /var/log/cron.err
