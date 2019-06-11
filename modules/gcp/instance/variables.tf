variable "nb_instances" {
  description = "Number of Instances to Create"
  default     = "1"
}

variable "instance_name" {
  description = "Name of instances to create and append by 1"
  default     = "panfw"
}

variable "machine_type" {
  description = "Type of instance"
}

variable "zone" {
  description = "GCP Zone to associate with"
}

variable "machine_cpu" {
  description = "GCP Machine CPU"
}

variable "enable_ip_forward" {
  description = "Enable IP Forwarding"
  type        = "string"
  default     = true
}

variable "allow_stop_for_update" {
  description = "Allow stopping instance for updates"
  type        = "string"
  default     = true
}

variable "bootstrap_bucket" {
  description = "VM-Series Bootstrap Bucket to access"
  type        = "string"
  default     = ""
}

variable "management-sub_self_link" {
  description = "Management Interface Network Self Link"
  type        = "string"
  default     = ""
}

variable "untrust-sub_self_link" {
  description = "Untrust Interface Network Self Link"
  type        = "string"
  default     = ""
}

variable "trust-sub_self_link" {
  description = "Trust Interface Network Self Link"
  type        = "string"
  default     = ""
}

variable "image" {
  description = "GCP PANOS VM-Series Image"
  type        = "string"
  default     = ""
}

variable "scopes" {
  description = "Service Account Scoping Name"
  type        = "string"
  default     = ""
}
