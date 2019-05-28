
output "network_security_group_id_open" {
  description = "id of the security group provisioned"
  value       = "${azurerm_network_security_group.open.id}"
}

output "network_interface_ids_Management" {
  description = "ids of the vm Trust nics provisoned."
  value       = "${azurerm_network_interface.Management.*.id}"
}

output "network_interface_private_ip_management" {
  description = "private ip addresses of the vm trust nics"
  value       = "${azurerm_network_interface.Management.*.private_ip_address}"
}

output "public_ip_id" {
  description = "id of the public ip address provisoned."
  value       = "${azurerm_public_ip.pip.*.id}"
}

output "public_ip_address" {
  description = "The actual ip address allocated for the resource."
  value       = "${azurerm_public_ip.pip.*.ip_address}"
}

output "panorama_created" {
  value = "${zipmap(
    azurerm_virtual_machine.panorama.*.name, azurerm_public_ip.pip.*.ip_address)}"
}