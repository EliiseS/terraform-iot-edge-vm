terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.14.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_id" "prefix" {
  byte_length = 4
}

locals {
  resource_prefix = lower(random_id.prefix.hex)
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.resource_prefix}-rg-iotedge"
  location = var.location
}

module "iot_hub" {
  source              = "./modules/iot-hub"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  resource_prefix     = local.resource_prefix
}

module "iot_edge" {
  source                        = "./modules/iot-edge"
  resource_prefix               = local.resource_prefix
  iot_hub_name                  = module.iot_hub.iot_hub_name
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = var.location
  vm_user_name                  = var.edge_vm_user_name
  edge_device_connection_string = module.iot_hub.edge_device_connection_string
}
