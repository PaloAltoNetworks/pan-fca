variable "subnet_names" {
  description = "List of Subnet Names to be created"
  type        = "list"
  default     = [""]
}

variable "vnet_name" {
  description = "Name of vNet to Deploy Subnets into"
  type        = "string"
  default     = ""
}

variable "subnet_prefixes" {
  description = "List of Subnet Prefixes to be generated"
  type        = "list"
  default     = [""]
}

variable "resource_group_name" {
  default     = "mainrg"
}

variable "nsg_id" {
  type    = "string"
  default = ""
}

variable "mgmt_subnet" {
  type = "string"
  default = ""
}