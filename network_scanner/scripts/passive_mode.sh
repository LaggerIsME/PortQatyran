#!/bin/bash

function log_message () {
  local message="$1"
  printf "\n$(date '+%d %B %Y %T %:z') [%s] - $message" "${TZ}" >> "$APP_LOG_FILE" 2>&1
}




# Start network scan
function rustscan () {

  # If Port Range and Ports is set
  if [[ -n "$PORTS" && -n "$PORT_RANGE" ]]; then
    log_message "PORTS AND PORT_RANGE COULD NOT BE SET BOTH"
    log_message "Scan failed"
    exit 1
  fi

  log_message "Scan started"

  # If Port Range and Ports is empty
  if [[ -z "$PORTS" && -z "$PORT_RANGE" ]]; then
    /usr/bin/rustscan --greppable --accessible --scan-order "$SCAN_MODE" --batch-size "$BATCH_SIZE" --addresses "$PREY_IPS" > "$RAW_OUTPUT_FILE" 2>> "$APP_LOG_FILE"
  # If Ports is set
  elif [ -n "$PORTS" ]; then
    /usr/bin/rustscan --greppable --accessible --scan-order "$SCAN_MODE" --batch-size "$BATCH_SIZE" --ports "$PORTS" --addresses "$PREY_IPS" > "$RAW_OUTPUT_FILE" 2>> "$APP_LOG_FILE"
  # Else if Port Range is set
  else
    local port_range="--range $PORT_RANGE"
    # If Exclude Ports is set
    if [[ -n "$EXCLUDE_PORTS" ]]; then
      port_range="$port_range --exclude-ports $EXCLUDE_PORTS"
    fi
    /usr/bin/rustscan --greppable --accessible --scan-order "$SCAN_MODE" --batch-size "$BATCH_SIZE" $port_range --addresses "$PREY_IPS" > "$RAW_OUTPUT_FILE" 2>> "$APP_LOG_FILE"
  fi

  # If file is empty
  if [ ! -s "$RAW_OUTPUT_FILE" ]; then
    # For script outside executing
    log_message "No ports was found"
  fi

  log_message "Scan completed. \nRaw output written to $RAW_OUTPUT_FILE \nLogs written to $APP_LOG_FILE"
}

