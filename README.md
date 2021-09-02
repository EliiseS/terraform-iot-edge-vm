# terraform-iot-edge

## Terraform template to deploy IoT Edge enabled VM

Terraform template to provision an IoT Edge enabled virtual machine, IoT Hub, IoT Hub device on Azure. Iot Edge VM deployment is based on the ARM varient found at https://aka.ms/iotedge-vm-deploy and https://github.com/Azure/iotedge-vm-deploy.

## Deploy IoTEdge with terraform

1. [Authenticate to Azure with Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#authenticating-to-azure)
2. Login to Azure CLI
3. Apply terraform

    ```bash
    cd terraform/
    apply terraform
    ```

## Deploy IoTEdge and DPS with terraform

> Warning, the terraform apply currently fails due to a bug in the certificate creation. I'm hoping to fix this as soon as I have the time

1. Create Root & Intermediary certificates

    Create root and intermediary certificates for device provisioning service and IoT Edge:

    ```bash
    make dps-cert-gen
    ```

    The certificates will be created within the `certs/local-development/certs` directory.

2. [Authenticate to Azure with Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#authenticating-to-azure)
3. Login to Azure CLI
4. Apply terraform

    ```bash
    cd terraform-dps/
    apply terraform
    ```
