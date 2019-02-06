# Create the public IP address
resource "azurerm_public_ip" "pip" {
  count                        = "${length(var.app_gw_pip_count)}"
  name                         = "${var.app_gw_name}-pip"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  public_ip_address_allocation = "${var.public_ip_address_allocation}"
  sku						   = "Standard"

  tags {
     displayname = "${join("", list("PublicNetworkinterfaces", ""))}"
     }
}


#Create Application Gateway
resource "azurerm_application_gateway" "network" {
  name                = "${var.app_gw_name}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"

  sku {
    name     = "${var.app_gw_sku_name}"
    tier     = "${var.app_gw_sku_tier}"
    capacity = "${var.app_gw_sku_cap}"
  }

  gateway_ip_configuration {
    name      = "${var.gw_ip_config_name}"
    subnet_id = "${var.gw_ip_config_subnet_id}"
  }

  frontend_port {
    name = "${var.gw_frontend_port_name}"
    port = "${var.gw_frontend_port}"
  }

  frontend_ip_configuration {
    name                 = "${var.gw_ip_config_frontend_name}"
    public_ip_address_id = "${azurerm_public_ip.pip.id}"
  }

  backend_address_pool {
    name = "${var.backend_address_pool_name}"
  }

  backend_http_settings {
    name                  = "${var.backend_http_settings_name}"
    cookie_based_affinity = "${var.backend_http_settings_cookie_aff}"
    port                  = "${var.backend_http_settings_port}"
    protocol              = "${var.backend_http_settings_proto}"
    request_timeout       = "${var.backend_http_settings_timeout}"
  }

  http_listener {
    name                           = "${var.http_listener_name}"
    frontend_ip_configuration_name = "${var.gw_ip_config_frontend_name}"
    frontend_port_name             = "${var.gw_frontend_port_name}"
    protocol                       = "${var.http_listener_proto}"
  }

  request_routing_rule {
    name                       = "${var.request_routing_rule_name}"
    rule_type                  = "${var.request_routing_rule_type}"
    http_listener_name         = "${var.http_listener_name}"
    backend_address_pool_name  = "${var.backend_address_pool_name}"
    backend_http_settings_name = "${var.backend_http_settings_name}"
  }
}