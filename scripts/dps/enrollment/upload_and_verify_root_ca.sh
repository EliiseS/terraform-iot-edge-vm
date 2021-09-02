#!/bin/bash

set -euo pipefail

################################################################
#
# 0.  Prerequisites
#
################################################################
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
certgen_path=${script_dir}/../../../certs
cert_root=${certgen_path}/gen

az configure -d group="${RESOURCE_GROUP_NAME}" location="${RESOURCE_GROUP_LOCATION}"

###############################################################################
#
# 1.  Generate verification code for X.509 root certificate, cf.
#     https://docs.microsoft.com/en-us/azure/iot-dps/how-to-verify-certificates?view=iotedge-2020-11#register-the-public-part-of-an-x509-certificate-and-get-a-verification-code
#
###############################################################################

dps_root_ca_path=${cert_root}/certs/azure-iot-test-only.root.ca.cert.pem

# Upload root certificate to DPS.
# az iot dps certificate create -n "${DPS_ROOT_CA_NAME}" --dps-name "${DPS_NAME}" -p "${dps_root_ca_path}"

# Create verification code, which is used complete the proof of possession step for
# a certificate.  Use this verification code as the CN of a new certificate signed
# with the root certificate's private key.
etag=$(az iot dps certificate show -n "${DPS_ROOT_CA_NAME}" --dps-name "${DPS_NAME}" --query etag -o tsv)
verification_code=$(az iot dps certificate generate-verification-code \
    -n "${DPS_ROOT_CA_NAME}" \
    --dps-name "${DPS_NAME}" \
    --etag "${etag}" \
    --query properties.verificationCode -o tsv)

###############################################################################
#
# 2.  Digitally sign the verification code to create a verification certificate, cf.
#     https://docs.microsoft.com/en-us/azure/iot-dps/how-to-verify-certificates?view=iotedge-2020-11#digitally-sign-the-verification-code-to-create-a-verification-certificate
#     https://docs.microsoft.com/en-us/azure/iot-edge/how-to-create-test-certificates?view=iotedge-2018-06#linux-4
#
#     The common name (CN) of the verification certificate is the same as the
#     verification code.
#
###############################################################################
/bin/bash "${certgen_path}"/certGen.sh create_verification_certificate "${verification_code}" >/dev/null

echo ""
echo "DPS verification certificate: "
echo ""
ls -al "${cert_root}"/certs/iot-device-verification-code*.cert.pem
ls -al "${cert_root}"/private/iot-device-verification-code*.key.pem

###############################################################################
#
# 3.  Verify root certificate cf.
#     https://docs.microsoft.com/en-us/azure/iot-dps/how-to-verify-certificates?view=iotedge-2020-11#upload-the-signed-verification-certificate
#
###############################################################################
etag=$(az iot dps certificate show -n "${DPS_ROOT_CA_NAME}" --dps-name "${DPS_NAME}" --query etag -o tsv)
verification_cert_path=${cert_root}/certs/iot-device-verification-code.cert.pem
verify_root_cert=$(az iot dps certificate verify -n "${DPS_ROOT_CA_NAME}" \
    --dps-name "${DPS_NAME}" \
    --etag "${etag}" \
    -p "${verification_cert_path}")
echo ""
echo "${verify_root_cert}" | jq '.'
