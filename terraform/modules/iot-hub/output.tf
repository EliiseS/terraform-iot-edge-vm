output "iot_hub_name" {
  value = azurerm_iothub.iot_hub.name
}

output "edge_device_connection_string" {
  value = shell_script.register_iot_edge_device.output["connectionString"]
}
