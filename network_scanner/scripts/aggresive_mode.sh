#!/bin/bash


# Global variables
raw_output_file="/app/output.txt"
portqatyran_log_file="/var/log/portqatyran.log"
portqatyran_db_path="/app/db/"

# Get date start of scan
function get_date () {
  local date_without_tz
  date_without_tz=$(date "+%d %B %Y %T %:z")
  local date_with_tz="[${date_without_tz} $TZ]"

  # For script outside executing
  echo "$date_with_tz"

  echo "$date_with_tz" >> $portqatyran_log_file
}


# Start network scan
function rustscan () {

  # If Port Range and Ports is set
  if [[ -n "$PORTS" && -n "$PORT_RANGE" ]]; then
    echo "PORTS AND PORT_RANGE COULD NOT BE SET BOTH" >> $portqatyran_log_file
    echo "Scan failed" >> $portqatyran_log_file
    exit 1
  fi

  # If Port Range and Ports is empty
  if [[ -z "$PORTS" && -z "$PORT_RANGE" ]]; then
    /usr/bin/rustscan --greppable --accessible --scan-order "$SCAN_MODE" --batch-size "$BATCH_SIZE" --addresses "$PREY_IPS" > $raw_output_file 2>> $portqatyran_log_file
  # If Ports is set
  elif [ -n "$PORTS" ]; then
    /usr/bin/rustscan --greppable --accessible --scan-order "$SCAN_MODE" --batch-size "$BATCH_SIZE" --ports "$PORTS" --addresses "$PREY_IPS" > $raw_output_file 2>> $portqatyran_log_file
  # Else if Port Range is set
  else
    local port_range="--range $PORT_RANGE"
    # If Exclude Ports is set
    if [[ -n "$EXCLUDE_PORTS" ]]; then
      port_range="$port_range --exclude-ports $EXCLUDE_PORTS"
    fi
    /usr/bin/rustscan --greppable --accessible --scan-order "$SCAN_MODE" --batch-size "$BATCH_SIZE" $port_range --addresses "$PREY_IPS" > $raw_output_file 2>> $portqatyran_log_file
  fi

  # If file is empty
  if [ ! -s "$raw_output_file" ]; then
    # For script outside executing
    echo "No ports was found"
    # Write in logs "no ports"
    echo "No ports was found" >> $portqatyran_log_file
  else
    # For script outside executing
    cat $raw_output_file
    cat $raw_output_file >> $portqatyran_log_file
  fi

  # For script outside executing
  printf "Scan completed. \nRaw output written to %s \nLogs written to %s\n" "$raw_output_file" "$portqatyran_log_file"

  printf "Scan completed. \nRaw output written to %s \nLogs written to %s\n" "$raw_output_file" "$portqatyran_log_file" >> $portqatyran_log_file
}


# Parse rustcan output to need format
function parse_rustscan () {
  # Variables
  local input_file=$raw_output_file
  local output_dir=$portqatyran_db_path

  # Check if the specified input file exists
  if [ ! -f "$input_file" ]; then

    # For script outside executing
    echo "File $input_file not found!"

    echo "File $input_file not found!" 2>> $portqatyran_log_file
    exit 1
  fi

  # Create the output directory if it doesn't exist
  mkdir -p "$output_dir"

  # Read the file line by line
  while IFS= read -r line
  do
    # Extract IP address and ports
    local ip
    ip=$(echo "$line" | awk '{print $1}')
    local ports
    ports=$(echo "$line" | awk -F'-> ' '{print $2}' | tr -d '[]')

    # Create a file named after the IP address in the specified directory
    output_file="${output_dir}/${ip}"

    local data
    data=$(echo "$ports" | tr ',' '\n')

    # Add spaces between comma
    local telegram_ports
    telegram_ports=$(echo "$ports" | sed 's/,/, /g')

    # Write ports to the file, each on a new lines
    echo "$data" > "$output_file"
    send_info_to_telegram "$ip" "$telegram_ports"
  done < "$input_file"

  # For script outside executing
  printf 'Conversion completed. \nData written to directory %s\n' "$output_dir"

  printf 'Conversion completed. \nData written to directory %s\n' "$output_dir" >> $portqatyran_log_file
}

function send_info_to_telegram () {
  local ip=$1
  local ports=$2
  local data="<b>IP address: </b>$ip%0A<b>Opened ports: </b>$ports"
  local url="https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage"
  local time="10"

  curl -s --max-time $time -d "chat_id=$TELEGRAM_CHAT_ID&disable_web_page_preview=1&parse_mode=html&text=$data" "$url" >> $portqatyran_log_file 2>> $portqatyran_log_file
  # Delay for Telegram
  sleep .5
}


# Use functions
get_date
rustscan

# If file is empty
if [ ! -s "$raw_output_file" ]; then
  # Do not run parse_rustscan
  exit 1
else
  parse_rustscan
fi
