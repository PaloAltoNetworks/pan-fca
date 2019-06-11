variable "subnetwork_name" {
  description = "GCP Subnetwork Name"
}

variable "subnetwork_cidr" {
  description = "GCP Subnetwork CIDR"
}

variable "network_self_link" {
  description = "GCP Network Self Link"
}

variable "region" {
  description = "GCP Region"
}

variable "google_access" {
  description = "Private Google Access True | False"
  default     = false
}
