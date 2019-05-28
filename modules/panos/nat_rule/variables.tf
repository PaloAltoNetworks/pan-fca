variable "rule_type" {
  description = "Is the Rule for Firewall or Panorama?"
  type        = "string"
  default     = "panorama"
}

variable "rule_name" {
  description = "Name of NAT Policy"
  type        = "string"
}

variable "device_group" {
  description = "Name of Panorama Device Group"
  type        = "string"
  default     = ""
}

variable "rulebase_type" {
  description = "Options are pre-rulebase, post-rulebase, or rulebase"
  type        = "string"
  default     = "pre-rulebase"
}

variable "source_zones" {
  description = "NAT Policy Source Zones specified"
  type        = "list"
  default     = ["any"]
}

variable "source_addresses" {
  description = "NAT Policy Source Addresses specified"
  type        = "list"
  default     = ["any"]
}

variable "destination_zone" {
  description = "NAT Policy Destination Zone specified"
  type        = "string"
  default     = "any"
}

variable "destination_addresses" {
  description = "NAT Policy Destination Addresses specified"
  type        = "list"
  default     = ["any"]
}

variable "destination_interface" {
  description = "NAT Policy Destination Interface specified"
  type        = "string"
  default     = "any"
}

variable "service" {
  description = "NAT Policy Service destination port"
  type        = "string"
  default     = "any"
}

variable "tp_interface" {
  description = ""
  type        = "string"
  default     = "any"
}

variable "tp_int_address" {
  description = ""
  type        = "string"
  default     = "none"
}

variable "translated_address" {
  description = ""
  type        = "string"
  default     = ""
}

variable "bi_directional" {
  description = ""
  type        = "string"
  default     = false
}

variable "destination_tp_static_ip_address" {
  description = ""
  type        = "string"
  default     = ""
}

variable "destination_tp_port" {
  description = ""
  default     = 0
}

variable "disabled" {
  type    = "string"
  default = false
}
