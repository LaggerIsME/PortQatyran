#!/bin/bash

# Add env variables for cron
env >> /etc/environment

# Get date start of scan
function get_date () {
  local date_without_tz
  date_without_tz=$(date "+%d %B %Y %T %:z")
  local date_with_tz="[${date_without_tz} $TZ]"
  echo "$date_with_tz" >> "$APP_LOG_FILE" 2>&1
}

# Use functions
get_date

echo "Added env variables" >> "$APP_LOG_FILE"

# Show ASCII logo
/bin/bash /app/scripts/ascii_logo.sh

# Add cron
/usr/sbin/cron >> "$APP_LOG_FILE" 2>&1

# Send tool configuration
/bin/bash /app/scripts/send_configuration_to_telegram.sh >> "$APP_LOG_FILE" 2>&1

# Set docker in background mode
/usr/bin/tail -f "$APP_LOG_FILE"