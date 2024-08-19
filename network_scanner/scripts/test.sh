#!/bin/bash

output_file="output.txt"

function run_nmap() {
  nmap -Pn --open 127.0.0.1 -T5 -oG $output_file
}

function nmap_output_to_rustscan_format() {
  local filtered_output
  filtered_output=$(grep -v -E "^#|Status: Up" $output_file | cut -d' ' -f2,4- | sed -n -e 's/Ignored.*//p' | awk '{printf "%s -> [", $1; $1=""; for(i=2; i<=NF; i++) { a=a""$i; }; split(a,s,","); for(e in s) { split(s[e],v,"/"); printf "%s,", v[1]}; a=""; printf "]\n" }' | sed -n -e 's/,]/]/p')
  echo "$filtered_output" > $output_file
}

# Main
run_nmap
nmap_output_to_rustscan_format

