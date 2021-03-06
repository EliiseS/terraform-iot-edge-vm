output "iot_hub_name" {
  value = azurerm_iothub.sense.name
}

output "iot_hub_sku" {
  value = azurerm_iothub.sense.sku.0.name
}

output "iothub_connection_string" {
  value     = azurerm_iothub_shared_access_policy.sense.primary_connection_string
  sensitive = true
}

output "iothub_eventhub_connection_string" {
  value     = "Endpoint=${azurerm_iothub.sense.event_hub_events_endpoint}/;SharedAccessKeyName=service;SharedAccessKey=${azurerm_iothub.sense.shared_access_policy.1.primary_key};EntityPath=${azurerm_iothub.sense.event_hub_events_path}"
  sensitive = true
}

output "iot_hub_resource_id" {
  value = "subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${azurerm_iothub.sense.resource_group_name}/providers/Microsoft.Devices/IotHubs/${azurerm_iothub.sense.name}"
}

output "iot_dps_resource_id" {
  value = azurerm_iothub_dps.iot_dps.id
}

output "iot_dps_scope_id" {
  value = azurerm_iothub_dps.iot_dps.id_scope
}

output "iot_dps_name" {
  value = azurerm_iothub_dps.iot_dps.name
}
output "iot_hub_id" {
  value = azurerm_iothub.sense.id
}


