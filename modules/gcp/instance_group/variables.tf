variable "instances" {
  type    = "list"
}

variable "name" {
  type    = "string"
}

variable "port_name" {
  type    = "string"
  default = "http"
}

variable "port" {
  type = "string"
  default = "80"
}
