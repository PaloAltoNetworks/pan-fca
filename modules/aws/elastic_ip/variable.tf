variable "availability_zones" {
  type    = "list"
  default = [""]
}

variable "vpc_id" {
  type    = "string"
  default = false
}

variable "tags" {
  type    = "string"
  default = ""
}

variable "eip_type" {
  default = ""
}

variable "eip_names" {
  default = ""
}