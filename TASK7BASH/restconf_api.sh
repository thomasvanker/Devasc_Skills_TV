#!/bin/bash

# Get today's date
TODAYS_DATE=$(date +%Y-%m-%d)

# Set variables
IP_HOST=$(ip addr show enp0s3 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
RESTCONF_USERNAME="cisco"
RESTCONF_PASSWORD="cisco123!"
DATA_FORMAT="application/yang-data+json"
LOOPBACK_INTERFACE="Loopback199"
LOOPBACK_IP="10.1.99.1"

api_url_put="https://${IP_HOST}/restconf/data/ietf-interfaces:interfaces/interface=${LOOPBACK_INTERFACE}"
api_url_get="https://${IP_HOST}/restconf/data/ietf-interfaces:interfaces"
headers="-H 'Accept: ${DATA_FORMAT}' -H 'Content-type: ${DATA_FORMAT}'"
basicauth="--user ${RESTCONF_USERNAME}:${RESTCONF_PASSWORD}"
yangConfig="{\"ietf-interfaces:interface\": {\"name\": \"${LOOPBACK_INTERFACE}\",\"description\": \"RESTCONF => ${LOOPBACK_INTERFACE}\",\"type\": \"iana-if-type:softwareLoopback\",\"enabled\": true,\"ietf-ip:ipv4\": {\"address\": [{\"ip\": \"${LOOPBACK_IP}\",\"netmask\": \"255.255.255.0\"}]}}}"

# Output today's date to the text file
echo "${TODAYS_DATE}" > check_restconf_api.txt

# Output 'START REST API CALL' to the text file
echo "START REST API CALL" >> check_restconf_api.txt
echo "============" >> check_restconf_api.txt

# Output 'FIRST API CALL' to the text file
echo "FIRST API CALL" >> check_restconf_api.txt
echo "============" >> check_restconf_api.txt

# Perform PUT request
resp_put=$(curl -X PUT -k ${api_url_put} -d "${yangConfig}" ${headers} ${basicauth})

# Check the response status and output to the text file
if [[ $? -eq 0 && "${resp_put}" =~ ^HTTP/1.[01]\ 2[0-9][0-9]$ ]]; then
    echo "Status Code: ${resp_put}" >> check_restconf_api.txt
else
    echo "ERROR" >> check_restconf_api.txt
    echo "Status Code: ${resp_put}" >> check_restconf_api.txt
fi

# Output 'SECOND API CALL' to the text file
echo "SECOND API CALL" >> check_restconf_api.txt
echo "============" >> check_restconf_api.txt

# Perform GET request
resp_get=$(curl -X GET -k ${api_url_get} ${headers} ${basicauth})

# Output Status Code (realtime output) to the text file
echo "Status Code: ${resp_get}" >> check_restconf_api.txt

# Output Interfaces (realtime output) to the text file
echo "Interfaces: ${resp_get}" >> check_restconf_api.txt

# Output 'END REST API CALL' to the text file
echo "END REST API CALL" >> check_restconf_api.txt
