terraform {
  required_providers {
    shell = {
      source  = "scottwinkler/shell"
      version = "1.7.7"
    }
  }
}

provider "shell" {}


resource "azurerm_iothub" "iot_hub" {
  name                          = "${var.resource_prefix}-iot-hub"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  public_network_access_enabled = true

  sku {
    name     = "S1"
    capacity = "1"
  }

  route {
    name           = "defaultroute"
    source         = "DeviceMessages"
    condition      = "true"
    endpoint_names = ["events"]
    enabled        = true
  }

  tags = {
    purpose = "testing"
  }
}

resource "shell_script" "register_iot_edge_device" {
  lifecycle_commands {
    create = "$SCRIPT create"
    read   = "$SCRIPT read"
    delete = "$SCRIPT delete"
  }

  environment = {
    IOT_HUB_NAME         = azurerm_iothub.iot_hub.name
    RESOURCE_GROUP       = azurerm_iothub.iot_hub.resource_group_name
    IOT_EDGE_DEVICE_NAME = "${var.resource_prefix}-edge-device"
    SCRIPT               = "../scripts/terraform/register_iot_edge_device.sh"
  }
}
