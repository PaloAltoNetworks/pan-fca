variable "location" {
  description = "Name of the vnet to create"
  default     = "north europe"
}

variable "resource_group_name" {
  description = "Default resource group name that the network will be created in."
  default     = "mainrg"
}

variable "route_table_name" {
  default = ""
}

variable "route_name" {
  default = ""
}

variable "next_hop_type" {
    default = "VirtualNetworkGateway"
}

variable "address_prefix_route" {
  default = ""
}

variable "next_hop_ip" {
  default = ""
}
