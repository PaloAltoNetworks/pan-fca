variable "location" {
  description = "Regional Azure Location Name"
  type        = "string"
  default     = ""
}

variable "resource_group_name" {
  # description = "location of the nsg and associated resource group"
  # type        = "string"
  default     = "my-rg"
}

variable "nsg_name" {
  description = "The name of the network security group"
  type        = "string"
  default     = ""
}

variable "tags" {
  description = "The tags to associate with your network security group."
  type        = "map"
  default     = {}
}

variable "custom_rules" {
  description = "Custom set of security rules using this format"
  type        = "list"
  default     = []
}

# Security rules configuration
variable "source_address_prefix" {
  type    = "list"
  default = ["*"]

  # Example: ["10.0.3.0/24"]
}

variable "destination_address_prefix" {
  type    = "list"
  default = ["*"]

  # Example: ["10.0.3.0/32","10.0.3.128/32"]
}

variable "subnet_id" {
  type    = "string"
  default = ""
}

variable "destination_port_ranges" {
  description = "Destination Ports allowed"
  type = "list"
  default = ["0-65535"]
}