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
  prefix      = "e"
}

locals {
  resource_prefix          = var.resource_prefix == "" ? lower(random_id.prefix.hex) : var.resource_prefix
  root_ca_certificate_path = var.root_ca_certificate_path == "" ? "${path.module}/../certs/gen/certs/azure-iot-test-only.root.ca.cert.pem" : var.root_ca_certificate_path
  edge_device_name         = "${local.resource_prefix}-edge-device"
}


resource "azurerm_resource_group" "rg" {
  name     = "${local.resource_prefix}-rg-iotedge-dps"
  location = var.location
}

module "iot_hub" {
  source              = "./modules/iot-hub"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  resource_prefix     = local.resource_prefix
  dps_root_ca_name    = var.dps_root_ca_name
  edge_device_name    = local.edge_device_name
}

module "iot_edge" {
  source                   = "./modules/iot-edge"
  resource_prefix          = local.resource_prefix
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  vm_user_name             = var.edge_vm_user_name
  vm_sku                   = var.edge_vm_sku
  dps_scope_id             = module.iot_hub.iot_dps_scope_id
  root_ca_certificate_path = local.root_ca_certificate_path
  edge_vm_name             = local.edge_device_name
}

module "container_registry" {
  source              = "./modules/container-registry"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  resource_prefix     = local.resource_prefix
}

