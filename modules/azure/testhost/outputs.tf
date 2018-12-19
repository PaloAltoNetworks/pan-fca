
output "network_interface_private_ip_vm" {
  description = "private ip addresses of the vm nic"
  value       = "${azurerm_network_interface.nic.*.private_ip_address}"
}

output "public_ip_id" {
  description = "id of the public ip address provisoned."
  value       = "${azurerm_public_ip.pip.*.id}"
}

output "vm_created" {
  description = "List of VMs created"
  value = "${zipmap(
    azurerm_virtual_machine.vm.*.name, azurerm_public_ip.pip.*.ip_address)}"
}