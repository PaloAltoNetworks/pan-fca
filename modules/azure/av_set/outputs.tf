
 output "availability_set_id" {
  description = "id of the provisoned av set."
  value       = "${azurerm_availability_set.avset.id}"
}

output "name" {
  value       = "${azurerm_availability_set.avset.name}"
}