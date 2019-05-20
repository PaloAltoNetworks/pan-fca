#Variable EIP
variable "availability_zones" {
  type    = "list"
  default = [""]
}

variable "vpc_exist" {
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