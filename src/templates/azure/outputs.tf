output "resource_group_name" {
  value = azurerm_resource_group.{{ name }}.name
}

output "public_ip_address" {
  value = azurerm_linux_virtual_machine.{{ name }}_vm.public_ip_address
}

output "tls_private_key" {
  value     = tls_private_key.{{ name }}_ssh.private_key_pem
  sensitive = true
}
