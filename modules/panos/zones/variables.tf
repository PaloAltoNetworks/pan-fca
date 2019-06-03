variable "exclude_acls" {
  description = "IP CIDR addresses to exclude for user-id"
  type        = "list"
  default     = [""]
}

variable "enable_user_id" {
  description = "Enable user id on zone??"
  default     = false
}

variable "interfaces" {
  description = "List of interfaces to associate with zone"
  type        = "list"
  default     = [""]
}

variable "mode" {
  description = "Layer2, Layer3, HA, TAP"
  type        = "string"
  default     = "layer3"
}

variable "template" {
  description = "Panorama template name"
}

variable "name" {
  description = "Name of zone"
}
