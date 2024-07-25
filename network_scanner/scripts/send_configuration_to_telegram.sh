# Get ports

function log_message () {
  local message="$1"
  printf "$(date '+%d %B %Y %T %:z') [%s] - $message" "${TZ}" >> "$APP_LOG_FILE" 2>&1
}

function get_ports() {

  # Global variables
  ports=""

  # If Port Range and Ports is set
  if [[ -n "$PORTS" && -n "$PORT_RANGE" ]]; then
    log_message "PORTS AND PORT_RANGE COULD NOT BE SET BOTH"
    exit 1
  fi

  # If Port Range and Ports is empty
  if [[ -z "$PORTS" && -z "$PORT_RANGE" ]]; then
    ports="0-65535"
  # If Ports is set
  else
    ports="$PORTS$PORT_RANGE"
  fi
}

# Send PortQatyran configuration to chat
function send_configuration_to_telegram () {
  local message="<b>PortQatyran Configuration</b>%0A----------------------%0A<b>Timezone: </b>$TZ%0A<b>Scan mode: </b>$SCAN_MODE %0A<b>Notifications mode: </b>$NOTIFICATION_MODE %0A<b>Batch size: </b>$BATCH_SIZE %0A<b>Scanned ports: </b>${ports} %0A<b>Excluded ports: $EXCLUDE_PORTS</b>%0A"
  local url="https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage"
  local time="600"
  local status_code

  while [ "$status_code" != 200 ]
  do
    # Send message with IP and ports to telegram
    status_code=$(curl --silent --output "$TMP_LOG_FILE" -L --max-time "$time" --write-out '%{http_code}' -d "chat_id=$TELEGRAM_CHAT_ID&disable_web_page_preview=1&parse_mode=html&text=$message" "$url")
    log_message "Sent PortQatyran configuration to Telegram. Telegram API response: "
    # Output in log file
    cat "$TMP_LOG_FILE" >> "$APP_LOG_FILE" 2>&1
    sleep .5   # Delay for stability
  done
}

# Use functions
get_ports
send_configuration_to_telegram
