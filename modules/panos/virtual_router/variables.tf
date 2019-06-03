variable "name" {
  default = "default"
}

variable "template" {
  type = "string"
}

variable "interfaces" {
  type    = "list"
  default = ["ethernet1/1"]
}

variable "vsys" {
  type    = "string"
  default = "vsys1"
}

variable "type" {
  default = "panorama"
}
