#!/bin/bash

# Start rustscan
/bin/bash /app/scripts/start_rustscan.sh

# Parse output to json
/bin/bash /app/scripts/parse_rustscan_txt_to_json.sh /app/output.txt /app/output.json