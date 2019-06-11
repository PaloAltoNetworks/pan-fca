output "azurerm_lb_id" {
  description = "the id for the azurerm_lb resource"
  value       = "${azurerm_lb.azlb.id}"
}

output "azurerm_lb_frontend_ip_configuration_untrust" {
  description = "the frontend_ip_configuration for the azurerm_lb resource"
  value       = "${azurerm_lb.azlb.frontend_ip_configuration[0]}"
}

output "azurerm_lb_frontend_ip_configuration_trust" {
  description = "the frontend_ip_configuration for the azurerm_lb resource"
  value       = "${azurerm_lb.azlb.frontend_ip_configuration[1]}"
}

output "azurerm_lb_probe_ids" {
  description = "the ids for the azurerm_lb_probe resources"
  value       = "${azurerm_lb_probe.azlb.*.id}"
}

output "azurerm_lb_backend_address_pool_id_untrust" {
  description = "the id for the azurerm_lb_backend_address_pool resource"
  value       = "${azurerm_lb_backend_address_pool.untrust_be.id}"
}

output "azurerm_lb_backend_address_pool_id_trust" {
  description = "the id for the azurerm_lb_backend_address_pool resource"
  value       = "${azurerm_lb_backend_address_pool.trust_be.id}"
}

output "azurerm.untrust.load_distribution" {
  value = "${azurerm_lb_rule.untrust_lb_rule.*.load_distribution}"
}

output "azurerm.trust.load_distribution" {
  value = "${azurerm_lb_rule.trust_lb_rule.*.load_distribution}"
}
