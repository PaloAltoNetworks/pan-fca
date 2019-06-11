variable "rule_type" {
  description = "Is the Rule for Firewall or Panorama?"
  type    = "string"
  default = "panorama"
}

variable "rule_name" {
  description = "Name of Security Policy"
  type    = "string"
}

variable "device_group" {
  description = "Name of Panorama Device Group"
  type    = "string"
  default = ""
}

variable "rulebase_type" {
  description = "Options are pre-rulebase, post-rulebase, or rulebase"
  type    = "string"
  default = "pre-rulebase"
}

variable "source_zones" {
  description = "Security Policy Source Zones specified"
  type    = "list"
  default = ["any"]
}

variable "source_addresses" {
  description = "Security Policy Source Addresses specified"
  type    = "list"
  default = ["any"]
}

variable "source_users" {
  description = "Security Policy Source Users specified"
  type    = "list"
  default = ["any"]
}

variable "hip_profiles" {
  description = "Security Policy HIP Profiles specified"
  type    = "list"
  default = ["any"]
}

variable "destination_zones" {
  description = "Security Policy Destination Zones specified"
  type    = "list"
  default = ["any"]
}

variable "destination_addresses" {
  description = "Security Policy Destination Addresses specified"
  type    = "list"
  default = ["any"]
}

variable "applications" {
  description = "Security Policy Applications specified"
  type = "list"
  default = ["any"]
}

variable "services" {
  type = "list"
  default = ["application-default"]
}

variable "categories" {
  type = "list"
  default = ["any"]
}

variable "action" {
  type = "string"
  default = "allow"
}