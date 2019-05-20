variable "default_route_table_association" {
  description = "TGW RT Association"
  default     = "enable"
}

variable "default_route_table_propagation" {
  description = "TGW RT Propagation"
  default     = "enable"
}

variable "auto_accept_shared_attachments" {
  description = "Auto Accept Shared Attachments"
  default     = "disable"
}

variable "tags" {
  default = ""
}
