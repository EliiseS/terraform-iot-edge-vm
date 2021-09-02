output "container_registry_server" {
  value = azurerm_container_registry.sense.login_server
}

output "container_registry_username" {
  value = azurerm_container_registry.sense.admin_username
}

output "container_registry_password" {
  value     = azurerm_container_registry.sense.admin_password
  sensitive = true
}
