variable "type" {
  description = "Panorama or not panorama"
  default     = "panorama"
}

variable "ssh" {
  description = "allow ssh"
  default     = false
}

variable "ping" {
  description = "allow ping"
  default     = false
}

variable "telnet" {
  description = "allow telnet"
  default     = false
}

variable "https" {
  description = "allow https"
  default     = false
}

variable "snmp" {
  description = "allow snmp"
  default     = false
}

variable "template" {
  description = "Panorama template name"
  default     = ""
}

variable "name" {
  description = "Interface managment profile name"
}

variable "permitted_ips" {
  description = "Permitted IP list"
  type        = "list"
  default     = [""]
}

variable "acl" {
  description = "Do you want to define acl"
  default = false
}