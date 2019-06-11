
output "routetable_id" {
  description = "The id of the newly created Route Table"
  value       = "${azurerm_route_table.route_table.id}"
}