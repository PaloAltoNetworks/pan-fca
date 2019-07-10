variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "default_route_table_association" {
  description = "TGW RT Association"
  default     = "disable"
}

variable "default_route_table_propagation" {
  description = "TGW RT Propagation"
  default     = "disable"
}

variable "auto_accept_shared_attachments" {
  description = "Auto Accept Shared Attachments"
  default     = "disable"
}

variable "amazon_side_asn" {
  description = "Amazon Side BGP ASN for TGW"
  default     = "64515"
}

variable "vpn_ecmp_support" {
  description = "Enable ECMP for VPN Attachements"
  default     = "enable"
}

