output "servicebus_id" {
  value = ["${azurerm_servicebus_namespace.pa-sb.*.id}"]
}

output "servicebus_primary_key" {
  value = ["${azurerm_servicebus_namespace.pa-sb.*.default_primary_key}"]
}

output "servicebus_primary_key_con_string" {
  value = ["${azurerm_servicebus_namespace.pa-sb.*.default_primary_connection_string}"]
}

output "servicebus_secondary_key" {
  value = ["${azurerm_servicebus_namespace.pa-sb.*.default_secondary_key}"]
}

output "servicebus_secondary_key_con_string" {
  value = ["${azurerm_servicebus_namespace.pa-sb.*.default_secondary_connection_string}"]
}

output "servicebus_location" {
  value = ["${azurerm_servicebus_namespace.pa-sb.*.location}"]
}