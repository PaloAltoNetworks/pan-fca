variable "name" {
  type = "string"
}

variable "description" {
  description = "Address object description"
  default     = ""
}

variable "tags" {
  type    = "list"
  default = ["terraform"]
}

variable "device_group" {
  description = "The device group to put the address group into"
  type        = "string"
  default     = "shared"
}

variable "static_addresses" {
  description = "The address objects to include in this statically defined address group"
  type        = "list"
  default     = [""]
}

variable "dynamic_match" {
  description = "The IP tags to include in this DAG"
  type        = "string"
  default     = ""
}

variable "type" {
  description = "Static or Dynamic address group, required because checking for list empty is not available"
  type        = "string"
  default     = "static"
}
