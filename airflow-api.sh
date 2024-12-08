#!/usr/bin/env bash

# Check if at least 5 arguments are passed
if [ $# -lt 5 ]
then
  echo "Usage: airflow-api <airflowBaseUrl> <accessKeyId> <secretAccessKey> <method> <resource>"
  echo "       airflowBaseUrl: the base URL of the Vault server as http(s)://<host:port>"
  echo "       method: POST | PUT | GET | DELETE | PATCH"
  echo "       resource: the resource to invoke, do not prefix it with /"
  exit 1
fi

# Assign arguments to variables for better readability
airflowBaseUrl=$1
username=$2
password=$3
method=$4
resource=$5

# Validate the HTTP method
if [[ "$method" != "POST" && "$method" != "PUT" && "$method" != "DELETE" && "$method" != "GET" && "$method" != "PATCH"]]; then
  echo "Error: Invalid method. Allowed methods are POST, PUT, DELETE, GET or PATCH."
  exit 1
fi

# Prepare the curl command dynamically based on the method
if [ "$method" == "GET" ] || [ "$method" == "DELETE" ]; then
  curl -X GET --user "$username:$password" -H "Content-Type: application/json" --insecure -k $airflowBaseUrl/api/v1/$resource
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
  curl -X $method --user "$username:$password" -H "Content-Type: application/json" -d @/tmp/temp.json --insecure --silent -k $airflowBaseUrl/api/v1/$resource
fi