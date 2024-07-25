#!/bin/bash

# Add env variables for cron
env >> /etc/environment

function log_message () {
  local message="$1"
  printf "$(date '+%d %B %Y %T %:z') [%s] - $message" "${TZ}" >> "$APP_LOG_FILE" 2>&1
}

# Use functions
log_message "Added env variables\n"

# Show ASCII logo
/bin/bash /app/scripts/ascii_logo.sh

# Add cron
/usr/sbin/cron >> "$APP_LOG_FILE" 2>&1

# Send tool configuration
/bin/bash /app/scripts/send_configuration_to_telegram.sh

# Set docker in background mode
/usr/bin/tail -f "$APP_LOG_FILE"