# Device Provisioning Service

To simplify the DPS deployment demo, the Device Provisioning Service (DPS) X.509 [certificate utility](https://docs.microsoft.com/en-us/azure/iot-edge/how-to-create-test-certificates?view=iotedge-2020-11#set-up-on-linux) has been pre-installed in the [certs](../certs) directory. For additional information on DPS certificate management, see [here](https://docs.microsoft.com/en-us/azure/iot-edge/how-to-auto-provision-x509-certs?view=iotedge-2020-11).

The following certificates must be created in order for the DPS service to function properly:

1. DPS CA root certificate: [`create_root_ca.sh`](../scripts/dps/ca/create_root_ca.sh)
2. DPS device provider intermediate certificate: [`create_intermediary_cert.sh`](../scripts/dps/ca/create_intermediary_cert.sh)

These two scripts must be run before deploying Terraform. These scripts are not run or managed by Terraform as the root certificate and intermediary certificates are not supposed to be created by infrastructure pipelines but by the certificate authority. The resulting files must be present on the file system when running Terraform. In the CI/CD pipelines the certificate files are injected into the file system via secure files.

In a production use-case these certificates should be created by a real certificate authority.

## Creation and configuration of Azure resources

Terraform is responsible for creating DPS and IoT Hub, as well as uploading and verifying root CA certificates and creating the enrollment group.

   1. DPS and IoT Hub are created and linked together in [`iot-hub/main.tf`](../terraform/modules/iot-hub/main.tf).
   2. The root CA certificate is verified using the shell script [`upload_and_verify_root_ca.sh`](../scripts/dps/enrollment/upload_and_verify_root_ca.sh). The script is run as part of the Terraform deployment. This step uses the X.509 certificate utility to create a verification certificate, which is signed with the private key of the root CA. The verification certificate is then used to establish the validity of the public root CA.
   3. The DPS enrollment group is created using the shell script [`create_enrollment_group.sh`](../scripts/dps/enrollment/create_enrollment_group.sh). The script is run as part of the Terraform deployment. This step includes uploading the intermediate certificate. Each enrollment group will require a separate device provider intermediate certificate.

## Device enrollment

At this point the DPS infrastructure is ready to enroll *devices*. A device is a physical server, virtual machine, or any other platform such as a Raspberry Pi that has been configured with the IoT Edge runtime.

The first step in the device enrollment process is to create and upload two new certificates:

- Device identity certificate, which is used by DPS when enrolling the device
- Device CA certificate, which is used by the device to secure IoT Edge modules running on the device

**Note**: These certificates must be created on a per-device basis.

The device enrollment is the responsibility of the partner. However ,scripts to do the enrollment are provided to provision edge devices for CI/CD purposes. The flow is:

1. Create the necessary certificates [`create_identity_and_ca_certs.sh`](../scripts/dps/create_identity_and_ca_certs.sh)
2. Upload the device identity and device CA certificates (including private keys) via the [cloud-init file](../terraform-dps/modules/iot-edge/cloud-init.template.yaml). The file is a Terraform template file, into which the device certificates, keys, and some other information is injected.
