# output "app_gw_id" {
#   value = "${azurerm_application_gateway.network.id}"
# }

//output "app_gw_auth_cert" {
//  value = "${azurerm_application_gateway.network.authentication_certificate}"
//}

# output "app_gw_fe_id" {
#   value = "${azurerm_application_gateway.network.frontend_ip_configuration.id}"
# }

# output "app_gw_fe_name" {
#   value = "${azurerm_application_gateway.network.frontend_ip_configuration.name}"
# }

# output "app_gw_fe_priv_ip" {
#   value = "${azurerm_application_gateway.network.frontend_ip_configuration.private_ip_address}"
# }

# output "app_gw_fe_pip_id" {
#   value = "${azurerm_application_gateway.network.frontend_ip_configuration.public_ip_address_id}"
# }

# output "app_gw_be_http_settings_id" {
#   value = "${azurerm_application_gateway.network.backend_http_settings.id}"
# }

# output "app_gw_be_http_settings_probe_id" {
#   value = "${azurerm_application_gateway.network.backend_http_settings.probe_id}"
# }

output "app_gw_be_pool_id" {
  value = "${azurerm_application_gateway.network.backend_address_pool.*.id}"
}

# output "app_gw_be_pool_fqdn_list" {
#   value = "${azurerm_application_gateway.network.backend_address_pool.fqdn_list}"
# }

# output "app_gw_be_pool_ip_address_list" {
#   value = "${azurerm_application_gateway.network.backend_address_pool.ip_address_list}"
# }

# output "app_gw_config_id" {
#   value = "${azurerm_application_gateway.network.gateway_ip_configuration.id}"
# }

# output "app_gw_http_listener_id" {
#   value = "${azurerm_application_gateway.network.http_listener.id}"
# }

# output "app_gw_http_listener_certificate_id" {
#   value = "${azurerm_application_gateway.network.http_listener.ssl_certificate_id}"
# }

//output "app_gw_waf_config" {
//  value = "${azurerm_application_gateway.network.waf_configuration}"
//}

# output "app_gw_request_routing_id" {
#   value = "${azurerm_application_gateway.network.request_routing_rule.id}"
# }

# output "app_gw_request_routing_rule_path_map_id" {
#   value = "${azurerm_application_gateway.network.request_routing_rule.url_path_map_id}"
# }

//output "app_gw_ssl_cert" {
//  value = "${azurerm_application_gateway.network.ssl_certificate}"
//}