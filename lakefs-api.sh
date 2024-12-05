#!/usr/bin/env bash

# Check if at least 5 arguments are passed
if [ $# -lt 5 ]
then
  echo "Usage: lakefs-api <lakeFSBaseUrl> <accessKeyId> <secretAccessKey> <method> <resource>"
  echo "       lakeFSBaseUrl: the base URL of the Vault server as http(s)://<host:port>"
  echo "       method: POST | PUT | GET"
  echo "       resource: the resource to invoke, do not prefix it with /"
  exit 1
fi

# Assign arguments to variables for better readability
lakeFSBaseUrl=$1
accessKeyId=$2
secretAccessKey=$3
method=$4
resource=$5

# Validate the HTTP method
if [[ "$method" != "POST" && "$method" != "PUT" && "$method" != "GET" ]]; then
  echo "Error: Invalid method. Allowed methods are POST, PUT, or GET."
  exit 1
fi

# base64 encode accessKeyId and secretAccessKey
credentials=$(echo "$accessKeyId:$secretAccessKey" | base64 -w 0)

# Prepare the curl command dynamically based on the method
if [ "$method" == "GET" ]; then
  curl -X GET -H "Authorization: Basic $credentials" -H "Content-Type: application/json" --insecure -k $lakeFSBaseUrl/api/v1/$resource
else
  dataFile=$6
  if [ -z "$dataFile" ]; then
    echo "Error: Data file must be provided as the 6th argument for $method request."
    exit 1
  fi

  # Check if the specified data file exists
  if [ ! -f "$dataFile" ]; then
    echo "Error: '$dataFile' file not found for $method request."
    exit 1
  fi

  envsubst < $dataFile > /tmp/temp.json
  curl -X $method -H "Authorization: Basic $credentials" -H "Content-Type: application/json" -d @/tmp/temp.json --insecure --silent -k $lakeFSBaseUrl/api/v1/$resource
fi