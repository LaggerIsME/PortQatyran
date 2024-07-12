#!/bin/bash

echo "[DATE_OF_SCRIPT_START]"

# Check if the correct number of arguments - input file and output file - are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <input_file> <output_file>" 2>> /var/log/cron.err
    exit 1
fi

input_file=$1
output_file=$2

# Check if the specified input file exists
if [ ! -f "$input_file" ]; then
    echo "File $input_file not found!" 2>> /var/log/cron.err
    exit 1
fi

# Create an empty JSON object
echo "{" > "$output_file"

# Use awk to process each line of the input file
awk -F ' -> ' '{
    # $1 - IP address
    # $2 - array of ports in square brackets

    # Remove square brackets
    gsub(/\[|\]/, "", $2)

    # Format the line as "IP": [ports]
    printf " \"%s\": [%s],\n", $1, $2
}' "$input_file" >> "$output_file"

# Remove the trailing comma and close the JSON object
sed -i '$ s/,$//' "$output_file"
echo "}" >> "$output_file"

echo "Conversion completed. Output written to $output_file" >> /var/log/cron.log
