#!/bin/bash

function log_message () {
  local message="$1"
  printf "$(date '+%d %B %Y %T %:z') [%s] - $message" "${TZ}" >> "$APP_LOG_FILE" 2>&1
}

# Function to send a message to Telegram
function send_message_to_telegram () {
  local message="$1"   # Message parameter
  local url="https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage"   # Telegram API URL
  local time="600"   # Maximum timeout for curl request
  local status_code
  while [ "$status_code" != 200 ]
  do
    # Send message with IP and ports to telegram
    status_code=$(curl --silent --output "$TMP_LOG_FILE" -L --max-time "$time" --write-out '%{http_code}' -d "chat_id=$TELEGRAM_CHAT_ID&disable_web_page_preview=1&parse_mode=html&text=$message" "$url")
    log_message "Sent message to Telegram. Telegram API response: "
    # Output in log file
    cat "$TMP_LOG_FILE" >> "$APP_LOG_FILE" 2>&1
    sleep .5   # Delay for stability
  done
}

# Main
send_message_to_telegram "<b>NEW SCAN STARTED</b>%0A----------------------%0A"

# Check notification mode
if [ "$NOTIFICATION_MODE" = "aggresive" ]; then
  /bin/bash /app/scripts/aggresive_mode.sh
else
  /bin/bash /app/scripts/passive_mode.sh
fi
