#!/bin/bash

# Add env variables for cron
env >> /etc/environment

# Global variables
portqatyran_log_file="/var/log/portqatyran.log"

# Get date start of scan
function get_date () {
  local date_without_tz
  date_without_tz=$(date "+%d %B %Y %T %:z")
  local date_with_tz="[${date_without_tz} $TZ]"
  echo "$date_with_tz" >> $portqatyran_log_file
}

# Use functions
get_date

echo "Added env variables" >> $portqatyran_log_file

# Show ASCII logo
/bin/bash /app/scripts/ascii_logo.sh

# Add cron
/usr/sbin/cron >> $portqatyran_log_file 2>> $portqatyran_log_file

# Send tool configuration
/bin/bash /app/scripts/send_configuration_to_telegram.sh >> $portqatyran_log_file 2>> $portqatyran_log_file

# Set docker in background mode
/usr/bin/tail -f /var/log/portqatyran.log