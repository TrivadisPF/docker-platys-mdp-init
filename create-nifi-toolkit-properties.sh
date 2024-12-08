#!/bin/bash

confDir=$1

# Input and output files
INPUT_FILE="$confDir/nifi.properties"
OUTPUT_FILE="$confDir/nifi-toolkit.properties"

# Define the keys to include and their transformations
declare -A KEYS_TO_INCLUDE=(
  ["server.host"]="baseUrl"
  ["nifi.security.keystoreType"]="keystoreType"
  ["nifi.security.keystorePasswd"]="keystorePasswd"  
  ["nifi.security.keyPasswd"]="keyPasswd"  
  ["nifi.security.truststoreType"]="truststoreType"  
  ["nifi.security.truststorePasswd"]="truststorePasswd"  
)

# Fixed entry to add to the output file
URL_ENTRY="baseUrl=https://nifi2-1:18083/nifi-api"
KEYSTORE_ENTRY="keystore=$confDir/keystore.p12"
TRUSTSTORE_ENTRY="truststore=$confDir/truststore.p12"

# Initialize the output file
: > "$OUTPUT_FILE"

# Add fixed entries
echo "$URL_ENTRY" >> "$OUTPUT_FILE"
echo "$KEYSTORE_ENTRY" >> "$OUTPUT_FILE"
echo "$TRUSTSTORE_ENTRY" >> "$OUTPUT_FILE"

# Process the input file
while IFS= read -r line; do
  # Skip empty lines or comments
  [[ -z "$line" || "$line" =~ ^# ]] && continue

  # Extract key and value
  key=$(echo "$line" | cut -d'=' -f1)
  value=$(echo "$line" | cut -d'=' -f2-)

  # Check if the key is in the inclusion list
  if [[ -v KEYS_TO_INCLUDE["$key"] ]]; then
    # Transform the key and write to output file
    echo "${KEYS_TO_INCLUDE[$key]}=$value" >> "$OUTPUT_FILE"
  fi
done < "$INPUT_FILE"
