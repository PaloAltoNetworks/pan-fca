variable "location" {
  default = ""
}

variable "resource_group_name" { 
  default = ""
}

##### Load Balancer

variable "frontend_private_ip_address" {
  default = "10.217.127.40"
}


#####Spoke

variable "spoke_count" {
  default = ""
}
variable "spoke_vnet_name" {
  default = ""
}

variable "spoke_resource_group_name" {
  description = "Resource Group name has to be same numbers as spoke_count"
  default = []
}

variable "spoke_address_space" {
  description = "Spoke CIDR has to be same value as spoke_count"
  default = []
}

variable "spoke_subnet_prefixes" {
  default = []
}

variable "spoke_subnet_names" {
  default = []
  
}

# Routing

variable "route_table_name" {
  default = ""
}

variable "route_name" {
  default = ""
}

variable "next_hop_type" {
    default = "VirtualAppliance"
}

variable "address_prefix_route" {
  default = "0.0.0.0/0"
}

variable "next_hop_ip" {
  default = "10.0.0.1"
}

variable "privateloadbalancer" {
  description = "This Value has to be set when an Private Loadbalancer is present and the Trust Interface of the Firewall should be in the Trust Pool. 1 or 0 (1 = Present)"
  default = "1"
}

variable "publicloadbalancer" {
  description = "This Value has to be set when an Public Loadbalancer is present and the Trust Interface of the Firewall should be in the Trust Pool. 1 or 0 (1 = Present)"
  default = "0"
}