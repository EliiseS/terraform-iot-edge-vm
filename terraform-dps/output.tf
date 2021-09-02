output "iot_edge_vm_public_ssh" {
  value = module.iot_edge.public_ssh
}

output "iot_edge_vm_private_ssh" {
  value     = module.iot_edge.private_ssh
  sensitive = true
}

output "CONTAINER_REGISTRY_SERVER" {
  value = module.container_registry.container_registry_server
}

output "CONTAINER_REGISTRY_USERNAME" {
  value = module.container_registry.container_registry_username
}

output "CONTAINER_REGISTRY_PASSWORD" {
  value     = module.container_registry.container_registry_password
  sensitive = true
}

output "IOTHUB_CONNECTION_STRING" {
  value     = module.iot_hub.iothub_connection_string
  sensitive = true
}

output "IOTHUB_EVENTHUB_CONNECTION_STRING" {
  value     = module.iot_hub.iothub_eventhub_connection_string
  sensitive = true
}

output "IOTHUB_NAME" {
  value = module.iot_hub.iot_hub_name
}
output "IOT_HUB_RESOURCE_ID" {
  value = module.iot_hub.iot_dps_resource_id
}

output "IOTHUB_SKU" {
  value = module.iot_hub.iot_hub_sku
}

output "IOT_EDGE_DEVICE_NAME" {
  value = module.iot_edge.edge_device_name
}

output "DPS_RESOURCE_ID" {
  value = module.iot_hub.iot_dps_resource_id
}

output "DPS_SCOPE_ID" {
  value = module.iot_hub.iot_dps_scope_id
}

output "DPS_NAME" {
  value = module.iot_hub.iot_dps_name
}

output "DPS_ROOT_CA_NAME" {
  value = var.dps_root_ca_name
}


