#!/bin/bash

set -euo pipefail

################################################################
#
# 0.  Prerequisites
#
################################################################

# Hostname as returned by `hostname` command on device to be
# configured as IoT Edge device.
device_id=${IOT_EDGE_DEVICE_NAME}
certgen_path=../../certs
cert_root=${certgen_path}/gen

###############################################################################
#
# 1.  Create IoT Edge device identity certificates.  Device identity certificates
#     are used to provision IoT Edge devices if you choose to use X.509 certificate
#     authentication. These certificates work whether you use manual provisioning or
#     automatic provisioning through the Azure IoT Hub Device Provisioning Service (DPS).
#
#     Device identity certificates go in the Provisioning section of the config file
#     on the IoT Edge device.
#
###############################################################################

# The value of device_id will be used for the IoT Edge device in IoT Hub.
# The device identity certificate must have its common name (CN) set to the
# device ID that you want the device to have in your IoT hub.

/bin/bash "${certgen_path}"/certGen.sh create_edge_device_identity_certificate "${device_id}" >/dev/null

###############################################################################
#
# 2.  Create IoT Edge device CA certificates.  Every IoT Edge device going to production
#     needs a device CA certificate that's referenced from the config file. The device
#     CA certificate is responsible for creating certificates for modules running on the
#     device. It's also necessary for gateway scenarios, because the device CA certificate
#     is how the IoT Edge device verifies its identity to downstream devices.
#
#     Device CA certificates go in the Certificate section of the config.yaml file on
#     the IoT Edge device
#
###############################################################################

# Create the IoT Edge device CA certificate and private key.  Provide a name for
# the CA certificate.  The name passed to the create_edge_device_ca_certificate
# command should *NOT* be the same as the *hostname* parameter in the config file,
# or the *device's ID* in IoT Hub.
device_id_ca_name=${device_id}-ca
/bin/bash "${certgen_path}"/certGen.sh create_edge_device_ca_certificate "${device_id_ca_name}" >/dev/null

echo ""
echo "Device certificates: "
echo ""
ls -al "${cert_root}"/certs/iot-edge-device-*.cert.pem
ls -al "${cert_root}"/private/iot-edge-device-*.key.pem
