#!/usr/bin/env python3
import json
import os
from subprocess import run


# Create certificates
dir_path = os.path.dirname(os.path.realpath(__file__))
run(f"/bin/bash {dir_path}/../dps/create_identity_and_ca_certs.sh", shell=True)

# Read certificates into a json object
device_name = os.environ["IOT_EDGE_DEVICE_NAME"]
data = {}
with open(
    f"{dir_path}/../../certs/gen/certs/iot-edge-device-identity-{device_name}-full-chain.cert.pem"
) as file:
    data["identity_certificate"] = file.read()
with open(
    f"{dir_path}/../../certs/gen/private/iot-edge-device-identity-{device_name}.key.pem"
) as file:
    data["identity_certificate_key"] = file.read()
with open(
    f"{dir_path}/../../certs/gen/certs/iot-edge-device-ca-{device_name}-ca-full-chain.cert.pem"
) as file:
    data["ca_certificate"] = file.read()
with open(
    f"{dir_path}/../../certs/gen/private/iot-edge-device-ca-{device_name}-ca.key.pem"
) as file:
    data["ca_certificate_key"] = file.read()

print(json.dumps(data))
