variable "location" {
  description = "Location/Region"
}

variable "route_table_name" {
  description = "Name of Route Table"
  default = "Test"
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

variable "resource_group_name" {
  default     = "mainrg"
}
