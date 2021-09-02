resource "azurerm_container_registry" "sense" {
  name                = "${var.resource_prefix}cr"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
}
