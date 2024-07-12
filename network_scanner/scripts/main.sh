#!/bin/bash


# Global variables
raw_output_file="/app/output.txt"
portqatyran_log_file="/var/log/portqatyran.log"
portqatyran_error_file="/var/log/portqatyran.err"
portqatyran_db_path="/app/db/"


# Get date start of scan
function get_date () {
  local date_without_tz=$(date "+%d %B %Y %T %:z")
  local date_with_tz="${date_without_tz} $TZ"
  echo "$date_with_tz" >> $portqatyran_log_file
}


# Start network scan
function rustscan () {
  # Run rustcan
  /bin/bash rustscan --greppable --accessible --scan-order "$SCAN_MODE" --batch-size "$BATCH_SIZE" -a "$PREY_IPS" > $raw_output_file 2>> $portqatyran_error_file

  # If file is empty
  if [ ! -s "/app/output.txt" ]; then
    echo "No ports was found" >> $portqatyran_log_file
  else
    cat /app/output.txt >> $portqatyran_log_file
  fi

  printf "Scan completed. \nRaw output written to /app/output.txt \nErrors written to /var/log/portqatyran.err \nLogs written to /var/log/portqatyran.log\n" >> $portqatyran_log_file
}


# Parse rustcan output to need format
function parse_rustscan () {
  # Variables
  local input_file=$raw_output_file
  local output_dir=$portqatyran_db_path

  # Check if the specified input file exists
  if [ ! -f "$input_file" ]; then
    echo "File $input_file not found!" 2>> $portqatyran_error_file
    exit 1
  fi

  # Create the output directory if it doesn't exist
  mkdir -p "$output_dir"

  # Read the file line by line
  while IFS= read -r line
  do
    # Extract IP address and ports
    ip=$(echo "$line" | awk '{print $1}')
    ports=$(echo "$line" | awk -F'-> ' '{print $2}' | tr -d '[]')

    # Create a file named after the IP address in the specified directory
    output_file="${output_dir}/${ip}"

    # Write ports to the file, each on a new lines
    echo "$ports" | tr ',' '\n' > "$output_file"
  done < "$input_file"

  printf 'Conversion completed. \nOutput written to directory %s\n' "$output_dir" >> $portqatyran_log_file
}

# Use functions
get_date
rustscan
parse_rustscan