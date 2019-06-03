variable "network_interface_id" {
  type    = "string"
  default = ""
}

variable "vpc_id" {
  type    = "string"
  default = false
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "name" {
  default = ""
}