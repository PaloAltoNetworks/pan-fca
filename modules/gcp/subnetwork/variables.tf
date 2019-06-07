variable "subnetwork_name" {
  description = "GCP Subnetwork Name"
  type = "list"
}

variable "subnetwork_cidr" {
  description = "GCP Subnetwork CIDR"
  type = "list"
}

variable "network_self_link" {
  description = "GCP Network Self Link"
  type = "list"
}

variable "region" {
  description = "GCP Region"
}

variable "google_access" {
  description = "Private Google Access True | False"
  default     = false
}
