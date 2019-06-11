variable "location" {
  description = "Azure Region Name"
  type        = "string"
}

variable "resource_group_name" {
  description = "Azure Resource Group Name for Application Gateway"
  type        = "string"
}

variable "app_gw_name" {
  description = "Application Gateway Name"
  type        = "string"
  default     = "App_GW"
}

variable "app_gw_sku_tier" {
  description = "Application Gateway SKU Tier"
  type        = "string"
  default     = "Standard"
}

variable "app_gw_sku_name" {
  description = "Application Gateway SKU Name"
  type        = "string"
  default     = "Standard_Small"
}

variable "app_gw_sku_cap" {
  description = "Application Gateway SKU Capacity"
  type        = "string"
  default     = 2
}

variable "gw_ip_config_subnet_id" {
  description = "Gateway Subnet ID"
  type        = "string"
}

variable "gw_ip_config_name" {
  description = "Gateway Name"
  type        = "string"
  default     = "GW_IP_Name"
}

variable "gw_frontend_port_name" {
  description = "Gateway Frontend Port Name"
  type        = "string"
  default     = "App-GW-Frontend-Name"
}

variable "gw_frontend_port" {
  description = "Gateway Frontend Port"
  type        = "string"
  default     = 80
}

variable "gw_ip_config_frontend_pip_id" {
  description = "Gateway Frontend Subnet ID"
  type        = "string"
  default     = ""
}

variable "gw_ip_config_frontend_name" {
  description = "Gateway Frontend Name"
  type        = "string"
  default     = "App_GW_Frontend_name"
}

variable "backend_address_pool_name" {
  description = "Backend Address Pool Name"
  type        = "string"
  default     = ""
}

variable "backend_http_settings_name" {
  description = "Backend http/https Settings"
  type        = "string"
  default     = "HTTP_Backend"
}

variable "backend_http_settings_cookie_aff" {
  description = "Backend http/https Cookie Affinity"
  type        = "string"
  default     = "Disabled"
}

variable "backend_http_settings_port" {
  description = "Backend http/https port"
  type        = "string"
  default     = 80
}

variable "backend_http_settings_proto" {
  description = "Backend http/https protocol (Either HTTP or HTTPS)"
  type        = "string"
  default     = "Http"
}

variable "backend_http_settings_timeout" {
  description = "Backend http/https timeout value"
  type        = "string"
  default     = 1
}

variable "http_listener_name" {
  description = "Http Listener Name"
  type        = "string"
  default     = "HTTP_Listener"
}

variable "http_listener_proto" {
  description = "Http Listener Protocol"
  type        = "string"
  default     = "Http"
}

variable "request_routing_rule_name" {
  description = "request_routing_rule_name"
  type        = "string"
  default     = "Routing_Rule_Name"
}

variable "request_routing_rule_type" {
  description = "request_routing_rule_type"
  type        = "string"
  default     = "Basic"
}

variable "public_ip_address_allocation" {
  description = "(Required) Defines how an IP address is assigned. Options are Static or Dynamic."
  default     = "dynamic"
}

variable "tags" {
  type = "map"

  default = {
    source = "terraform"
  }
}

variable "app_gw_pip_count" {
  description = "Number of App Gateways to deploy"
  type        = "string"
  default     = 1
}

variable "ssl_certificate" {
  default = ""
}

variable "waf_configuration" {
  default = ""
}

variable "authentication_certificate" {
  default = ""
}

variable "appgwpipsku" {
  description = "Standard or Basic. At the moment is only Basic possible "
  default = "basic"
}

variable "app_gw_be_pool_id" {
  default = ""
}
