variable "resource_group_name" {
  description = "Resource name for peer"
  default = "test"
}

variable "virtual_network_name" {
description = "Virtual Network name for peer"
default = ""
}

variable "remote_virtual_network_id" {
description = "Virtual Network Id for peer"
default = ""
}

variable "hub_remote_virtual_network_id" {
description = "Virtual Network Id for peer"
default = ""
}

variable "spoke_peer_name" {
description = "Name of the spoke peer"
default = ""
}

variable "spoke_resource_group_name" {
  description = "Resource name for peer"
  default = "test"
}

variable "spoke_virtual_network_name" {
description = "Virtual Network name for peer"
default = ""
}



variable "virtual_network_access" {
  description = "Define here if the network access is allowe (True or false)"
  default = "true"
}

variable "forwarded_traffic" {
  description = "Define here if the forwarded_traffic is allowe (True or false)"
  default = "false"
}

variable "gateway_transit" {
  description = "Define here if the gateway_transit is allowe (True or false)"
  default = "false"
}

variable "remote_gateways" {
  description = "Define here if the remote_gateways is allowe (True or false)"
  default = "false"
}