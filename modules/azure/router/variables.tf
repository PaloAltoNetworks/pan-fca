variable "resource_group_name" {
  description = "Resource Group Name"
}

variable "location" {
  description = "Location/Region"
}

variable "route_table_name" {
  description = "Name of Route Table"
}

variable "routes" {
  description = "List of routes to add to the route table"
  default = []
}

variable "gateway" {
  description = "Next Hop of route"
  default = ""
}

variable "cidr" {
  description = "Address Prefix"
  default = ""
}

variable "next_hop_type" {
  description = "type of next hop"
  default = ""
}
