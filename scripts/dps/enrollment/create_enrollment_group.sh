#!/bin/bash

set -euo pipefail

################################################################
#
# 0.  Prerequisites
#
################################################################

# For convenience, set up default resource group and Azure region to save input.
az configure -d group="${RESOURCE_GROUP_NAME}" location="${RESOURCE_GROUP_LOCATION}"

###########################################################
#
# 1. Create enrollment groups
#
###########################################################
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
certgen_path=${script_dir}/../../../certs
cert_root=${certgen_path}/gen
intermediate_cert_path=${cert_root}/certs/azure-iot-test-only.intermediate.cert.pem
enrollment_id="partner-group" #TODO: think about this

# Generate string of IoT hub FQDNs.
iot_hub_hostname=""
for i in "${IOT_HUB_NAME_ARR[@]}"; do
    iot_hub_hostname="${iot_hub_hostname} $(az iot hub show -n "${i}" --query properties.hostName -o tsv)"
done

enrollment_group=$(az iot dps enrollment-group create --dps-name "${DPS_NAME}" \
                                   --enrollment-id "${enrollment_id}" \
                                   --allocation-policy hashed \
                                   --ih "${iot_hub_hostname}" \
                                   --edge-enabled true \
                                   --certificate-path "${intermediate_cert_path}")

echo "${enrollment_group}" | jq '.'
