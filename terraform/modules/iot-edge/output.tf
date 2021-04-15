output "public_ssh" {
  value = "ssh -i ../../.ssh/id_rsa ${local.vm_user_name}@${azurerm_public_ip.iot_edge.fqdn}"
}
