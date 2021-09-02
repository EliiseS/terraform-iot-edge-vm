resource "random_string" "vm_user_name" {
  length  = 10
  special = false
}

locals {
  dns_label_prefix = "${var.resource_prefix}-iot-edge"
  vm_user_name     = var.vm_user_name != "" ? var.vm_user_name : random_string.vm_user_name.result
}

### Create Virtual IoT Edge Device ###

resource "azurerm_public_ip" "iot_edge" {
  name                = "${local.dns_label_prefix}-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Dynamic"
  domain_name_label   = "a-${local.dns_label_prefix}"
}

resource "azurerm_network_security_group" "iot_edge" {
  name                = "${local.dns_label_prefix}-nsg"
  resource_group_name = var.resource_group_name
  location            = var.location

  security_rule {
    name                       = "default-allow-22"
    priority                   = 1000
    access                     = "Allow"
    direction                  = "Inbound"
    protocol                   = "Tcp"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_virtual_network" "iot_edge" {
  name                = "${local.dns_label_prefix}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "${local.dns_label_prefix}-subnet"
    address_prefix = "10.0.1.0/24"
    security_group = azurerm_network_security_group.iot_edge.id
  }

}

resource "azurerm_network_interface" "iot_edge" {
  name                = "${local.dns_label_prefix}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${local.dns_label_prefix}-ipconfig"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.iot_edge.id
    subnet_id                     = azurerm_virtual_network.iot_edge.subnet.*.id[0]
  }
}
resource "tls_private_key" "vm_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "ssh" {
  content         = tls_private_key.vm_ssh.private_key_pem
  filename        = "../.ssh/id_rsa"
  file_permission = "600"
}

resource "azurerm_linux_virtual_machine" "iot_edge" {
  name                            = "${local.dns_label_prefix}-vm"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  admin_username                  = local.vm_user_name
  disable_password_authentication = true
  admin_ssh_key {
    username   = local.vm_user_name
    public_key = tls_private_key.vm_ssh.public_key_openssh
  }

  provision_vm_agent         = false
  allow_extension_operations = false
  size                       = "Standard_DS1_v2"
  network_interface_ids = [
    azurerm_network_interface.iot_edge.id
  ]
  custom_data = base64encode(replace(file("${path.module}/cloud-init.yaml"), "<REPLACE_WITH_CONNECTION_STRING>", var.edge_device_connection_string))

  source_image_reference {
    offer     = "UbuntuServer"
    publisher = "Canonical"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
}
