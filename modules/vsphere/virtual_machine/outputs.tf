output "vm_id" {
  value = "${vsphere_virtual_machine.vm.*.id}"
}

output "datastore_id" {
  value = "${vsphere_virtual_machine.vm.*.datastore_id}"
}

output "vm_tools_status" {
  value = "${vsphere_virtual_machine.vm.*.vmware_tools_status}"
}