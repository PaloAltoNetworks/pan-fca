variable "resource_group_name" {
  description = "Resource name for peer"
  default     = "my-rg"
}

variable "peer_virtual_network_name" {
  description = "Virtual Network name for peer"
  default     = ""
}

variable "peer_remote_virtual_network_id" {
  description = "Virtual Network Id for peer"
  default     = ""
}

variable "spoke_peer_name" {
  description = "Name of the spoke peer"
  default     = ""
}

variable "peer_name" {
  description = "Name of peer"
  default     = ""
}

variable "allow_virtual_network_access" {
  default = true
}

variable "allow_forwarded_traffic" {
  default = true
}

variable "allow_gateway_transit" {
  default = false
}

variable "use_remote_gateways" {
  default = false
}
