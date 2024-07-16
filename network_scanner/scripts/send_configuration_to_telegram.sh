# Global variables
portqatyran_log_file="/var/log/portqatyran.log"

# Get ports
function get_ports() {

  # Global variables
  ports=""

  # If Port Range and Ports is set
  if [[ -n "$PORTS" && -n "$PORT_RANGE" ]]; then
    echo "PORTS AND PORT_RANGE COULD NOT BE SET BOTH" >> $portqatyran_log_file
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
  local data="<b>PortQatyran Configuration</b>%0A%0A<b>Timezone: </b>$TZ%0A<b>Scan mode: </b>$SCAN_MODE %0A<b>Notifications mode: </b>$NOTIFICATION_MODE %0A<b>Batch size: </b>$BATCH_SIZE %0A<b>Scanned ports: </b>${ports} %0A<b>Excluded ports: $EXCLUDE_PORTS</b>%0A"
  local url="https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage"
  local time="10"

  curl -s --max-time $time -d "chat_id=$TELEGRAM_CHAT_ID&disable_web_page_preview=1&parse_mode=html&text=$data" "$url" >> $portqatyran_log_file 2>> $portqatyran_log_file
}

# Use functions
get_ports
send_configuration_to_telegram
