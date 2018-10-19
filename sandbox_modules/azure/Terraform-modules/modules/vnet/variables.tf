variable "vnet_name" {
  description = "Name of the vnet to create"
  default     = "mainvnet"
}

variable "resource_group_name" {
  description = "Default resource group name that the network will be created in."
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
  /*
  type  = "map"

    default = {
      Management = "10.217.127.64/27"
      Trust = "10.217.127.32/27"
      Untrust = "10.217.127.0/27"
      EgressLB = "10.217.127.96/27"
    
    }
    */
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

variable "tags" {
  description = "The tags to associate with your network and subnets."
  type        = "map"

  default = {
    tag1 = ""
    tag2 = ""
  }
}
