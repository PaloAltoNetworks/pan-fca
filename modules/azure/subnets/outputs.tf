output "azurerm_subnet_names" {
  description = "names of subnets"
  value = "${azurerm_subnet.subnet.*.name}"
}

output "azurerm_subnet_ids" {
  description = "Subnet IDs"
  value = ["${azurerm_subnet.subnet.*.id}"]
}