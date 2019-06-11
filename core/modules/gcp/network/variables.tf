variable "project" {
  description = "Project Name"
  type        = "string"
}

variable "gcp_net_name" {
  description = "GCP Network Name"
  type        = "string"
}

variable "routing_mode" {
  description = "Routing Options: REGIONAL/GLOBAL"
  default     = "REGIONAL"
}
