variable "template" {
  description = "Panorama template name"
  default     = ""
}

variable "name" {
  description = "Static Route Name"
  type        = "string"
}

variable "vr_name" {
  description = "Virtual Router Name"
  type        = "string"
}

variable "destination" {
  description = "Destination IP Range must be in /Cidr notation"
}

variable "type" {
  description = "ip-address , Next-VR, or None"
  default = "ip-address"
}

variable "next_hop" {
}