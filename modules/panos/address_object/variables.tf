variable "name" {
  type = "string"
}

variable "value" {
  description = "Address range"
  type        = "string"
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
  type    = "string"
  default = "shared"
}
