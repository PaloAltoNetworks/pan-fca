variable "name" {
  type = "string"
}

variable "template" {
  type = "string"
}

variable "vsys" {
  type    = "string"
  default = "vsys1"
}

variable "mode" {
  type    = "string"
  default = "layer3"
}

variable "static_ips" {
  type    = "list"
  default = [""]
}

variable "comment" {
  type    = "string"
  default = ""
}

variable "enable_dhcp" {
  default = true
}

variable "create_dhcp_default_route" {
  default = true
}

variable "dhcp_default_route_metric" {
  default = 10
}

variable "type" {
  type    = "string"
  default = "dhcp"
}

variable "vr_name" {
  type = "string"
}