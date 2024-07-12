#!/bin/bash

# Print logo
function print_logo () {
  # Logo colors
  local blue='\033[0;94m'
  local black='\033[30m'
  local white='\033[97m'
  local bold='\033[1m'
  # Clear colors
  local clear='\033[0m'
  echo -e "${black}░░░░░░░░░░░░░░░░░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${black}░░░░░░░░░░░░░░░░░░░░   ${blue}${bold}Hi, I am PortQatyran!${black}"
  echo -e "░░░░░░░░░░░░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${black}░░░░░░░░░░░░░░░   ${blue}${bold}I am always hungry for prey in networks >:)${black}"
  echo -e "░░░░░░░░░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${black}░░░░░░░░░░░░   ${white}-------------------------------------------${black}"
  echo -e "░░░░░░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${black}░░░░░░░░░   ${blue}${bold}Description: ${clear}${white}Automated network scanner for hunting IPs and port changes${black}"
  echo -e "░░░░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${black}░░░░░░░   ${blue}${bold}Github: ${clear}${white}PortQatyran (https://github.com/LaggerIsME/PortQatyran)${black}"
  echo -e "░░░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░░░░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${black}░░░░░   ${blue}${bold}Tools: ${clear}${white}Bash, Cron, Curl, Nmap, Rustscan, Debian 12, Docker, Docker Compose${black}"
  echo -e "░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░░░░░░░░░░░░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${black}░░░░   ${blue}${bold}Based on: ${clear}${white}Rustscan (https://github.com/RustScan/RustScan)${black}"
  echo -e "░░░${blue}▒▒▒▒▒▒▒▒▒▒▒${black}▓▓██${white}░░░░░░░░░░░░░░░░░░░${blue}${black}██▓▓${blue}▒▒▒▒▒▒▒▒▒▒▒${black}░░░   ${blue}${bold}Tool creator: ${clear}${white}LaggerIsME (https://github.com/LaggerIsME)${black}"
  echo -e "░░${blue}▒▒▒▒▒▒▒▒▒▒▒${black}▓████${white}░░░░░░░░░░░░░░░░░░░${blue}${black}████▓${blue}▒▒▒▒▒▒▒▒▒▒▒${black}░░   ${blue}${bold}Logo designer: ${clear}${white}NoyanTM (https://github.com/NoyanTM)${black}"
  echo -e "░${blue}▒▒▒▒▒▒▒▒▒▒▒▒${black}▓█▓▒${white}░░░░░░░░░░░░░░░░░░░░░${blue}${black}▒▓█▓${blue}▒▒▒▒▒▒▒▒▒▒▒▒${black}░"
  echo -e "░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░░${blue}▒▒${white}░░░░${blue}▒▒${white}░░░░${blue}▒${white}░░░░${blue}▒▒${white}░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒${black}░"
  echo -e "${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░░${blue}▒▒▒${white}░░${blue}▒▒▒${white}░░░${blue}▒▒▒${white}░░${blue}▒▒▒${white}░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒${black}"
  echo -e "${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░░${blue}▒▒▒${white}░${blue}▒▒▒▒▒${white}░${blue}▒▒▒▒▒${white}░${blue}▒▒▒${white}░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒${black}"
  echo -e "${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒${black}"
  echo -e "${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒${black}"
  echo -e "${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒${black}"
  echo -e "░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒${black}░"
  echo -e "░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░░${blue}▒▒▒▒${white}░${blue}▒▒▒▒${white}░${blue}▒▒▒▒▒${white}░${blue}▒▒▒${white}░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒▒${black}░"
  echo -e "░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒${white}░░░░${blue}▒▒▒${white}░░${blue}▒▒▒${white}░░░${blue}▒▒▒${white}░░${blue}▒▒▒${white}░░░░${blue}▒▒▒▒▒▒▒▒▒▒▒▒${black}░░"
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
print_logo
