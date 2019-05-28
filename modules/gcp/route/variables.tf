variable "route_name" {
  description = "GCP Route Name"
  type        = "string"
}

variable "dest_range" {
  description = "GCP Destination Range"
  type        = "string"
}

variable "network_self_link" {
  description = "GCP Network Self Link"
  type        = "string"
}

variable "instance_name" {
  description = "GCP Instance Name"
  type        = "string"
  default     = ""
}

variable "zone" {
  description = "GCP Zone"
  type        = "string"
}

variable "priority" {
  description = "GCP Priority for Rule"
  type        = "string"
}

variable "next_hop_ip" {
  description = "GCP Next Hop by IP Address"
  type        = "string"
  default     = ""
}
