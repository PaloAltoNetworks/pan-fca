
output "network_security_group_id_open" {
  description = "id of the security group provisioned"
  value       = "${azurerm_network_security_group.open.id}"
}

output "network_security_group_id_ssh" {
  description = "id of the security group provisioned"
  value       = "${azurerm_network_security_group.ssh.id}"
}

output "network_interface_ids_Trust" {
  description = "ids of the vm Trust nics provisoned."
  value       = "${azurerm_network_interface.Trust.*.id}"
}

output "network_interface_ids_Untrust" {
  description = "ids of the vm Trust nics provisoned."
  value       = "${azurerm_network_interface.Untrust.*.id}"
}

output "network_interface_ids_Management" {
  description = "ids of the vm Trust nics provisoned."
  value       = "${azurerm_network_interface.Management.*.id}"
}

output "network_interface_private_ip_trust" {
  description = "private ip addresses of the vm trust nics"
  value       = "${azurerm_network_interface.Trust.*.private_ip_address}"
}

output "network_interface_private_ip_untrust" {
  description = "private ip addresses of the vm trust nics"
  value       = "${azurerm_network_interface.Untrust.*.private_ip_address}"
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

# output "availability_set_id" {
#   description = "id of the availability set where the vms are provisioned."
#   value       = "${azurerm_availability_set.avset.id}"
# }

output "firewalls_created" {
  description = "List of Firewalls created"
  value = "${zipmap(
    azurerm_virtual_machine.firewall.*.name, azurerm_public_ip.pip.*.ip_address)}"
}
