#!/bin/bash

# Check if the correct number of arguments - input file and output file - are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <input_file> <output_dir>" 2>> /var/log/portqatyran.err
    exit 1
fi

input_file=$1
output_dir=$2

# Check if the specified input file exists
if [ ! -f "$input_file" ]; then
    echo "File $input_file not found!" 2>> /var/log/portqatyran.err
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

printf 'Conversion completed. \nOutput written to directory %s\n' "$output_dir" >> /var/log/portqatyran.log
