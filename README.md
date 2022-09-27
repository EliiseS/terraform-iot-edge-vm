# terraform-iot-edge

## Terraform template to deploy IoT Edge enabled VM

Terraform template to provision an IoT Edge enabled virtual machine, IoT Hub,
IoT Hub device on Azure. Iot Edge VM deployment is based on the ARM variant
found at <https://aka.ms/iotedge-vm-deploy> and
<https://github.com/Azure/iotedge-vm-deploy>.

## Deploy IoTEdge with terraform

1. [Authenticate to Azure with Terraform Azure
   Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#authenticating-to-azure)
2. Login to Azure CLI
3. Apply terraform

    ```bash
    cd terraform/
    apply terraform
    ```

> **NOTE**: in case there are errors when executing the
> `scripts/terraform/register_iot_edge_device.sh` script, ensure the correct
> line endings (`LF`) are used, depending on the environment. To learn more
> about how to configure line endings for your repository, check [GitHub
> Docs](https://docs.github.com/en/get-started/getting-started-with-git/configuring-git-to-handle-line-endings).

## Deploy IoTEdge and DPS with terraform

1. Create Root & Intermediary certificates

    Create root and intermediary certificates for device provisioning service
    and IoT Edge:

    ```bash
    make dps-cert-gen
    ```

    The certificates will be created within the
    [`certs/gen/certs`]([certs/gen/certs) directory. More information of how
    certificates are generated can be found in the [certificate
    README](certs/README.md).

2. [Authenticate to Azure with Terraform Azure
   Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#authenticating-to-azure)
3. Login to Azure CLI
4. Apply terraform

    ```bash
    cd terraform-dps/
    apply terraform
    ```
