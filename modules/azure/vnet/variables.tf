variable "vnet_name" {
  description = "Name of the vnet to create"
  default     = "mainvnet"
}

variable "resource_group_name" {
  default     = "mainrg"
}

variable "location" {
  description = "The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
  default     = ""
}

variable "address_space" {
  description = "The address space that is used by the virtual network."
  default     = "10.217.127.0/24"
}

variable "subnet_prefixes" {
  description = "The address prefix to use for the subnet."
  default     = ["10.217.127.64/27", "10.217.127.32/27", "10.217.127.0/27", "10.217.127.96/27"]
}

variable "subnet_names" {
  description = "A list of subnets inside the vNet."
  default     = ["Management", "Trust", "Untrust", "EgressLB"]
}

variable "nsg_ids" {
  description = "A map of subnet name to Network Security Group IDs"
  type        = "map"

  default = {
    #Management = "nsgid1"
    #Trust = "nsgid3"
    #Untrust = "nsgid1"
    #EgressLB = "nsgid1"
  }
}
