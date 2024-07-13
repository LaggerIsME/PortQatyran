#!/bin/bash

portqatyran_log_file="/var/log/portqatyran.log"

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

# Print logo
function print_logo () {
  # Logo colors
  local blue='\033[0;94m'
  local black='\033[30m'
  local white='\033[97m'
  local bold='\033[1m'
  local tab='   '
  # Clear colors
  local clear='\033[0m'
  echo -e "${black}░░░░░░░░░░░░░░░░░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${black}░░░░░░░░░░░░░░░░░░░░${tab}${blue}${bold}Hi, I am PortQatyran!${black}"
  echo -e "░░░░░░░░░░░░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${black}░░░░░░░░░░░░░░░${tab}${blue}${bold}I am always hungry for prey in networks >:)${black}"
  echo -e "░░░░░░░░░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${black}░░░░░░░░░░░░${tab}${white}-------------------------------------------${black}"
  echo -e "░░░░░░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${black}░░░░░░░░░${tab}${blue}${bold}Description: ${clear}${white}Automated network scanner for hunting IPs and port changes${black}"
  echo -e "░░░░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${black}░░░░░░░${tab}${blue}${bold}Github: ${clear}${white}PortQatyran (https://github.com/LaggerIsME/PortQatyran)${black}"
  echo -e "░░░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░░░░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${black}░░░░░${tab}${blue}${bold}Tools: ${clear}${white}Bash, Cron, Curl, Nmap, Rustscan, Debian 12, Docker, Docker Compose${black}"
  echo -e "░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░░░░░░░░░░░░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${black}░░░░${tab}${blue}${bold}Based on: ${clear}${white}Rustscan (https://github.com/RustScan/RustScan)${black}"
  echo -e "░░░${blue}▒▒▒▒▒▒▒▒▒▒▒${black}▓▓██${white}░░░░░░░░░░░░░░░░░░░${blue}${black}██▓▓${blue}▒▒▒▒▒▒▒▒▒▒▒${black}░░░${tab}${blue}${bold}Tool creator: ${clear}${white}LaggerIsME (https://github.com/LaggerIsME)${black}"
  echo -e "░░${blue}▒▒▒▒▒▒▒▒▒▒▒${black}▓████${white}░░░░░░░░░░░░░░░░░░░${blue}${black}████▓${blue}▒▒▒▒▒▒▒▒▒▒▒${black}░░${tab}${blue}${bold}Logo designer: ${clear}${white}NoyanTM (https://github.com/NoyanTM)${black}"
  echo -e "░${blue}▒▒▒▒▒▒▒▒▒▒▒▒${black}▓█▓▒${white}░░░░░░░░░░░░░░░░░░░░░${blue}${black}▒▓█▓${blue}▒▒▒▒▒▒▒▒▒▒▒▒${black}░"
  echo -e "░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░░${blue}▒▒${white}░░░░${blue}▒▒${white}░░░░${blue}▒${white}░░░░${blue}▒▒${white}░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒${black}░"
  echo -e "${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░░${blue}▒▒▒${white}░░${blue}▒▒▒${white}░░░${blue}▒▒▒${white}░░${blue}▒▒▒${white}░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒${black}${tab}${blue}${bold}Configuration${black}"
  echo -e "${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░░${blue}▒▒▒${white}░${blue}▒▒▒▒▒${white}░${blue}▒▒▒▒▒${white}░${blue}▒▒▒${white}░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒${black}${tab}${white}-------------------------------------------${black}"
  echo -e "${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒${black}${tab}${blue}${bold}Timezone: ${clear}${white}$TZ${black}"
  echo -e "${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒${black}${tab}${blue}${bold}Scan mode: ${clear}${white}$SCAN_MODE${black}"
  echo -e "${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒${black}${tab}${blue}${bold}Notifications mode: ${clear}${white}$NOTIFICATION_MODE${black}"
  echo -e "░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒${black}░${tab}${blue}${bold}Batch size: ${clear}${white}$BATCH_SIZE${black}"
  echo -e "░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░░${blue}▒▒▒▒${white}░${blue}▒▒▒▒${white}░${blue}▒▒▒▒▒${white}░${blue}▒▒▒${white}░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒${black}░${tab}${blue}${bold}Scanned ports: ${clear}${white}${ports}${black}"
  echo -e "░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░░${blue}▒▒▒${white}░░${blue}▒▒▒${white}░░░${blue}▒▒▒${white}░░${blue}▒▒▒${white}░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒${black}░░${tab}${blue}${bold}Excluded ports: ${clear}${white}$EXCLUDE_PORTS${black}"
  echo -e "░░░${blue}▒▒▒▒▒▒▒▒▒▒▒${white}░░░░${blue}▒▒${white}░░░░${blue}▒▒${white}░░░░${blue}▒${white}░░░░${blue}▒▒${white}░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒${black}░░"
  echo -e "░░░░${blue}▒▒▒▒▒▒▒▒▒▒${white}░░░░░░░░░░░░░░░░░░░░░░░░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒${black}░░░"
  echo -e "░░░░░${blue}▒▒▒▒▒▒▒▒▒${white}░░░░░░░░░░░░░░░░░░░░░░░░░░░${blue}▒▒▒▒▒▒▒▒▒${black}░░░░░"
  echo -e "░░░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${black}░░░░░░"
  echo -e "░░░░░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${black}░░░░░░░░"
  echo -e "░░░░░░░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${black}░░░░░░░░░░"
  echo -e "░░░░░░░░░░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${black}░░░░░░░░░░░░░"
  echo -e "░░░░░░░░░░░░░░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${black}░░░░░░░░░░░░░░░░░${clear}"
}

# Use function
get_ports
print_logo