# Parse rustscan output to needed format
function parse_rustscan () {
  local input_file="$RAW_OUTPUT_FILE"   # Assign the input file path
  local output_dir="$APP_DB_PATH"
  local tmp_output_dir="$TMP_DB_PATH"

  # Check if the input file does not exist
  if [ ! -f "$input_file" ]; then
    log_message "File $input_file not found!"
    exit 1   # Exit the function with error status
  fi

  # Create the output directory if it doesn't exist
  mkdir -p "$output_dir"
  mkdir -p "$tmp_output_dir"

  # Read the input file line by line
  while IFS= read -r line; do
    # Extract IP address and ports from each line
    local ip
    ip=$(echo "$line" | awk '{print $1}')
    local ports
    ports=$(echo "$line" | awk -F'-> ' '{print $2}' | tr -d '[]')

    # Convert ports to an array and sort them numerically
    IFS=',' read -r -a port_array <<< "$ports"
    local sorted_ports
    sorted_ports=($(echo "${port_array[@]}" | tr ' ' '\n' | sort -n | tr '\n' ' '))

    # Create a string with port ranges in HTML code format
    local new_ports=""

    # Create a file with IP address as the filename in the specified directory
    local tmp_output_file="${tmp_output_dir}${ip}.txt"
    local output_file="${output_dir}${ip}.txt"
    local data
    data=$(echo "$ports" | tr ',' '\n')
#    # Write ports to the file, each on a new line
#    echo "$data" > "$tmp_output_file"
    # Check if the input file does not exist
    if [ ! -f "$output_file" ]; then
      echo "$data" > "$output_file"
      # Send information to Telegram
      log_message "In ${ip} address were found ports: $ports"
      send_info_to_telegram "$ip" "$ports" "$output_file"
    else
      # Sort ports in Telegram
      for ((i = 1; i < ${#sorted_ports[@]}; i++)); do
        local port=${sorted_ports[i]}
        if ! grep -qw "$port" "$output_file"; then
          # Add new ports in file
          echo "$port" >> "$output_file"
          # Add new ports in new file
          echo "$port" >> "$tmp_output_file"
          new_ports+="$port,"
        fi
      done
        log_message "In ${ip} address were found ports: $new_ports"
        # If variable has new_ports then send it
        if [ -n "$new_ports" ]; then
          send_info_to_telegram "$ip" "$new_ports" "$tmp_output_file"
        fi

        # Delete data after cycle
        echo "" > "$tmp_output_file"
    fi
  done < "$input_file"

  # Print completion message and log it
  log_message "Conversion completed. Data written to directory $output_dir"
}

# Function to send information to Telegram with message splitting
function send_info_to_telegram () {
  local ip=$1   # IP address parameter
  local ports=$2   # Ports information parameter
  local input_file=$3
  local max_length=4096   # Maximum message length for Telegram

  # Convert ports string to an array for easier handling
  IFS=', ' read -r -a port_array <<< "$ports"

  # Sort ports numerically
  local sorted_ports
  sorted_ports=($(echo "${port_array[@]}" | tr ' ' '\n' | sort -n | tr '\n' ' '))
  local telegram_ports=""
  local start_port=${sorted_ports[0]}
  local end_port=${sorted_ports[0]}

  # Sort ports in Telegram
  for ((i = 1; i < ${#sorted_ports[@]}; i++)); do
    if ((sorted_ports[i] == end_port + 1)); then
      end_port=${sorted_ports[i]}
    else
      if ((start_port == end_port)); then
        telegram_ports+="<code>$start_port</code>,"   # Add single port if range is one port
      else
        telegram_ports+="<code>$start_port-$end_port</code>,"   # Add port range if range is more than one port
      fi
      start_port=${sorted_ports[i]}
      end_port=${sorted_ports[i]}
    fi
  done

  # Add the last port range or single port
  if ((start_port == end_port)); then
    telegram_ports+=" <code>$start_port</code>"
  else
    telegram_ports+=" <code>$start_port-$end_port</code>"
  fi

  # Initialize the first part of the message with IP address
  local message="<b>New ports were found</b>%0A----------------------%0A<b>IP address: </b>${ip}%0A<b>Opened ports:</b>${telegram_ports}"

  # Initialize the current length of the message
  local message_length=${#message}   # Start with the length of message_part1
  local last_symbol_message
  last_symbol_message=${message: -1}

  # Check for last symbol
  if (( last_symbol_message == "," )); then
    message=${message::-1}
  fi

  # Check if the message length exceeds the maximum allowed for Telegram messages
  if (( message_length > max_length )); then
    send_file_to_telegram "$ip" "$input_file"
  else
    # If message length is within limits, send as a regular message
    send_message_to_telegram "$message"
  fi
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

# Function to send a message to Telegram
function send_file_to_telegram () {
  local ip="$1"
  local input_file="$2"   # Message parameter
  local message="<b>New ports were found</b>%0A----------------------%0A<b>IP address: </b>${ip}%0A<b>Opened ports</b>: Too many ports for Telegram message. All ports are in the file below."
  local url="https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN"   # Telegram API URL
  local time="600"   # Maximum timeout for curl request
  local message_status_code
  local message_status_sent=false
  local file_status_code
  local file_status_sent=false

  while [ "$message_status_sent" != true ] && [ "$file_status_sent" != true ]
  do

    # Check message sent statys
    if ! $message_status_sent; then
      # Send message with IP to telegram
      message_status_code=$(curl -L --silent --output "$TMP_LOG_FILE" --max-time "$time" --write-out '%{http_code}' -d "chat_id=$TELEGRAM_CHAT_ID&disable_web_page_preview=1&parse_mode=html&text=$message" "$url/sendMessage")
      log_message "Sent message to Telegram. Telegram API response: "
      cat "$TMP_LOG_FILE" >> "$APP_LOG_FILE" 2>&1
      sleep .5
      if [ "$message_status_code" = 200 ]; then
        message_status_sent=true
      fi
    fi

    if ! $file_status_sent; then
      # Send file with ports
      file_status_code=$(curl -L --silent --output "$TMP_LOG_FILE" --max-time "$time" --write-out '%{http_code}' -F document=@"$input_file" "$url/sendDocument?chat_id=$TELEGRAM_CHAT_ID")
      log_message "Sent file to Telegram. Telegram API response: "
      cat "$TMP_LOG_FILE" >> "$APP_LOG_FILE" 2>&1
      sleep .5   # Delay for stability
      if [ "$file_status_code" = 200 ]; then
        file_status_sent=true
      fi
    fi
  done
}

# "Main"
# Use functions
rustscan

# If file is empty
if [ ! -s "$RAW_OUTPUT_FILE" ]; then
  # Do not run parse_rustscan
  exit 1
else
  parse_rustscan
fi

log_message "Script execution completed"