#!/bin/bash

# Get date start of scan
function get_date () {
  local date_without_tz
  date_without_tz=$(date "+%d %B %Y %T %:z")
  local date_with_tz="[${date_without_tz} $TZ]"

  # For script outside executing
  echo "$date_with_tz"

  echo "$date_with_tz" >> "$APP_LOG_FILE" 2>&1
}


# Start network scan
function rustscan () {

  # If Port Range and Ports is set
  if [[ -n "$PORTS" && -n "$PORT_RANGE" ]]; then
    echo "PORTS AND PORT_RANGE COULD NOT BE SET BOTH" >> "$APP_LOG_FILE" 2>&1
    echo "Scan failed" >> "$APP_LOG_FILE" 2>&1
    exit 1
  fi

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
    echo "No ports was found"
    # Write in logs "no ports"
    echo "No ports was found" >> "$APP_LOG_FILE" 2>&1
  else
    # For script outside executing
    cat "$RAW_OUTPUT_FILE"
    cat "$RAW_OUTPUT_FILE" >> "$APP_LOG_FILE" 2>&1
  fi

  # For script outside executing
  printf "Scan completed. \nRaw output written to %s \nLogs written to %s\n" "$RAW_OUTPUT_FILE" "$APP_LOG_FILE"

  printf "Scan completed. \nRaw output written to %s \nLogs written to %s\n" "$RAW_OUTPUT_FILE" "$APP_LOG_FILE" >> "$APP_LOG_FILE" 2>&1
}


# Parse rustscan output to needed format
function parse_rustscan () {
  local input_file="$RAW_OUTPUT_FILE"   # Assign the input file path
  local output_dir="$APP_DB_PATH"   # Assign the output directory path

  # Check if the input file exists
  if [ ! -f "$input_file" ]; then
    echo "File $input_file not found!"   # Print an error message if input file does not exist
    echo "File $input_file not found!" >> "$APP_LOG_FILE" 2>&1   # Log the error to a log file
    exit 1   # Exit the function with error status
  fi

  # Create the output directory if it doesn't exist
  mkdir -p "$output_dir"

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
    local telegram_ports=""
    local start_port=${sorted_ports[0]}
    local end_port=${sorted_ports[0]}

    # Отсортировать порты в промежутки для Telegram
    for ((i = 1; i < ${#sorted_ports[@]}; i++)); do
      if ((sorted_ports[i] == end_port + 1)); then
        end_port=${sorted_ports[i]}
      else
        if ((start_port == end_port)); then
          telegram_ports+=" <code>$start_port</code>,"   # Add single port if range is one port
        else
          telegram_ports+=" <code>$start_port-$end_port</code>,"   # Add port range if range is more than one port
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

    # Remove leading space, if any
    telegram_ports=$(echo "$telegram_ports" | sed 's/^ //')

    # Add to text file
    local data

    # Create a file with IP address as the filename in the specified directory
    local output_file="${output_dir}${ip}.txt"
    data=$(echo "$ports" | tr ',' '\n')

    # Write ports to the file, each on a new line
    echo "$data" > "$output_file"

    # Send information to Telegram
    send_info_to_telegram "$ip" "$telegram_ports" "$output_file"
  done < "$input_file"

  # Print completion message and log it
  printf '\nConversion completed. \nData written to directory %s\n' "$output_dir" >> "$APP_LOG_FILE" 2>&1
}

# Function to send information to Telegram with message splitting
function send_info_to_telegram () {
  local ip=$1   # IP address parameter
  local ports=$2   # Ports information parameter
  local input_file=$3
  local max_length=4096   # Maximum message length for Telegram

  # Convert ports string to an array for easier handling
  IFS=', ' read -r -a port_array <<< "$ports"

  # Initialize the first part of the message with IP address
  local message="<b>IP address: </b>$ip%0A<b>Opened ports:</b>"

  # Initialize the current length of the message
  local message_length=${#message}   # Start with the length of message_part1

  # Build the message content
  for port in "${port_array[@]}"; do
    local port_formatted="<code>$port</code>,"   # Format the port with <code> tags
    message+=" $port_formatted"
    message_length=$(( message_length + ${#port_formatted} ))
  done
    message=${message::-1}
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
    # Output in log file
    cat "$TMP_LOG_FILE" >> "$APP_LOG_FILE" 2>&1
    sleep .5   # Delay for stability
  done
}

# Function to send a message to Telegram
function send_file_to_telegram () {
  local ip="$1"
  local input_file="$2"   # Message parameter
  local message="<b>IP address: </b>$ip%0A<b>Opened ports</b>: Too many ports for Telegram message. All ports are in the file below."
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
      cat "$TMP_LOG_FILE" >> "$APP_LOG_FILE" 2>&1
      sleep .5
      if [ "$message_status_code" = 200 ]; then
        message_status_sent=true
      fi
    fi

    printf "%s" "$file_status_sent"
    if ! $file_status_sent; then
      # Send file with ports
      file_status_code=$(curl -L --silent --output "$TMP_LOG_FILE" --max-time "$time" --write-out '%{http_code}' -F document=@"$input_file" "$url/sendDocument?chat_id=$TELEGRAM_CHAT_ID")
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
get_date
rustscan

# If file is empty
if [ ! -s "$RAW_OUTPUT_FILE" ]; then
  # Do not run parse_rustscan
  exit 1
else
  parse_rustscan
fi
