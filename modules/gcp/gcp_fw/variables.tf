variable "google_compute_network" {
  description = "VPC Self Link"
}

variable "gcp_fw_name" {
  description = "Firewall Name"
}

variable "allow_tags" {
  description = "Source Tags for Allow Rules"
  type        = "list"
  default     = [""]
}

variable "allow_source_ranges" {
  description = "Source Ranges for allow rules"
  type        = "list"
  default     = [""]
}

variable "allow_proto" {
  description = "Protocol Allowed"
  default     = "tcp"
}

variable "allow_ports" {
  description = "Allowed ports"
  type        = "list"
  default     = [""]
}

variable "allow_ping" {
  description = "Do you want to allow ping?"
  default     = false
}

variable "gcp_fw_disable" {
  description = "Disable FW Rule?"
  default     = false
}

variable "gcp_fw_logging" {
  description = "Enable Logging for FW?"
  default     = false
}

variable "priority" {
  description = "Set a priority metric for fw"
}

variable "allow_all" {
  description = "Allow All ports and Protocols"
  default     = false
}
